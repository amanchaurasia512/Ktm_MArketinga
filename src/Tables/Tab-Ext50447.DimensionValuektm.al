tableextension 50447 "Dimension Value_ktm" extends "Dimension Value"
{
    fields
    {
        field(50000; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50001; "G/L Account Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "G/L Account";
        }
        field(50002; "G/L Account1"; Code[10])
        {
            Caption = 'G/L Account';
            Description = 'Used  for employee drop-down';
            TableRelation = "G/L Account";
        }
    }
}

