tableextension 50495 "Acc. Schedule Line_ktm" extends "Acc. Schedule Line"
{
    fields
    {
        field(50000; "Schedule Description"; Text[30])
        {
            Caption = 'Schedule';
        }
        field(50001; "Hide Line"; Boolean)
        {
            Description = 'Just Hides the line, it does not effect totaling';
        }
    }
}

