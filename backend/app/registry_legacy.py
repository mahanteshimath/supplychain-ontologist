METRICS = {
    "otd_original_commit": {"name": "On-time delivery - original commitment", "definition": "Dock arrival occurs on or before the original promise date.", "grain": "shipment line", "sql_view": "SEMANTIC.SUPPLIER_PERFORMANCE", "alternatives": [{"id": "otd_confirmed", "name": "On-time delivery - revised commitment"}, {"id": "otif", "name": "On-time in-full"}]},
    "unit_fill_rate": {"name": "Unit fill rate", "definition": "Units shipped divided by units ordered.", "grain": "order line", "sql_view": "SEMANTIC.ORDER_FULFILLMENT", "alternatives": []},
    "doi_forward_forecast": {"name": "Days of inventory - forward forecast", "definition": "On-hand units divided by average daily forward forecast demand.", "grain": "part x location x snapshot date", "sql_view": "SEMANTIC.INVENTORY_COVERAGE", "alternatives": []},
}
ENTITY_ALIASES = {"acme": "SUP-ACME-001", "sup-1001": "SUP-ACME-001", "sup-1044": "SUP-ACME-001", "vend-88": "SUP-ACME-001", "prt-a100": "PART-PRT-A100", "prt-b200": "PART-PRT-B200", "prt-c300": "PART-PRT-C300"}
