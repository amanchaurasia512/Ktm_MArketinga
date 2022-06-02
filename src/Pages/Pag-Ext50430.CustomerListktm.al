pageextension 50430 "Customer List_ktm" extends "Customer List"
{
    layout
    {
        // modify("Control 62")
        // {
        //     Visible = false;
        // }
        // modify("Control 59")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            field("Balance (LCY)_ktm"; Rec."Balance (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                trigger OnDrillDown()
                begin
                    Rec.OpenCustomerLedgerEntries(FALSE);
                end;
            }
            field("Balance Due (LCY)_ktm"; Rec."Balance Due (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';

                trigger OnDrillDown()
                begin
                    Rec.OpenCustomerLedgerEntries(TRUE);
                end;
            }
        }
    }
    actions
    {
        addlast(creation)
        {
            action("Attach Documents")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.InsertAttachment; //SRT Dec 18th 2019
                end;
            }
            action("Remove Attachment")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.RemoveAttachment; //SRT Dec 18th 2019
                end;
            }
        }
    }
}

