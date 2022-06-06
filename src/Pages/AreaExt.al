pageextension 50528 "Area Ext" extends Areas
{
    layout
    {
        // Add changes to pagelayout here
        addafter(text)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ToolTip = 'Specifies the value of the Customer No. field.';
                ApplicationArea = All;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ToolTip = 'Specifies the value of the Customer Name field.';
                ApplicationArea = All;
            }
            field("Start Date (BS)"; Rec."Start Date (BS)")
            {
                ToolTip = 'Specifies the value of the Start Date (BS) field.';
                ApplicationArea = All;
            }
            field("Start Date (AD)"; Rec."Start Date (AD)")
            {
                ToolTip = 'Specifies the value of the Start Date (AD) field.';
                ApplicationArea = All;
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                ApplicationArea = All;
            }
            field("Reminder Days"; Rec."Reminder Days")
            {
                ToolTip = 'Specifies the value of the Reminder Days field.';
                ApplicationArea = All;
            }
            field("BG Amount"; Rec."BG Amount")
            {
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