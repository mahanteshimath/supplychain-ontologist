# Supply Chain Data Manifest

Downloaded on 2026-09-09. Keep each source separate; do not merge raw files directly.

## Sources

### 1. Inventory & Supply Chain
- Folder: `inventory-supply-chain/`
- Files: `inventory-supply-chain-v1.0.0.sqlite`, `inventory-supply-chain-v1.0.0-source-csv.zip`
- Contains: suppliers, products, warehouses, purchase orders, purchase-order lines, receipts, opening balances, and inventory movements.
- Source: https://www.analyticsengineering.com/datasets/inventory-supply-chain
- License: CC BY 4.0

### 2. Purchase Orders & Supplier Performance
- Folder: `procurement-supplier-performance/`
- File: `purchase-orders-and-supplier-performance-dataset.zip`
- Contains: procurement transactions, suppliers, products, delivery dates, spend, contracts, supplier risk, currencies, and performance fields.
- Source: https://www.kaggle.com/datasets/thuandao/purchase-orders-and-supplier-performance-dataset
- License: Apache 2.0 as listed by the dataset page

### 3. Brazilian E-Commerce / Olist
- Folder: `olist-ecommerce/`
- File: `brazilian-ecommerce.zip`
- Contains: customers, orders, order items, sellers, products, payments, freight, delivery dates, and reviews.
- Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- License: CC BY-NC-SA 4.0

### 4. DataCo SMART Supply Chain
- Folder: `dataco-supply-chain/`
- File: `dataco-smart-supply-chain-for-big-data-analysis.zip`
- Contains: customer orders, products, categories, shipping modes, scheduled and actual shipping dates, delivery status, sales, profit, and clickstream data.
- Source: https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis
- License: CC0 as listed by the dataset page

### 5. Supply Chain Shipment Pricing
- Folder: `shipment-pricing/`
- File: `supply-chain-shipment-pricing-data.zip`
- Contains: health-commodity shipments, products, quantities, delivery history, pricing, logistics costs, and destination countries.
- Source: https://www.kaggle.com/datasets/apoorvwatsky/supply-chain-shipment-pricing-data
- License: Original authors' data license; verify before redistribution

### 6. NIST Sample Purchasing / Supply Chain
- Folder: `nist-purchasing/`
- File: `Sample_Data_Sets.zip`
- Contains: sample purchasing relationships among suppliers, products, and projects.
- Source: https://catalog.data.gov/dataset/sample-purchasing-supply-chain-data
- License: NIST open license / public access as listed by Data.gov

## Not downloaded as a fixed source

The Excelx Supply Chain & Logistics Dataset Generator creates data interactively rather than exposing one fixed downloadable release. It remains a reference for possible controlled synthetic test data.

## Next step

Inspect each archive and build a source registry containing table names, row grain, primary keys, fields, date fields, entities, licenses, and known limitations. Do not build cross-source joins until that registry exists.
