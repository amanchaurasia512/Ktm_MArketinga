tableextension 50455 "G/L Register_ktm" extends "G/L Register"
{
    fields
    {

        //Unsupported feature: Deletion (FieldCollection) on ""Creation Time"(Field 11)".

        // field(50501; "Creation Time"; Time)
        // {
        //     Description = 'NP15.1001';
        // }
        field(50502; "From TDS Entry No."; Integer)
        {
            Description = 'TDS1.00';
        }
        field(50503; "To TDS Entry No."; Integer)
        {
            Description = 'TDS1.00';
        }
    }
}

