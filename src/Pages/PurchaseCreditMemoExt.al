pageextension 50535 "Purchase Cerdit Memo Ext" extends "Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = true;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }

        addafter("Shortcut Dimension 2 Code")
        {
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ToolTip = 'Specifies the value of the Letter of Credit/Telex Trans. field.';
                ApplicationArea = All;
            }

            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ToolTip = 'Specifies the value of the PragyapanPatra field.';
                ApplicationArea = All;
            }
        }
        addafter("VAT Bus. Posting Group")
        {

            field("Party No."; Rec."Party No.")
            {
                ToolTip = 'Specifies the value of the Party No. field.';
                ApplicationArea = All;
            }
            field("Party Name"; Rec."Party Name")
            {
                ToolTip = 'Specifies the value of the Party Name field.';
                ApplicationArea = All;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ToolTip = 'Specifies the value of the Nepali Date field.';
                ApplicationArea = All;
            }
        }
        addafter("Applies-to Doc. No.")
        {

            field("Purchase Consignment No."; Rec."Purchase Consignment No.")
            {
                ToolTip = 'Specifies the value of the Purchase Consignment No. field.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}