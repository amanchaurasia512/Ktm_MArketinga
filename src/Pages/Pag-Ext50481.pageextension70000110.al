pageextension 50481 "pageextension70000110" extends "Base Calendar Changes"
{
    layout
    {
        addlast(content)
        {
            field("Holiday Type"; Rec."Holiday Type")
            {
                ApplicationArea = all;
            }
            field("SMS Greeting Text"; Rec."SMS Greeting Text")
            {
                ApplicationArea = all;
            }
        }
    }
}

