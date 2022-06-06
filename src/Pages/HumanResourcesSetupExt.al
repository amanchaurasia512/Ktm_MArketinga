pageextension 50536 "HRM EXT" extends "Human Resources Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Base Unit of Measure")
        {
            group(IRD)
            {
                CaptionML = ENU = 'IRD';


                field("Employee Dimension"; Rec."Employee Dimension")
                {
                    ToolTip = 'Specifies the value of the Employee Dimension field.';
                    ApplicationArea = All;
                }
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