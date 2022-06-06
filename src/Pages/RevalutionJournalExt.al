pageextension 50541 "Revalution Journal Ext" extends "Revaluation Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(ShortcutDimCode8)
        {

            field("Purchase Consignment No."; Rec."Purchase Consignment No.")
            {
                ToolTip = 'Specifies the value of the Purchase Consignment No. field.';
                ApplicationArea = All;
            }
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
            field("Party Type"; Rec."Party Type")
            {
                ToolTip = 'Specifies the value of the Party Type field.';
                ApplicationArea = All;
            }
            field("Party No."; Rec."Party No.")
            {
                ToolTip = 'Specifies the value of the Party No. field.';
                ApplicationArea = All;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ToolTip = 'Specifies the value of the Nepali Date field.';
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