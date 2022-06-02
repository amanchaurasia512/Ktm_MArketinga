tableextension 50510 "Base Calendar Change_ktm" extends "Base Calendar Change"
{
    fields
    {
        //         field(50000; MyField; Blob)
        //         {
        //             DataClassification = ToBeClassified;
        //      }
        field(50000; "Holiday Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Weekend,Public,Festival;
        }
        field(50001; "SMS Greeting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }


    //     var
    //         myInt: Integer;
}