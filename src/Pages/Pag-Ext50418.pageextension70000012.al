pageextension 50418 "pageextension70000012" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addlast(content)
        {
            field("Returned Document No."; Rec."Returned Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}

