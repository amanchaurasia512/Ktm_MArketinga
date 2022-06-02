pageextension 50469 "pageextension70000097" extends "Sales Return Order Subform"
{
    layout
    {
        addlast(content)
        {
            // field("Description 2"; "Description 2")
            // {
            // }
            field("Returned Document No."; Rec."Returned Document No.")
            {
                ApplicationArea = all;
            }
        }

    }
}

