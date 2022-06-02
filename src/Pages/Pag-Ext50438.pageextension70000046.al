pageextension 50438 "pageextension70000046" extends "Item Ledger Entries"
{
    layout
    {
        addlast(content)
        {
            field("Item Name"; Rec."Item Name")
            {
                ApplicationArea = all;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
            field("Transfer Receipt No."; Rec."Transfer Receipt No.")
            {
                ApplicationArea = all;
            }
            field("Transfer Receipt Line No."; Rec."Transfer Receipt Line No.")
            {
            }
            // field("Shortcut Dimension 4 Code"; "Shortcut Dimension 4 Code")
            // {
            // }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = all;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = all;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = all;
            }
            field("Party Name"; Rec."Party Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Loan; Rec.Loan)
            {
                ApplicationArea = all;
            }
            field(Margin; Rec.Margin)
            {
                ApplicationArea = all;
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ApplicationArea = all;
            }
        }


    }
}

