pageextension 50540 "Value Entries Ext" extends "Value Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {

            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ToolTip = 'Specifies the value of the PragyapanPatra field.';
                ApplicationArea = All;
            }
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
        }
        addafter("Job Ledger Entry No.")
        {

            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ToolTip = 'Specifies the value of the RBI Product Code field.';
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