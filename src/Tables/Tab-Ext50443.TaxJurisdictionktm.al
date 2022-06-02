tableextension 50443 "Tax Jurisdiction_ktm" extends "Tax Jurisdiction"
{
    fields
    {
        field(16; "Mobile Number"; Text[20])
        {
            Description = 'SMS Details';
        }
        field(17; "Creation Date"; Date)
        {
            Description = 'SMS Details';
        }
        field(18; "Message Type"; Option)
        {
            Description = 'SMS Details';
            OptionCaption = ' ,Holiday,Ageing';
            OptionMembers = " ",Holiday,Ageing;
        }
        field(19; "Message Text"; Text[250])
        {
            Description = 'SMS Details';
        }
        field(20; Status; Option)
        {
            Description = 'SMS Details';
            OptionCaption = 'New,Processed,Failed';
            OptionMembers = New,Processed,Failed;
        }
        field(21; "Last Modified Date"; DateTime)
        {
            Description = 'SMS Details';
        }
        field(22; Comment; Text[250])
        {
            Description = 'SMS Details';
        }
        field(23; "Document No."; Code[20])
        {
            Description = 'SMS Details';
        }
        field(24; Amount; Decimal)
        {
            Description = 'SMS Details';
        }
        field(25; Company; Text[30])
        {
            Description = 'SMS Details';
        }
        field(26; MessageID; Text[250])
        {
            Description = 'SMS Details';
        }
        field(27; "Message Length"; Integer)
        {
            Description = 'SMS Details';
        }
        field(28; "Ageing Date"; Date)
        {
            Description = 'SMS Details';
        }
        field(29; "Customer No."; Code[20])
        {
            Description = 'SMS Details';
        }
        field(30; "Entry No."; Integer)
        {
            Description = 'SMS Details';
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on "Code(Key)".

        // key(Key1; "Entry No.", "Message Type", "Code")
        // {
        //     Clustered = true;
        // }
    }
}

