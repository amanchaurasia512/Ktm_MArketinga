page 50022 "Holiday Detail Calendar"
{
    PageType = List;
    SourceTable = "English-Nepali Date";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("English Date"; Rec."English Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Nepali Date"; Rec."Nepali Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
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

    actions
    {
    }
}

