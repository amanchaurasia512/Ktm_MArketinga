pageextension 50542 "Serial No. Inf List Ext" extends "Serial No. Information List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item No.")
        {

            field("Make Code"; Rec."Make Code")
            {
                ToolTip = 'Specifies the value of the Make Code field.';
                ApplicationArea = All;
            }
            field("Model Code"; Rec."Model Code")
            {
                ToolTip = 'Specifies the value of the Model Code field.';
                ApplicationArea = All;
            }
            field("Model Commercial Name"; Rec."Model Commercial Name")
            {
                ToolTip = 'Specifies the value of the Model Commercial Name field.';
                ApplicationArea = All;
            }
            field("Body Color"; Rec."Body Color")
            {
                ToolTip = 'Specifies the value of the Body Color field.';
                ApplicationArea = All;
            }
        }
        addafter("Serial No.")
        {

            field(VIN; Rec.VIN)
            {
                ToolTip = 'Specifies the value of the VIN field.';
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