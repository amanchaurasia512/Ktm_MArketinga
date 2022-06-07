report 50443 "Landed Cost Sheet (Import) 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LandedCostSheetImport1.rdlc';
    Caption = 'Landed Cost Sheet (Import)';

    dataset
    {
        dataitem("Purchase Consignment"; "TDS Posting Buffer")
        {
            DataItemTableView = SORTING("TDS Group");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "TDS Group";
            column(ReportFilter; STRSUBSTNO('%1: %2', TABLECAPTION, PurchaseConsignmentFilter))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(PurchaseConsignmentFilter; PurchaseConsignmentFilter)
            {
            }
            column(No_; "TDS Group")
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = PragyapanPatra = FIELD("TDS Group");
                DataItemTableView = SORTING(PragyapanPatra, "Item No.");
                column(Item_No_; "Item No.")
                {
                }
                column(Cost_Amount_Actual; "Cost Amount (Actual)")
                {
                }
                column(Invoiced_Quantity; "Invoiced Quantity")
                {
                }
                column(ColumnName; ColumnName)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF "Item Charge No." = '' THEN
                        ColumnName := Text1001
                    ELSE
                        ColumnName := "Item Charge No.";


                    IF PragyapanPatra = '' THEN
                        CurrReport.SKIP;
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
            }

            trigger OnAfterGetRecord()
            begin
                IF PrintOnlyOnePerPage THEN
                    PageGroupNo := PageGroupNo + 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Purchase Consignment';
                        Visible = false;
                    }
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
        CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
    end;

    trigger OnPreReport()
    begin
        PurchaseConsignmentFilter := "Purchase Consignment".GETFILTERS;
    end;

    var
        PurchaseConsignmentFilter: Text;
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        ColumnName: Code[20];
        Text1001: Label '1. Document Value';

    [Scope('Internal')]
    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintReversedEntries: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        //ExcludeBalanceOnly := NewExcludeBalanceOnly;
        //PrintReversedEntries := NewPrintReversedEntries;
    end;
}

