report 50427 "Daily Product Wise Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DailyProductWiseSales.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
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
            column(DateFilter; DateFilter)
            {
            }
            column(ProductCode_Filter; ProductCode_Filter)
            {
            }
            column(AreaCode_Filter; AreaCode_Filter)
            {
            }
            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemLink = "Sell-to Customer No." = FIELD("No."),
                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                              "Posting Date" = FIELD("Date Filter"),
                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                PrintOnlyIfDetail = false;
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
                column(ReturnAmtInclVAT; ReturnAmtInclVat)
                {
                }
                column(ReturnAmt; ReturnAmt)
                {
                }
                column(TotalAmt; TotalAmt)
                {
                }
                column(TotalAmtInclVAT; TotalAmtInclVAT)
                {
                }
                column(TotalRetAmt; TotalRetAmt)
                {
                }
                column(TotalRetAmtInclVAT; TotalRetAmtInclVAT)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SalesCrMemoLine.RESET;
                    //ReturnReasonCode.RESET;
                    SalesCrMemoLine.SETRANGE("Returned Document No.", "Sales Invoice Header"."No.");
                    IF SalesCrMemoLine.FINDSET THEN
                        REPEAT
                            ReturnAmt += SalesCrMemoLine.Amount;
                            ReturnAmtInclVat += SalesCrMemoLine."Amount Including VAT";
                        UNTIL SalesCrMemoLine.NEXT = 0;
                    TotalRetAmt += ReturnAmt;
                    TotalRetAmtInclVAT += ReturnAmtInclVat;
                end;

                trigger OnPreDataItem()
                begin
                    /*IF DateFilter <> '' THEN
                      "Sales Invoice Header".SETFILTER("Posting Date",DateFilter);
                    IF ProductCode_Filter <> '' THEN
                      "Sales Invoice Header".SETFILTER("Shortcut Dimension 1 Code",ProductCode_Filter);
                    IF AreaCode_Filter <> '' THEN
                      "Sales Invoice Header".SETFILTER("Shortcut Dimension 2 Code",AreaCode_Filter);*/

                end;
            }

            trigger OnAfterGetRecord()
            begin
                ReturnAmt := 0;
                ReturnAmtInclVat := 0;
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
        CustNo := Customer.GETFILTER("No.");
        DateFilter := Customer.GETFILTER("Date Filter");
        ProductCode_Filter := Customer.GETFILTER("Global Dimension 1 Filter");
        AreaCode_Filter := Customer.GETFILTER("Global Dimension 2 Filter");
        TotalRetAmt := 0;
        TotalRetAmtInclVAT := 0;
    end;

    var
        DateFilter: Text;
        ProductCode_Filter: Text;
        AreaCode_Filter: Text;
        CompanyInfo: Record "Company Information";
        CustName: Text;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        ReturnAmt: Decimal;
        ReturnAmtInclVat: Decimal;
        ReturnReasonCode: Record "Return Reason";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ReturnReason: Text;
        SalesInvHdr: Record "Sales Invoice Header";
        TotalAmt: Decimal;
        TotalAmtInclVAT: Decimal;
        CustNo: Text;
        TotalRetAmt: Decimal;
        TotalRetAmtInclVAT: Decimal;
}

