USE DATABASE SUPPLY_CHAIN_ONTOLOGY;

-- These views are the only query surface exposed to Cortex Analyst and the app.
CREATE OR REPLACE SECURE VIEW SEMANTIC.SUPPLIER_PERFORMANCE AS
SELECT
    po.canonical_supplier_id,
    s.legal_name AS supplier_name,
    DATE_TRUNC('QUARTER', event.event_date) AS period,
    COUNT(*) AS eligible_shipments,
    COUNT_IF(event.event_date <= event.original_promise_date) AS on_time_shipments,
    DIV0(COUNT_IF(event.event_date <= event.original_promise_date), COUNT(*)) AS otd_original_commit
FROM CORE.PURCHASE_ORDER po
JOIN CORE.SUPPLIER s ON s.canonical_supplier_id = po.canonical_supplier_id
JOIN CORE.PURCHASE_ORDER_LINE pol ON pol.purchase_order_id = po.purchase_order_id
JOIN CORE.SHIPMENT_EVENT event ON event.purchase_order_line_id = pol.purchase_order_line_id
WHERE event.event_type = 'DOCK_ARRIVAL'
GROUP BY po.canonical_supplier_id, s.legal_name, DATE_TRUNC('QUARTER', event.event_date);

CREATE OR REPLACE SECURE VIEW SEMANTIC.ORDER_FULFILLMENT AS
SELECT
    customer_id,
    canonical_part_id,
    DATE_TRUNC('MONTH', ordered_at) AS period,
    SUM(quantity_ordered) AS units_ordered,
    SUM(COALESCE(quantity_shipped, 0)) AS units_shipped,
    DIV0(SUM(COALESCE(quantity_shipped, 0)), SUM(quantity_ordered)) AS unit_fill_rate
FROM CORE.CUSTOMER_ORDER_LINE
GROUP BY customer_id, canonical_part_id, DATE_TRUNC('MONTH', ordered_at);

CREATE OR REPLACE SECURE VIEW SEMANTIC.INVENTORY_COVERAGE AS
SELECT
    canonical_part_id,
    canonical_location_id,
    snapshot_date,
    on_hand_units,
    quality_inspection_units,
    in_transit_units,
    DIV0(on_hand_units, trailing_daily_consumption) AS doi_trailing_actual,
    DIV0(on_hand_units, forward_daily_forecast) AS doi_forward_forecast,
    DIV0(on_hand_units + quality_inspection_units + in_transit_units, forward_daily_forecast) AS doi_available_supply
FROM CORE.INVENTORY_POSITION;
