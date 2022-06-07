report 50446 "Last Sales Price List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LastSalesPriceList.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Global Dimension 1 Filter", "Date Filter";
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(ItemFilters; ItemFilters)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyVATNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(No2_Item; Item."No. 2")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(Description2_Item; Item."Description 2")
            {
            }
            column(GlobalDimension1Code_Item; Item."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_Item; Item."Global Dimension 2 Code")
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            dataitem("Sales Price"; "Sales Price")
            {
                DataItemLink = "Item No." = FIELD("No."),
                               "Product Segment Code" = FIELD("Global Dimension 1 Filter");
                DataItemTableView = SORTING("Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
                                    WHERE("Sales Type" = CONST("Customer Price Group"));
                RequestFilterFields = "Sales Code";
                column(SPFilter; SPFilter)
                {
                }
                column(SalesCode_SalesPrice; "Sales Price"."Sales Code")
                {
                }
                column(StartingDate_SalesPrice; FORMAT("Sales Price"."Starting Date"))
                {
                }
                column(NepaliDate; NepaliDate)
                {
                }
                column(UnitPrice_SalesPrice; "Sales Price"."Unit Price")
                {
                }
                column(SalesType_SalesPrice; "Sales Price"."Sales Type")
                {
                }
                column(MinimumQuantity_SalesPrice; "Sales Price"."Minimum Quantity")
                {
                }
                column(EndingDate_SalesPrice; FORMAT("Sales Price"."Ending Date"))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //pram
                    IF LastPriceB THEN BEGIN
                        MyCount += 1;
                        IF MyCount <> TotalCount THEN
                            CurrReport.SKIP;
                    END;

                    IF ("Sales Price"."Ending Date" <> 0D) OR ("Sales Price"."Unit Price" = 0) THEN
                        CurrReport.SKIP;
                    NepaliDate := '';
                    IF "Ending Date" <> 0D THEN
                        CurrReport.SKIP;

                    NepaliCalendar.RESET;
                    NepaliCalendar.SETRANGE("English Date", "Sales Price"."Starting Date");
                    IF NepaliCalendar.FINDFIRST THEN
                        NepaliDate := NepaliCalendar."Nepali Date";
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("Sales Price"."Starting Date", '..%1', Item.GETRANGEMAX("Date Filter"));

                    LastPriceB := TRUE;
                    //cannot put lastpriceB in request page.. nav crashes while opening
                    IF LastPriceB THEN BEGIN //pram
                        SETCURRENTKEY("Starting Date");
                        TotalCount := COUNT;
                        MyCount := 0;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        ItemFilters := Item.GETFILTERS;
        SPFilter := "Sales Price".GETFILTERS;
        StartDateNep := '';
        EndDateNep := '';
        StartEngDate := 0D;
        EndEngDate := 0D;
        StartEngDate := Item.GETRANGEMIN("Date Filter");
        EndEngDate := Item.GETRANGEMAX("Date Filter");
        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", StartEngDate);
        IF NepaliCal.FINDFIRST THEN
            StartDateNep := NepaliCal."Nepali Date";

        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", EndEngDate);
        IF NepaliCal.FINDFIRST THEN
            EndDateNep := NepaliCal."Nepali Date";
    end;

    var
        CompanyInfo: Record "Company Information";
        NepaliDate: Code[20];
        NepaliCalendar: Record "English-Nepali Date";
        ItemFilters: Text;
        SPFilter: Text;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        LastPriceB: Boolean;
        ReportTitle: Label 'Price List';
        CurrReport_PAGENOCaption: Label 'Page';
        MyCount: Integer;
        TotalCount: Integer;
}

