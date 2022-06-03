pageextension 50517 "G/L Account List Ext" extends "G/L Account List"
{
    layout
    {
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}