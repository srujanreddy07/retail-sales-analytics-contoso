# Known limitations of the existing dashboard

The dashboard is a course project. Figures shown in it have **not** been recalculated here, and none of the issues below has been fixed in the original report.

| Issue | Status | Needed next |
|---|---|---|
| Month chart is sorted by sales value, not calendar order | Observed in report configuration | Sort by month/year-month; reassess any growth claim. The apparent growth is not a finding. |
| Blank product classifications are filtered out | Observed | Quantify omitted revenue; keep an "Unknown" group. |
| Relationship between `FactSales` and `FactOnlineSales` unclear | Unresolved | Establish grain and overlap before adding or comparing totals. |
| Average order value divides sales by fact rows | Observed in measure definition | Verify whether a row is an order; otherwise rename. |
| "Avg Customer LTV" is online sales ÷ distinct customers | Observed in measure definition | Rename (e.g. revenue per customer) or build a true LTV. |
| Top-customer visual shows `Online Revenue` but ranks by `Online Sales` | Alias of the same measure per query metadata; formulas still unreviewed | Confirm in Power BI Desktop. |
| Customer-count headline appears inconsistent with its bars | Observed in a screenshot | Recompute from source data. |
| "Unknown Country" wording for missing state/province | Documented wording; transformation not fully reviewed | Check the Power Query step and geographic level. |
| Expansion, Economy-tier and margin recommendations | No supporting evidence | Treat as hypotheses. |
| Source CSVs and editable presentation are not available | Confirmed | The project cannot be refreshed or reproduced from this repository. |
| Data origin, license and attribution not established | Unresolved | See the README's publication notes. |

## Proposed corrections (not implemented)

These follow from the issues above and exist only as suggestions: calendar-ordered time axis, an explicit Unknown product group, renamed or consolidated measures (see [model and measures](model-and-measures.md)), one consistent percent scale, and validation of facts' grain before combining them. The checks are listed in the [validation plan](validation-plan.md).
