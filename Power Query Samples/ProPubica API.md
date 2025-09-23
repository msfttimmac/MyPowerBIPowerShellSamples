## PURPOSE ##
Recently took on a project to pull data from ProPublica.Org.  The API only pulls back 25 rows per page.  It had 400 pages, so needed to put together a Power Query to pull this information together in a Power BI Report.  Below, you will find the Power Query to make this happen. This will also put together the Guidestar Link for information on the Non-Profit.

## POWER BI CONNECTOR ##
Web Connector

## STEPS TO ADD POWER QUERY ##
1.	In Power BI Desktop, click Transform Data to go into Power Query
2.	In the Ribbon, select New Source and then Blank Query
3.	Copy and Paste the below Power Query into the Blank Query window
4.	Click the okay button.

## PROPUBLICA API POWER QUERY ##

let
    // Define the query parameters
    BaseUrl = "https://projects.propublica.org/nonprofits/api/v2/search.json?page=",

    // Function to fetch a single page
    GetPage = (PageNumber as number) as record =>
        let
            Url = BaseUrl & Text.From(PageNumber),
            Source = Web.Contents(Url),
            Json = Json.Document(Source),
            Organizations = Json[organizations]
        in
            Json,

    // Fetch the first page to get total pages
    FirstPage = GetPage(0),
    TotalPages = FirstPage[num_pages],

    // Generate list of page numbers (0 to TotalPages-1)
    PageList = List.Numbers(0, TotalPages, 1),

    // Fetch all pages
    AllPages = List.Generate(
        () => [Page = 0, Data = GetPage(0)],
        each [Page] < TotalPages,
        each [Page = [Page] + 1, Data = GetPage([Page] + 1)],
        each [Data][organizations]
    ),

    // Combine all organizations into a single list
    CombinedOrganizations = List.Combine(AllPages),

    // Convert to table
    Table = Table.FromList(CombinedOrganizations, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    // Expand the records into columns
    ExpandedTable = Table.ExpandRecordColumn(
        Table,
        "Column1",
        Record.FieldNames(CombinedOrganizations{0}),
        Record.FieldNames(CombinedOrganizations{0})
    ),

    // Optional: Clean up or transform data (e.g., adjust column types)
    FinalTable = Table.TransformColumnTypes(
        ExpandedTable,
        {
            {"ein", type text},
            {"name", type text},
            {"city", type text},
            {"state", type text},
            {"ntee_code", type text},
            {"score", type number}
        },
        "en-US"
    ),
    #"Added Custom" = Table.AddColumn(FinalTable, "guidestar_url", each "https://www.guidestar.org/profile/" & [strein]),
    #"Added Custom1" = Table.AddColumn(#"Added Custom", "Organization_Information", each Json.Document(Web.Contents("https://projects.propublica.org/nonprofits/api/v2/organizations/" & Text.From([ein]) & ".json"))),
    #"Expanded Organization_Information1" = Table.ExpandRecordColumn(#"Added Custom1", "Organization_Information", {"organization", "filings_with_data", "filings_without_data", "data_source", "api_version"}, {"Organization_Information.organization", "Organization_Information.filings_with_data", "Organization_Information.filings_without_data", "Organization_Information.data_source", "Organization_Information.api_version"}),
    #"Expanded Organization_Information.organization" = Table.ExpandRecordColumn(#"Expanded Organization_Information1", "Organization_Information.organization", {"id", "ein", "name", "careofname", "address", "city", "state", "zipcode", "exemption_number", "subsection_code", "affiliation_code", "classification_codes", "ruling_date", "deductibility_code", "foundation_code", "activity_codes", "organization_code", "exempt_organization_status_code", "tax_period", "asset_code", "income_code", "filing_requirement_code", "pf_filing_requirement_code", "accounting_period", "asset_amount", "income_amount", "revenue_amount", "ntee_code", "sort_name", "created_at", "updated_at", "data_source", "have_extracts", "have_pdfs", "latest_object_id"}, {"Organization_Information.organization.id", "Organization_Information.organization.ein", "Organization_Information.organization.name", "Organization_Information.organization.careofname", "Organization_Information.organization.address", "Organization_Information.organization.city", "Organization_Information.organization.state", "Organization_Information.organization.zipcode", "Organization_Information.organization.exemption_number", "Organization_Information.organization.subsection_code", "Organization_Information.organization.affiliation_code", "Organization_Information.organization.classification_codes", "Organization_Information.organization.ruling_date", "Organization_Information.organization.deductibility_code", "Organization_Information.organization.foundation_code", "Organization_Information.organization.activity_codes", "Organization_Information.organization.organization_code", "Organization_Information.organization.exempt_organization_status_code", "Organization_Information.organization.tax_period", "Organization_Information.organization.asset_code", "Organization_Information.organization.income_code", "Organization_Information.organization.filing_requirement_code", "Organization_Information.organization.pf_filing_requirement_code", "Organization_Information.organization.accounting_period", "Organization_Information.organization.asset_amount", "Organization_Information.organization.income_amount", "Organization_Information.organization.revenue_amount", "Organization_Information.organization.ntee_code", "Organization_Information.organization.sort_name", "Organization_Information.organization.created_at", "Organization_Information.organization.updated_at", "Organization_Information.organization.data_source", "Organization_Information.organization.have_extracts", "Organization_Information.organization.have_pdfs", "Organization_Information.organization.latest_object_id"}),
    #"Expanded Organization_Information.filings_with_data" = Table.ExpandListColumn(#"Expanded Organization_Information.organization", "Organization_Information.filings_with_data"),
    #"Expanded Organization_Information.filings_with_data1" = Table.ExpandRecordColumn(#"Expanded Organization_Information.filings_with_data", "Organization_Information.filings_with_data", {"tax_prd", "tax_prd_yr", "formtype", "pdf_url", "updated", "totrevenue", "totfuncexpns", "totassetsend", "totliabend", "pct_compnsatncurrofcr", "tax_pd", "subseccd", "unrelbusinccd", "initiationfees", "grsrcptspublicuse", "grsincmembers", "grsincother", "totcntrbgfts", "totprgmrevnue", "invstmntinc", "txexmptbndsproceeds", "royaltsinc", "grsrntsreal", "grsrntsprsnl", "rntlexpnsreal", "rntlexpnsprsnl", "rntlincreal", "rntlincprsnl", "netrntlinc", "grsalesecur", "grsalesothr", "cstbasisecur", "cstbasisothr", "gnlsecur", "gnlsothr", "netgnls", "grsincfndrsng", "lessdirfndrsng", "netincfndrsng", "grsincgaming", "lessdirgaming", "netincgaming", "grsalesinvent", "lesscstofgoods", "netincsales", "miscrevtot11e", "compnsatncurrofcr", "othrsalwages", "payrolltx", "profndraising", "txexmptbndsend", "secrdmrtgsend", "unsecurednotesend", "retainedearnend", "totnetassetend", "nonpfrea", "gftgrntsrcvd170", "txrevnuelevied170", "srvcsval170", "grsinc170", "grsrcptsrelated170", "totgftgrntrcvd509", "grsrcptsadmissn509", "txrevnuelevied509", "srvcsval509", "subtotsuppinc509", "totsupp509", "ein"}, {"Organization_Information.filings_with_data.tax_prd", "Organization_Information.filings_with_data.tax_prd_yr", "Organization_Information.filings_with_data.formtype", "Organization_Information.filings_with_data.pdf_url", "Organization_Information.filings_with_data.updated", "Organization_Information.filings_with_data.totrevenue", "Organization_Information.filings_with_data.totfuncexpns", "Organization_Information.filings_with_data.totassetsend", "Organization_Information.filings_with_data.totliabend", "Organization_Information.filings_with_data.pct_compnsatncurrofcr", "Organization_Information.filings_with_data.tax_pd", "Organization_Information.filings_with_data.subseccd", "Organization_Information.filings_with_data.unrelbusinccd", "Organization_Information.filings_with_data.initiationfees", "Organization_Information.filings_with_data.grsrcptspublicuse", "Organization_Information.filings_with_data.grsincmembers", "Organization_Information.filings_with_data.grsincother", "Organization_Information.filings_with_data.totcntrbgfts", "Organization_Information.filings_with_data.totprgmrevnue", "Organization_Information.filings_with_data.invstmntinc", "Organization_Information.filings_with_data.txexmptbndsproceeds", "Organization_Information.filings_with_data.royaltsinc", "Organization_Information.filings_with_data.grsrntsreal", "Organization_Information.filings_with_data.grsrntsprsnl", "Organization_Information.filings_with_data.rntlexpnsreal", "Organization_Information.filings_with_data.rntlexpnsprsnl", "Organization_Information.filings_with_data.rntlincreal", "Organization_Information.filings_with_data.rntlincprsnl", "Organization_Information.filings_with_data.netrntlinc", "Organization_Information.filings_with_data.grsalesecur", "Organization_Information.filings_with_data.grsalesothr", "Organization_Information.filings_with_data.cstbasisecur", "Organization_Information.filings_with_data.cstbasisothr", "Organization_Information.filings_with_data.gnlsecur", "Organization_Information.filings_with_data.gnlsothr", "Organization_Information.filings_with_data.netgnls", "Organization_Information.filings_with_data.grsincfndrsng", "Organization_Information.filings_with_data.lessdirfndrsng", "Organization_Information.filings_with_data.netincfndrsng", "Organization_Information.filings_with_data.grsincgaming", "Organization_Information.filings_with_data.lessdirgaming", "Organization_Information.filings_with_data.netincgaming", "Organization_Information.filings_with_data.grsalesinvent", "Organization_Information.filings_with_data.lesscstofgoods", "Organization_Information.filings_with_data.netincsales", "Organization_Information.filings_with_data.miscrevtot11e", "Organization_Information.filings_with_data.compnsatncurrofcr", "Organization_Information.filings_with_data.othrsalwages", "Organization_Information.filings_with_data.payrolltx", "Organization_Information.filings_with_data.profndraising", "Organization_Information.filings_with_data.txexmptbndsend", "Organization_Information.filings_with_data.secrdmrtgsend", "Organization_Information.filings_with_data.unsecurednotesend", "Organization_Information.filings_with_data.retainedearnend", "Organization_Information.filings_with_data.totnetassetend", "Organization_Information.filings_with_data.nonpfrea", "Organization_Information.filings_with_data.gftgrntsrcvd170", "Organization_Information.filings_with_data.txrevnuelevied170", "Organization_Information.filings_with_data.srvcsval170", "Organization_Information.filings_with_data.grsinc170", "Organization_Information.filings_with_data.grsrcptsrelated170", "Organization_Information.filings_with_data.totgftgrntrcvd509", "Organization_Information.filings_with_data.grsrcptsadmissn509", "Organization_Information.filings_with_data.txrevnuelevied509", "Organization_Information.filings_with_data.srvcsval509", "Organization_Information.filings_with_data.subtotsuppinc509", "Organization_Information.filings_with_data.totsupp509", "Organization_Information.filings_with_data.ein"}),
    #"Expanded Organization_Information.filings_without_data" = Table.ExpandListColumn(#"Expanded Organization_Information.filings_with_data1", "Organization_Information.filings_without_data"),
    #"Expanded Organization_Information.filings_without_data1" = Table.ExpandRecordColumn(#"Expanded Organization_Information.filings_without_data", "Organization_Information.filings_without_data", {"tax_prd", "tax_prd_yr", "formtype", "formtype_str", "pdf_url"}, {"Organization_Information.filings_without_data.tax_prd", "Organization_Information.filings_without_data.tax_prd_yr", "Organization_Information.filings_without_data.formtype", "Organization_Information.filings_without_data.formtype_str", "Organization_Information.filings_without_data.pdf_url"})
in
    #"Expanded Organization_Information.filings_without_data1"

