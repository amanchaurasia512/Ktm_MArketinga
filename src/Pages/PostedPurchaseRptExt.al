pageextension 50513 "Posted Purchase Rpt Ext" extends "Posted Purchase Receipt"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        addafter("Responsibility Center")
        {
            field("VAT Base 1"; "VAT Base 1")
            {
                Caption = 'Vat Base Amount';
                Visible = true;
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Navigate")
        {
            action("AssignPP&LCFromInvoice")
            {
                CaptionML = ENU = 'AssignPP&LCFromInvoice';
                trigger OnAction()
                var
                    ItemLedgEntry: Record "Item Ledger Entry";
                    ValueEntry: Record "Value Entry";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                begin
                    ItemLedgEntry.RESET;
                    ValueEntry.RESET;
                    PurchRcptLine.RESET
                end;
            }
        }
    }

    var
        myInt: Integer;
}