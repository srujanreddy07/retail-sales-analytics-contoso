# Retail Sales Analytics | Contoso (Power BI)

A Power BI project analyzing retail sales by product, online customer segment, and geography.

Read the [recruiter case study](docs/recruiter-case-study.md) for the business questions, dashboard design, semantic model, and validation limitations.

This was **university coursework**. It uses an **instructor-provided Contoso dataset**. My instructor gave permission to showcase the project publicly; that is not permission to redistribute the dataset or the Power BI file, so neither is included.

> **Status:** documentation of an existing dashboard. Reported values are **unverified**, the source data and the report file are not included, and recommendations are hypotheses rather than measured outcomes. Corrections listed here are **proposed, not implemented**.

## Business questions

- Which brands and product classes contribute to sales?
- Which online customer groups account for revenue?
- Which markets and stores warrant further investigation?

## Technologies

- **Power BI** – three report pages, cards, charts and slicers.
- **Power Query** – documented cleaning steps (missing geography values, removed columns, age groups, date standardization). Sources are local CSV files.
- **DAX** – 19 measures in the existing report; see [model and measures](docs/model-and-measures.md).

No SQL, Python/R, automated tests or predictive models are part of this project.

## Dashboard pages (existing)

| Page | Content |
|---|---|
| Sales Performance | Total sales, average order value, brand/product-class and continent comparisons, monthly pattern, year selection. |
| Online Customers Analysis | Online revenue and customer cards, age-group comparisons, top-customer ranking, "Customer LTV" (a revenue-per-customer measure, not a lifetime-value model). |
| Geographic Performance | Sales and store measures by continent, country and state/province. |

Screenshots are not included: they show customer identifiers and have not been cleared for publication.

## Model architecture

Two fact tables (`FactSales`, `FactOnlineSales`) and five dimensions (`DimDate`, `DimProduct`, `DimStore`, `DimGeography`, `DimCustomer`), linked by eight active many-to-one, single-direction relationships. Customers connect only to online sales; geography is reached through stores. The two facts must not be assumed additive. Details: [model and measures](docs/model-and-measures.md).

## Known limitations

Includes a month chart sorted by value rather than date, a "Customer LTV" label that overstates its formula, and unresolved overlap between the fact tables. Full list and proposed corrections: [known limitations](docs/known-limitations.md). Planned checks: [validation plan](docs/validation-plan.md).

## Proposed fixes (examples)

[`examples/`](examples/) holds suggested DAX measures and Power Query functions. **They are proposed, unimplemented and untested**: the original dashboard does not use them, and they have never been run or compiled.

## Not included

The Power BI file, source CSVs, customer-level data, the original presentation, screenshots and local connection paths.

## Data, license and attribution

The dataset is the instructor-provided Contoso data; its redistribution terms are not established, so it is excluded. No license has been chosen for this repository yet. Contributor credit for the course materials is still to be confirmed.
