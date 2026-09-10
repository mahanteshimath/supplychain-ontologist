USE DATABASE SUPPLY_CHAIN_ONTOLOGY;

-- Fixed-template execution gate.
-- This procedure never executes SQL supplied in plan_json. It validates the
-- plan against GOVERNANCE.METRIC_REGISTRY and selects one approved template.

CREATE OR REPLACE PROCEDURE AGENT.EXECUTE_GOVERNED_QUERY(query_plan_id VARCHAR)
RETURNS VARIANT
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
    plan_metric_id VARCHAR;
    plan_semantic_view VARCHAR;
    plan VARIANT;
    metric_definition VARCHAR;
    result VARIANT;
BEGIN
    SELECT metric_id, semantic_view, plan_json
      INTO :plan_metric_id, :plan_semantic_view, :plan
    FROM AGENT.QUERY_PLAN
    WHERE query_plan_id = :query_plan_id
      AND decision_status = 'EXECUTE';

    IF (plan IS NULL) THEN
        RETURN OBJECT_CONSTRUCT('status', 'REFUSE', 'reason', 'Query plan is missing or not approved');
    END IF;

    SELECT definition
      INTO :metric_definition
    FROM GOVERNANCE.METRIC_REGISTRY
    WHERE metric_id = :plan_metric_id
      AND semantic_view = :plan_semantic_view
      AND status = 'ACTIVE'
    QUALIFY ROW_NUMBER() OVER (PARTITION BY metric_id ORDER BY version DESC) = 1;

    IF (metric_definition IS NULL) THEN
        RETURN OBJECT_CONSTRUCT(
            'status', 'REFUSE',
            'reason', 'Metric is not active or semantic view is not registered',
            'metric_id', plan_metric_id,
            'semantic_view', plan_semantic_view
        );
    END IF;

    -- These are the only executable templates. Add a new metric only by
    -- adding a registry row, a reviewed branch, and validation tests.
    IF (plan_metric_id = 'otd_original_commit'
        AND plan_semantic_view = 'SEMANTIC.SUPPLIER_PERFORMANCE') THEN
        SELECT OBJECT_CONSTRUCT(
            'eligible_shipments', COALESCE(SUM(eligible_shipments), 0),
            'on_time_shipments', COALESCE(SUM(on_time_shipments), 0),
            'otd_original_commit', COALESCE(DIV0(SUM(on_time_shipments), SUM(eligible_shipments)), 0)
        ) INTO :result
        FROM SEMANTIC.SUPPLIER_PERFORMANCE;
    ELSEIF (plan_metric_id = 'unit_fill_rate'
            AND plan_semantic_view = 'SEMANTIC.ORDER_FULFILLMENT') THEN
        SELECT OBJECT_CONSTRUCT(
            'units_ordered', COALESCE(SUM(units_ordered), 0),
            'units_shipped', COALESCE(SUM(units_shipped), 0),
            'unit_fill_rate', COALESCE(DIV0(SUM(units_shipped), SUM(units_ordered)), 0)
        ) INTO :result
        FROM SEMANTIC.ORDER_FULFILLMENT;
    ELSEIF (plan_metric_id = 'doi_forward_forecast'
            AND plan_semantic_view = 'SEMANTIC.INVENTORY_COVERAGE') THEN
        SELECT OBJECT_CONSTRUCT(
            'records', COUNT(*),
            'average_doi_forward_forecast', COALESCE(AVG(doi_forward_forecast), 0),
            'average_doi_available_supply', COALESCE(AVG(doi_available_supply), 0)
        ) INTO :result
        FROM SEMANTIC.INVENTORY_COVERAGE;
    ELSE
        RETURN OBJECT_CONSTRUCT(
            'status', 'REFUSE',
            'reason', 'No approved execution template exists for this metric and view',
            'metric_id', plan_metric_id,
            'semantic_view', plan_semantic_view
        );
    END IF;

    RETURN OBJECT_CONSTRUCT(
        'status', 'EXECUTE',
        'query_plan_id', query_plan_id,
        'metric_id', plan_metric_id,
        'semantic_view', plan_semantic_view,
        'definition', metric_definition,
        'result', result,
        'validation', OBJECT_CONSTRUCT('status', 'PENDING_RESULT_VALIDATION', 'raw_table_access', FALSE)
    );
END;
$$;

GRANT USAGE
ON PROCEDURE AGENT.EXECUTE_GOVERNED_QUERY(VARCHAR)
TO ROLE ROLE_APPLICATION;
