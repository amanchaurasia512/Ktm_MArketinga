pageextension 50409 "pageextension70000001" extends "Accounting Periods"
{
    layout
    {
        addafter("Average Cost Period")
        {
            field("Nepali Fiscal Year"; Rec."Nepali Fiscal Year")
            {
                ApplicationArea = all;
            }
        }
    }
}

