pageextension 50511 "Salespersons/Purchasers EXt" extends "Salespersons/Purchasers"
{

    layout
    {
        modify("Commission %")
        {
            Visible = false;
        }
        modify("Phone No.")
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