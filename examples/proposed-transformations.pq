// PROPOSED, UNIMPLEMENTED AND UNTESTED. Not applied to the original report and never run or compiled.
// Written as suggested corrections; validate in Power BI Desktop on a copy before any use.
// Create a blank query named ProposedFixes; paste this whole file into Advanced
// Editor and disable load. Then invoke ONLY the selected functions as documented.
// No source data or actual connection paths are embedded. No functions were run.
// Existing source transformations are retained except the explicit proposals.
let
    // 1. Future FactOnlineSales query. Parameter sourcePath is configured locally.
    // Retains the original CSV options, types, channel logic and removal list,
    // except SalesOrderNumber and SalesOrderLineNumber are deliberately preserved.
    // Does not trim/deduplicate identifiers, filter rows, or infer order grain.
    BuildFactOnlineSales = (sourcePath as text) as table =>
        let
            Source = Csv.Document(File.Contents(sourcePath), [Delimiter=",", Columns=18, Encoding=1252, QuoteStyle=QuoteStyle.None]),
            #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
            #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers", {{"OnlineSalesKey", Int64.Type}, {"DateKey", type date}, {"StoreKey", Int64.Type}, {"ProductKey", Int64.Type}, {"PromotionKey", Int64.Type}, {"CurrencyKey", Int64.Type}, {"CustomerKey", Int64.Type}, {"SalesOrderNumber", type text}, {"SalesOrderLineNumber", Int64.Type}, {"SalesQuantity", Int64.Type}, {"SalesAmount", type number}, {"ReturnQuantity", Int64.Type}, {"ReturnAmount", type number}, {"DiscountQuantity", Int64.Type}, {"DiscountAmount", type number}, {"TotalCost", type number}, {"UnitCost", type number}, {"UnitPrice", type number}}),
            #"Removed Columns" = Table.RemoveColumns(#"Changed Type", {"PromotionKey", "CurrencyKey", "ReturnQuantity", "ReturnAmount", "DiscountQuantity", "DiscountAmount", "UnitCost"}),
            #"Added Custom" = Table.AddColumn(#"Removed Columns", "Channel", each "Online"),
            #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom", {{"Channel", type text}})
        in
            #"Changed Type1",

    // 2. Shared completed-years function. No clock-based age policy is chosen.
    // Caller MUST select "February28" or "March1" as the non-leap-year birthday
    // convention for Feb 29 births. No other anniversary is changed.
    // Missing dates or birth after reference date yield null -> Unknown band.
    // Malformed typed dates remain errors; no silent conversion/error suppression.
    AgeCompletedYears = (birthDate as nullable date, referenceDate as nullable date, leapDayPolicy as text) as nullable number =>
        if not List.Contains({"February28", "March1"}, leapDayPolicy) then
            error "Select a leap-day policy: February28 or March1."
        else if birthDate = null or referenceDate = null then
            null
        else if birthDate > referenceDate then
            null
        else
            let
                ReferenceYear = Date.Year(referenceDate),
                IsLeapBirth = Date.Month(birthDate) = 2 and Date.Day(birthDate) = 29,
                IsNonLeapReferenceYear = Date.DaysInMonth(#date(ReferenceYear, 2, 1)) = 28,
                Anniversary =
                    if IsLeapBirth and IsNonLeapReferenceYear then
                        if leapDayPolicy = "February28" then #date(ReferenceYear, 2, 28)
                        else #date(ReferenceYear, 3, 1)
                    else #date(ReferenceYear, Date.Month(birthDate), Date.Day(birthDate)),
                CompletedYears = ReferenceYear - Date.Year(birthDate)
                    - (if referenceDate < Anniversary then 1 else 0)
            in
                CompletedYears,

    // Original band thresholds/labels, with explicit Unknown for unavailable age.
    AgeGroup = (age as nullable number) as text =>
        if age = null then "Unknown"
        else if age < 0 then "Unknown"
        else if age < 25 then "Under 25"
        else if age < 35 then "25-34"
        else if age < 45 then "35-44"
        else if age < 55 then "45-54"
        else if age < 65 then "55-64"
        else "65+",

    // 3A. Alternative: age as of a fixed, explicitly selected date.
    // Pass the existing DimCustomer final step, a DATE parameter, and leap policy.
    // Adds parallel columns for reconciliation; leaves original Agegroup intact.
    // The date is a refresh-time parameter, NOT an interactive report date slicer.
    WithAgeAsOfDate = (customers as table, asOfDate as date, leapDayPolicy as text) as table =>
        if not List.Contains({"February28", "March1"}, leapDayPolicy) then
            error "Select a leap-day policy before adding fixed-date ages."
        else
            let
                WithAge = Table.AddColumn(customers, "AgeAsOfDate", each AgeCompletedYears(Date.From([BirthDate]), asOfDate, leapDayPolicy), Int64.Type),
                WithBand = Table.AddColumn(WithAge, "AgeGroupAsOfDate", each AgeGroup([AgeAsOfDate]), type text)
            in
                WithBand,

    // 3B. Alternative: age at the date of each online fact row.
    // Gate: DateKey is the intended purchase date; current customer BirthDate is
    // suitable for historical analysis. No SCD history is inferred or repaired.
    // Pass the FactOnlineSales final step and DimCustomer query, NOT FactOnlineSales
    // itself from inside that query (which would create a cyclic reference).
    // Only CustomerKey/BirthDate are joined. No names/contact fields are copied.
    // Stops on duplicate/null dimension keys instead of multiplying sales rows.
    WithAgeAtPurchase = (onlineFacts as table, customers as table, leapDayPolicy as text) as table =>
        if not List.Contains({"February28", "March1"}, leapDayPolicy) then
            error "Select a leap-day policy before adding purchase-date ages."
        else
            let
                CustomerDates = Table.SelectColumns(customers, {"CustomerKey", "BirthDate"}),
                CustomerKeys = Table.Column(CustomerDates, "CustomerKey"),
                ValidatedCustomerDates =
                    if List.NonNullCount(CustomerKeys) <> List.Count(CustomerKeys) then
                        error "DimCustomer contains a null CustomerKey; resolve the key policy first."
                    else if Table.RowCount(Table.Distinct(CustomerDates, {"CustomerKey"})) <> Table.RowCount(CustomerDates) then
                        error "DimCustomer CustomerKey is not unique; purchase-age join stopped."
                    else CustomerDates,
                Joined = Table.NestedJoin(onlineFacts, {"CustomerKey"}, ValidatedCustomerDates, {"CustomerKey"}, "__AgeCustomer", JoinKind.LeftOuter),
                Expanded = Table.ExpandTableColumn(Joined, "__AgeCustomer", {"BirthDate"}, {"__AgeBirthDate"}),
                WithAge = Table.AddColumn(Expanded, "AgeAtPurchase", each AgeCompletedYears(Date.From([__AgeBirthDate]), Date.From([DateKey]), leapDayPolicy), Int64.Type),
                WithBand = Table.AddColumn(WithAge, "AgeGroupAtPurchase", each AgeGroup([AgeAtPurchase]), type text),
                Result = Table.RemoveColumns(WithBand, {"__AgeBirthDate"}),
                CheckedResult = if Table.RowCount(Result) = Table.RowCount(onlineFacts) then Result
                    else error "Purchase-age join changed the fact-row count; stopped."
            in
                CheckedResult,

    // 4. Multi-year monthly axis: adds a real month-start date, plus optional label.
    // Keep DimDate[DateKey] and existing relationships unchanged. MonthStart is
    // repeated for daily rows: it is an axis column, NOT a replacement unique key.
    WithYearMonth = (dates as table) as table =>
        let
            WithStart = Table.AddColumn(dates, "MonthStart", each if [DateKey] = null then null else Date.StartOfMonth(Date.From([DateKey])), type date),
            WithLabel = Table.AddColumn(WithStart, "YearMonth", each if [MonthStart] = null then null else Date.ToText([MonthStart], [Format="yyyy-MM", Culture="en-US"]), type text)
        in
            WithLabel,

    // 5. Exact existing geography replacements, retained for implementation.
    // Only empty string "" is replaced. Do not swap columns, replace substrings,
    // broaden to null/whitespace, or change capitalization without separate evidence.
    // Existing DimGeography can simply be left untouched. If using this helper,
    // pass its Changed Type step and replace, rather than duplicate, the three steps.
    PreserveGeographyReplacements = (typedGeography as table) as table =>
        let
            #"Replaced Value" = Table.ReplaceValue(typedGeography, "", "Unknown City", Replacer.ReplaceValue, {"CityName"}),
            #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value", "", "Unknown State", Replacer.ReplaceValue, {"StateProvinceName"}),
            #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1", "", "Unknown country", Replacer.ReplaceValue, {"RegionCountryName"})
        in
            #"Replaced Value2"
in
    [
        BuildFactOnlineSales = BuildFactOnlineSales,
        AgeCompletedYears = AgeCompletedYears,
        AgeGroup = AgeGroup,
        WithAgeAsOfDate = WithAgeAsOfDate,
        WithAgeAtPurchase = WithAgeAtPurchase,
        WithYearMonth = WithYearMonth,
        PreserveGeographyReplacements = PreserveGeographyReplacements
    ]
