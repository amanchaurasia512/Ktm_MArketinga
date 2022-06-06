pageextension 50514 "Posted purch Cr Memo Ext" extends "Posted Purchase Credit Memo"
{
    Editable = false;
    layout
    {
        modify("Order Address Code")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        // Add changes to page layout here
        addafter("Document Date")
        {  //all comment filed are already defined 
            // field("Currency Code"; "Currency Code")
            // {
            //     ApplicationArea = All;
            // }
            // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            // {
            //     ApplicationArea = All;
            // }
            // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
            // {
            //     ApplicationArea = All;
            // }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = All;
            }





        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(IncomingDocAttachFile)
        {
            action("Update LC")
            {
                RunObject = Page 50023;
                RunPageLink = "No." = FIELD("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = Update;
                PromotedCategory = Process;
            }
        }
    }

    var
        myInt: Integer;
}