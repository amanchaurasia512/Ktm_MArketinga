report 50428 "Day-Wise Sales Summary KMT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DayWiseSalesSummaryKMT.rdlc';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date", "Shortcut Dimension 1 Code", "Sell-to Customer No.";
            column(Company_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddr; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyVatRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
            }
            column(PostingDate_SalesInvoiceHeader; FORMAT("Sales Invoice Header"."Posting Date"))
            {
            }
            column(Amount_SalesInvoiceHeader; "Sales Invoice Header".Amount)
            {
            }
            column(AmountIncludingVAT_SalesInvoiceHeader; "Sales Invoice Header"."Amount Including VAT")
            {
            }
            column(ShortcutDimension1Code_SalesInvoiceHeader; "Sales Invoice Header"."Shortcut Dimension 1 Code")
            {
            }
            column(DateFilter; DateFilter)
            {
            }
            column(ProductCode_Filter; ProductCode_Filter)
            {
            }
            column(AreaCode_Filter; AreaCode_Filter)
            {
            }
            column(CustName; CustName)
            {
            }
            column(ReturnAmt; ReturnAmt)
            {
            }
            column(ReturnAmtInclVAT; ReturnAmtInclVat)
            {
            }
            column(ReturnReasonCode; ReturnReason)
            {
            }
            column(ShowInvoice; ShowInvoice)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ReturnReason := '';
                ReturnAmtInclVat := 0;
                ReturnAmt := 0;
                Customer.RESET;
                Customer.SETRANGE("No.", "Sales Invoice Header"."Sell-to Customer No.");
                IF Customer.FINDFIRST THEN
                    CustName := Customer.Name;

                SalesCrMemoLine.RESET;
                ReturnReasonCode.RESET;
                SalesCrMemoLine.SETRANGE("Sell-to Customer No.", "Sales Invoice Header"."Sell-to Customer No.");
                SalesCrMemoLine.SETRANGE("Returned Document No.", "Sales Invoice Header"."No.");
                IF SalesCrMemoLine.FINDSET THEN
                    REPEAT
                        ReturnAmtInclVat += SalesCrMemoLine."Amount Including VAT";
                        ReturnAmt += SalesCrMemoLine.Amount;
                    UNTIL SalesCrMemoLine.NEXT = 0;

                SalesCrMemoLine.SETRANGE("Returned Document No.", "Sales Invoice Header"."No.");
                IF SalesCrMemoLine.FINDFIRST THEN BEGIN
                    ReturnReasonCode.SETRANGE(Code, SalesCrMemoLine."Return Reason Code");
                    IF ReturnReasonCode.FINDFIRST THEN
                        ReturnReason := ReturnReasonCode.Description;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF DateFilter <> '' THEN
                    "Sales Invoice Header".SETFILTER("Posting Date", DateFilter);
                IF ProductCode_Filter <> '' THEN
                    "Sales Invoice Header".SETFILTER("Shortcut Dimension 1 Code", ProductCode_Filter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Show Invoice"; ShowInvoice)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnPreReport()
    begin
        DateFilter := "Sales Invoice Header".GETFILTER("Posting Date");
        ProductCode_Filter := "Sales Invoice Header".GETFILTER("Shortcut Dimension 1 Code");
        IF DateFilter <> '' THEN BEGIN
            StartDateNep := '';
            EndDateNep := '';
            StartEngDate := 0D;
            EndEngDate := 0D;
            StartEngDate := "Sales Invoice Header".GETRANGEMIN("Posting Date");
            EndEngDate := "Sales Invoice Header".GETRANGEMAX("Posting Date");
            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", StartEngDate);
            IF NepaliCal.FINDFIRST THEN
                StartDateNep := NepaliCal."Nepali Date";

            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", EndEngDate);
            IF NepaliCal.FINDFIRST THEN
                EndDateNep := NepaliCal."Nepali Date";
        END;
    end;

    var
        DateFilter: Text;
        ProductCode_Filter: Text;
        AreaCode_Filter: Text;
        CompanyInfo: Record "Company Information";
        CustName: Text;
        Customer: Record Customer;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        ReturnAmtInclVat: Decimal;
        ReturnReasonCode: Record "Return Reason";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ReturnReason: Text;
        ReturnAmt: Decimal;
        ShowInvoice: Boolean;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
}

