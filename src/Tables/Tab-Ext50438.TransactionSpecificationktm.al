tableextension 50438 "Transaction Specification_ktm" extends "Transaction Specification"
{
    fields
    {
        field(3; "Document Profile"; Option)
        {
            Description = 'SMS Template';
            OptionCaption = ' ,Holiday,Ageing';
            OptionMembers = " ",Holiday,Ageing;
        }
        field(4; Type; Option)
        {
            Description = 'SMS Template';
            OptionCaption = ' ,Holiday,Ageing';
            OptionMembers = " ",Holiday,Ageing;
        }
        field(5; "Line No."; Integer)
        {
            Description = 'SMS Template';
        }
        field(6; "Message Text"; Text[250])
        {
            Description = 'SMS Template';
        }
        field(7; "Message Sequence"; Integer)
        {
            Description = 'SMS Template';
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on "Code(Key)".

        key(Key1; "Document Profile", Type, "Line No.")
        {

        }
    }
}

