pageextension 50411 "pageextension70000003" extends "Account Schedule"
{
    layout
    {
        addlast(content)
        {
            field("Schedule Description"; Rec."Schedule Description")
            {
                ApplicationArea = all;
            }
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = all;
            }
        }

    }
}

