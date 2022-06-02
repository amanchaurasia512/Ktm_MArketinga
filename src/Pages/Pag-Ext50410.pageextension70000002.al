pageextension 50410 "pageextension70000002" extends "Account Schedule Names"
{
    layout
    {
        addafter("Analysis View Name")
        {
            field("SKip Prior Entry"; Rec."SKip Prior Entry")
            {
                ApplicationArea = all;
            }
        }
    }
}

