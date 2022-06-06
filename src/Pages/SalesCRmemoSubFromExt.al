pageextension 50544 "Sales Cr. Memo subfrom Ext" extends "Sales Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Return Reason Code")
        {

            field("Returned Document No."; Rec."Returned Document No.")
            {
                ToolTip = 'Specifies the value of the Returned Document No. field.';
                ApplicationArea = All;
            }
            field("Return Receipt Line No."; Rec."Return Receipt Line No.")
            {
                ToolTip = 'Specifies the value of the Return Receipt Line No. field.';
                ApplicationArea = All;
            }
        }
        addafter(ShortcutDimCode8)
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