USE DATABASE SUPPLY_CHAIN_ONTOLOGY;

-- Canonical contracts. Source adapters populate these from STG_* schemas.
CREATE TABLE IF NOT EXISTS CORE.SUPPLIER (
    canonical_supplier_id VARCHAR PRIMARY KEY,
    legal_name VARCHAR NOT NULL,
    country_code VARCHAR,
    supplier_status VARCHAR,
    parent_supplier_id VARCHAR,
    duns_number VARCHAR
);

CREATE TABLE IF NOT EXISTS CORE.PART (
    canonical_part_id VARCHAR PRIMARY KEY,
    part_number VARCHAR NOT NULL,
    description VARCHAR,
    commodity VARCHAR,
    category VARCHAR,
    unit_of_measure VARCHAR,
    standard_cost NUMBER(18,4)
);

CREATE TABLE IF NOT EXISTS CORE.LOCATION (
    canonical_location_id VARCHAR PRIMARY KEY,
    location_type VARCHAR NOT NULL,
    location_name VARCHAR NOT NULL,
    region VARCHAR,
    country VARCHAR
);

CREATE TABLE IF NOT EXISTS CORE.PURCHASE_ORDER (
    purchase_order_id VARCHAR PRIMARY KEY,
    canonical_supplier_id VARCHAR NOT NULL,
    receiving_location_id VARCHAR,
    ordered_at DATE,
    expected_at DATE,
    received_at DATE,
    status VARCHAR,
    currency VARCHAR
);

CREATE TABLE IF NOT EXISTS CORE.PURCHASE_ORDER_LINE (
    purchase_order_line_id VARCHAR PRIMARY KEY,
    purchase_order_id VARCHAR NOT NULL,
    canonical_part_id VARCHAR NOT NULL,
    quantity_ordered NUMBER(18,4) NOT NULL,
    quantity_received NUMBER(18,4),
    unit_cost NUMBER(18,4),
    currency VARCHAR
);

CREATE TABLE IF NOT EXISTS CORE.SHIPMENT_EVENT (
    shipment_event_id VARCHAR PRIMARY KEY,
    purchase_order_line_id VARCHAR,
    event_type VARCHAR NOT NULL,
    event_date DATE NOT NULL,
    original_promise_date DATE,
    revised_promise_date DATE,
    quantity_received NUMBER(18,4),
    source_system VARCHAR NOT NULL,
    source_record_id VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS CORE.CUSTOMER_ORDER_LINE (
    customer_order_line_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR NOT NULL,
    canonical_part_id VARCHAR NOT NULL,
    ordered_at DATE,
    quantity_ordered NUMBER(18,4) NOT NULL,
    quantity_shipped NUMBER(18,4),
    unit_price NUMBER(18,4),
    currency VARCHAR
);

CREATE TABLE IF NOT EXISTS CORE.INVENTORY_POSITION (
    canonical_part_id VARCHAR NOT NULL,
    canonical_location_id VARCHAR NOT NULL,
    snapshot_date DATE NOT NULL,
    on_hand_units NUMBER(18,4),
    quality_inspection_units NUMBER(18,4),
    in_transit_units NUMBER(18,4),
    trailing_daily_consumption NUMBER(18,4),
    forward_daily_forecast NUMBER(18,4),
    PRIMARY KEY (canonical_part_id, canonical_location_id, snapshot_date)
);
