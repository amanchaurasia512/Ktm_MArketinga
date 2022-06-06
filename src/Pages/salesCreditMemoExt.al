pageextension 50531 "Sales Credit Memo  Ext" extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        modify("Salesperson Code")
        {
            Visible = false;
        }
        addafter("Sell-to City")
        {

            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ToolTip = 'Specifies the value of the Product Code field.';
                ApplicationArea = All;
            }
        }
        addafter("Assigned User ID")
        {
            //already defiend
            // field("Posting Description"; "Posting Description")
            // {
            //     ApplicationArea = All;
            // }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}