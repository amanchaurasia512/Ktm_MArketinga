pageextension 50538 "Transfer Orders Ext" extends "Transfer Orders"
{
    layout
    {
        // Add changes to page layout here
        modify("Shortcut Dimension 2 Code")
        {
            Editable = false;
        }

        addafter("In-Transit Code")
        {

            field("Source Document No."; Rec."Source Document No.")
            {
                ToolTip = 'Specifies the value of the Source Document No. field.';
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