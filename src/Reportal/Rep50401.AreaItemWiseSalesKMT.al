report 50401 "Area-Item Wise Sales KMT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AreaItemWiseSalesKMT.rdlc';

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            RequestFilterFields = "Posting Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(RBIProductCode_SalesInvoiceLine; "Sales Invoice Line"."RBI Product Code")
            {
            }
            column(Amount_SalesInvoiceLine; "Sales Invoice Line".Amount)
            {
            }
            column(AmountIncludingVAT_SalesInvoiceLine; "Sales Invoice Line"."Amount Including VAT")
            {
            }
            column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
            {
            }
            column(SelltoCustomerNo_SalesInvoiceLine; "Sales Invoice Line"."Sell-to Customer No.")
            {
            }
            column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
            {
            }
            column(Description2_SalesInvoiceLine; "Sales Invoice Line"."Description 2")
            {
            }
            column(UnitofMeasure_SalesInvoiceLine; "Sales Invoice Line"."Unit of Measure Code")
            {
            }
            column(ShortcutDimension2Code_SalesInvoiceLine; "Sales Invoice Line"."Shortcut Dimension 2 Code")
            {
            }
            column(AreaCode_Filter; AreaCode_Filter)
            {
            }
            column(ProductCode_Filter; ProductCode_Filter)
            {
            }
            column(DateFilter; DateFilter)
            {
            }
            column(CustomerName; CustName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "Sales Invoice Line"."Shortcut Dimension 2 Code" = '' THEN
                    CurrReport.SKIP;
                Customer.SETRANGE("No.", "Sales Invoice Line"."Sell-to Customer No.");
                IF Customer.FINDFIRST THEN
                    CustName := Customer.Name;
            end;

            trigger OnPreDataItem()
            begin
                IF DateFilter <> '' THEN
                    "Sales Invoice Line".SETFILTER("Posting Date", DateFilter);
                IF ProductCode_Filter <> '' THEN
                    "Sales Invoice Line".SETFILTER("Shortcut Dimension 1 Code", ProductCode_Filter);
                IF AreaCode_Filter <> '' THEN
                    "Sales Invoice Line".SETFILTER("Shortcut Dimension 2 Code", AreaCode_Filter);
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
    end;

    trigger OnPreReport()
    begin
        DateFilter := "Sales Invoice Line".GETFILTER("Posting Date");
        AreaCode_Filter := "Sales Invoice Line".GETFILTER("Shortcut Dimension 2 Code");
        ProductCode_Filter := "Sales Invoice Line".GETFILTER("Shortcut Dimension 1 Code");
    end;

    var
        CustName: Text;
        CompanyInfo: Record "Company Information";
        DateFilter: Text;
        ProductCode_Filter: Text;
        AreaCode_Filter: Text;
        Customer: Record Customer;
}

