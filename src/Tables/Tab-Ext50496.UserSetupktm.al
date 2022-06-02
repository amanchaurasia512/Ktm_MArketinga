tableextension 50496 "User Setup_ktm" extends "User Setup"
{
    fields
    {
        field(50000; "Allow TDS A/C Direct Posting"; Boolean)
        {
            Description = 'TDS1.00';
        }
        field(50001; "Blank IRD Voucher No."; Boolean)
        {
        }
        field(50501; "Default Responsibility Center"; Code[10])
        {
            Description = 'NP15.1001';
            TableRelation = "Responsibility Center";
        }
        field(50502; "Allow Different Customer Post"; Boolean)
        {
            Description = 'This field is used to give permission to the user who can post invoice that have different sell-to and bill-to customer';
        }
        field(50503; "Can Manage Template"; Boolean)
        {
            Description = 'Use to create, edit & delete batch';
        }
        field(50504; "Skip Diff Product Segment Code"; Boolean)
        {
        }
        field(50505; "Can Delete Purchase Order"; Boolean)
        {
        }
    }
}

