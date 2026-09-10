USE DATABASE SUPPLY_CHAIN_ONTOLOGY;

INSERT INTO GOVERNANCE.METRIC_REGISTRY
    (metric_id, metric_name, definition, grain, semantic_view, date_policy, currency_policy, steward)
SELECT * FROM VALUES
    ('otd_original_commit', 'On-time delivery - original commitment', 'Dock arrival occurs on or before the original promise date.', 'shipment line', 'SEMANTIC.SUPPLIER_PERFORMANCE', 'dock_arrival_date', NULL, 'Supply Chain Performance'),
    ('unit_fill_rate', 'Unit fill rate', 'Units shipped divided by units ordered.', 'order line', 'SEMANTIC.ORDER_FULFILLMENT', 'order_date', 'transaction currency', 'Customer Fulfillment'),
    ('doi_forward_forecast', 'Days of inventory - forward forecast', 'On-hand units divided by average daily forward forecast demand.', 'part x location x snapshot date', 'SEMANTIC.INVENTORY_COVERAGE', 'snapshot_date', NULL, 'Planning')
WHERE NOT EXISTS (SELECT 1 FROM GOVERNANCE.METRIC_REGISTRY);

INSERT INTO GOVERNANCE.ENTITY_IDENTIFIER_MAP
    (canonical_entity_type, canonical_entity_id, source_system, source_identifier, match_method, match_confidence, approval_status)
SELECT * FROM VALUES
    ('SUPPLIER', 'SUP-ACME-001', 'INVENTORY', 'SUP-1001', 'approved_crosswalk', 0.9900, 'APPROVED'),
    ('SUPPLIER', 'SUP-ACME-001', 'INVENTORY', 'SUP-1044', 'approved_crosswalk', 0.9900, 'APPROVED'),
    ('SUPPLIER', 'SUP-ACME-001', 'TMS', 'VEND-88', 'approved_crosswalk', 0.9900, 'APPROVED'),
    ('PART', 'PART-PRT-A100', 'DEMO', 'PRT-A100', 'exact_identifier', 1.0000, 'APPROVED')
WHERE NOT EXISTS (SELECT 1 FROM GOVERNANCE.ENTITY_IDENTIFIER_MAP);
