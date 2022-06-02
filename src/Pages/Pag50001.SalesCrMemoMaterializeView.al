page 50001 "Sales Cr.Memo Materialize View"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Invoice Materialize View";
    SourceTableView = WHERE("Table ID" = CONST(114),
                           "Document Type" = CONST("Sales Credit Memo"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bill No"; Rec."Bill No")
                {
                    ApplicationArea = all;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = all;
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = all;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = all;
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = all;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = all;
                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ApplicationArea = all;
                }
                field("TAX Amount"; Rec."TAX Amount")
                {
                    ApplicationArea = all;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = all;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                }
                field("Is Bill Printed"; Rec."Is Bill Printed")
                {
                    ApplicationArea = all;
                }
                field("Is Bill Active"; Rec."Is Bill Active")
                {
                    ApplicationArea = all;
                }
                field("Printed By"; Rec."Printed By")
                {
                    ApplicationArea = all;
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ApplicationArea = all;
                }
                field("Synced Date"; Rec."Synced Date")
                {
                    ApplicationArea = all;
                }
                field("Synced Time"; Rec."Synced Time")
                {
                    ApplicationArea = all;
                }
                field("Sync with IRD"; Rec."Sync with IRD")
                {
                    ApplicationArea = all;
                }
                field("Is RealTime"; Rec."Is RealTime")
                {
                    ApplicationArea = all;
                }
                field("CBMS Sync. Response"; Rec."CBMS Sync. Response")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("<Action1000000023>")
            {
                Caption = '&Print';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    InvoiceMat.COPYFILTERS(Rec);
                    // REPORT.RUNMODAL(REPORT::"Materialized View", TRUE, FALSE, InvoiceMat);
                end;
            }
            action("Sync Selected Data to CBMS")
            {
                Caption = 'Sync Selected Data to CBMS';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    InvoiceMaterializedView.COPY(Rec);
                    CurrPage.SETSELECTIONFILTER(InvoiceMaterializedView);
                    CLEAR(PushInvoices);
                    PushInvoices.PushBatchBill(InvoiceMaterializedView);
                end;
            }
        }
        area(navigation)
        {
            action("<Action59>")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeader.GET(Rec."Bill No");
                    SalesCrMemoHeader.Navigate;
                end;
            }
            action("<Action1000000028>")
            {
                Caption = 'Print &History';
                Image = History;
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = all;
                PromotedIsBig = true;
                RunObject = Page "Sales Invoice Print History";
                RunPageLink = "Table ID" = FIELD("Table ID"),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Bill No"),
                              "Fiscal Year" = FIELD("Fiscal Year");
            }
        }
    }

    var
        InvoiceMat: Record "Invoice Materialize View";
        InvoiceMaterializedView: Record "Invoice Materialize View";
        PushInvoices: Codeunit "IRD CBMS Mgt.";
}

