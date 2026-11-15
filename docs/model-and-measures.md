# Model and measures (extracted metadata)

Source: metadata read from the report file's model definition (no data rows, no refresh, no evaluation). It documents what is **defined**, not whether results are correct. Source connection details are omitted; all seven Power Query sources are local CSV file connections.

## Relationships (8, all active, many-to-one, single-direction)

| From (many) | To (one) |
|---|---|
| `FactSales[ProductKey]` | `DimProduct[ProductKey]` |
| `FactSales[StoreKey]` | `DimStore[StoreKey]` |
| `FactSales[DateKey]` | `DimDate[DateKey]` |
| `FactOnlineSales[ProductKey]` | `DimProduct[ProductKey]` |
| `FactOnlineSales[StoreKey]` | `DimStore[StoreKey]` |
| `FactOnlineSales[DateKey]` | `DimDate[DateKey]` |
| `FactOnlineSales[CustomerKey]` | `DimCustomer[CustomerKey]` |
| `DimStore[GeographyKey]` | `DimGeography[GeographyKey]` |

This confirms that customers connect only to online sales and that geography is reached through stores. Referential-integrity assumptions are off.

## Measures (19)

| Measure | Definition | Note |
|---|---|---|
| Total Sales | `SUM(FactSales[SalesAmount])` | |
| Total Transactions | `COUNTROWS(FactSales)` | Counts fact rows; row grain unverified. |
| Avg Order Value / Sales per Transaction | `DIVIDE([Total Sales],[Total Transactions])` | Two measures, same formula; revenue per fact row, not necessarily per order. |
| Total Quantity Sold | `SUM(FactSales[SalesQuantity])` | |
| Store Count | `DISTINCTCOUNT(FactSales[StoreKey])` | Stores appearing in sales, not all stores. |
| Avg Sales per Store | `DIVIDE([Total Sales],[Store Count])` | |
| Online Sales | `SUM(FactOnlineSales[SalesAmount])` | |
| Online Transactions | `COUNTROWS(FactOnlineSales)` | Fact rows; grain unverified. |
| Total Online Customers / Customers by Age | `DISTINCTCOUNT(FactOnlineSales[CustomerKey])` | Duplicate definitions; a BLANK key counts as a value. |
| Avg Customer LTV | `DIVIDE([Online Sales],[Total Online Customers])` | Online revenue per purchasing customer in the current filter context. It is not a lifetime-value model; the label overstates it. |
| Avg Orders per Customer | `DIVIDE(COUNTROWS(FactOnlineSales),[Total Online Customers])` | Rows per customer. |
| Avg Order Online Value | `DIVIDE([Online Sales],COUNTROWS(FactOnlineSales))` | |
| Online % | `DIVIDE(FactOnlineSales[Online Sales],[Total Sales])` | Ratio across two fact tables; valid as "share of sales" only if online sales are a subset of `FactSales`, which is unverified. |
| Customer % | Online customers ÷ same measure with `ALL(DimCustomer[AgeGroup])` | Share across age groups. |
| Sales % | Online Sales ÷ same measure with `ALL(DimCustomer[AgeGroup])` | Share across age groups. |
| Total Sales % | Sales ÷ sales with `ALL(DimGeography[StateProvinceName])`, × 100 | Denominator removes only the state filter; other filters (e.g. country) still apply. |
| Store % | Store count ÷ same with `ALL(DimGeography[StateProvinceName])`, × 100 | Same caveat; scaled ×100 unlike the other share measures. |

## Observations for the validation plan

- Rename "Avg Customer LTV" (or define a real LTV) before public claims use it.
- Consolidate duplicate measures (Avg Order Value / Sales per Transaction; Total Online Customers / Customers by Age).
- Percent measures mix 0–1 and 0–100 scales; standardize formatting.
- Verify fact grain and online/in-store overlap before interpreting Online %.
