# Validation plan

**Plan only. The checks below have not been executed.**

## Prerequisites

- TODO: recover original source CSVs and document permitted use, version, and schemas.
- TODO: clarify attribution and obtain approval for any screenshot redistribution.
- TODO: obtain a compatible Power BI environment and work only on a separately authorized copy.
- TODO: export actual M, DAX, relationships, and parameters; inspect them for private paths/secrets before including any exports.
- TODO: agree on fact grain, sales definition, currency, date window, and denominator definitions.

## Analytical checks and acceptance evidence

| ID | Check | Evidence / acceptance condition | Status |
|---|---|---|---|
| V01 | Input provenance and schema | Authorized source/version, checksums, table/column definitions, and row counts recorded | TODO |
| V02 | Dimension integrity | Key uniqueness/blanks measured; violations explicitly resolved or documented | TODO |
| V03 | Foreign-key coverage | Unmatched counts and revenue by dimension quantified; known/unknown groups reconcile to totals | TODO |
| V04 | Fact grain and overlap | Documented natural keys, duplicate behavior, channel/date coverage, and overlap assessment; no unsupported addition of facts | TODO |
| V05 | Revenue reconciliation | Agreed source aggregations match measures at total and representative slice levels; justified numeric tolerances recorded | TODO |
| V06 | AOV | Numerator and distinct-order denominator verified; blanks, returns, and zero-denominator behavior documented | TODO |
| V07 | Customer counts and age groups | Distinct customer population reconciles; age reference date/boundaries explicit; missing ages handled | TODO |
| V08 | Top customers | `Online Sales` and `Online Revenue` definitions compared; ranking, ties, filters, and top-10 share independently checked | TODO |
| V09 | LTV label | Formula supports stated interpretation; distinguish observed-period revenue from predictive lifetime value | TODO |
| V10 | Store metrics | Eligible store population and period established; per-store totals reconcile under geographic filters | TODO |
| V11 | Date axis and chronology | Date table unique/continuous as appropriate; month number or year-month order used; growth/seasonality interpretation reassessed | TODO |
| V12 | Percentages and relationships | Denominators and relationship paths tested under representative year, product, customer, and geography filters | TODO |
| V13 | Visual consistency | Headlines, units, rounding, unknown groups, and annotations agree with recalculated measures | TODO |
| V14 | Clean refresh | A separate authorized copy refreshes from documented inputs in a tested environment; steps and failures recorded | TODO |

For each executed check, record input version, formula/query actually used, filters, expected value and its source, observed value, difference/tolerance, disposition, and reviewer. Do not invent expected results from rounded screenshots. No validation-results file should imply passes before evidence exists.

## Public-release gate

- TODO: confirm permissions for documents, data-derived figures,.
- TODO: resolve contributor attribution and review customer identifiers plus all image pixels.
- TODO: inspect candidate text for credentials, personal information, absolute paths, and unsupported claims; scan any new model definitions separately.
- TODO: inventory all proposed files and sizes; ensure PBIX/raw data/private notes/caches are absent. `.gitignore` is not a file-size or content-security mechanism.
- TODO: manually review the exact allowlisted files; broad documentation directories do not imply all future Markdown is safe.
- TODO: obtain validated, approved previews if images are to be included publicly; otherwise remove private preview references from public-facing navigation.
- TODO: resolve each analytical limitation or explicitly bound the public claims to the evidence available.
- TODO: obtain separate owner authorization before Git initialization, repository creation, committing, uploading, or publishing.

These gates are open; do not treat the dashboard figures as validated results.
