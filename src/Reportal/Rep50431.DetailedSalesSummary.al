report 50431 "Detailed Sales Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DetailedSalesSummary.rdlc';

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
                /*IF AreaCode_Filter <> '' THEN
                  "Sales Invoice Header".SETFILTER("Shortcut Dimension 2 Code",AreaCode_Filter);*/

            end;
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnPreReport()
    begin
        DateFilter := "Sales Invoice Header".GETFILTER("Posting Date");
        ProductCode_Filter := "Sales Invoice Header".GETFILTER("Shortcut Dimension 1 Code");
        //AreaCode_Filter := "Sales Invoice Header".GETFILTER("Shortcut Dimension 2 Code");
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
}

