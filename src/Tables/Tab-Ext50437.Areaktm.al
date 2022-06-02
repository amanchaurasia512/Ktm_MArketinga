tableextension 50437 "Area_ktm" extends "Area"
{
    DrillDownPageID = 405;
    fields
    {
        modify("Code")
        {

            //Unsupported feature: Property Modification (Name) on "Code(Field 1)".

            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        modify(Text)
        {

            //Unsupported feature: Property Modification (Name) on "Text(Field 2)".

            Caption = 'Description';
        }


        //Unsupported feature: Code Insertion on ""Customer No."(Field 1)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //var
        //Cust: Record "18";
        //begin
        /*
        */
        //end;
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50000; "Start Date (AD)"; Date)
        {
        }
        field(50001; "End Date (AD)"; Date)
        {
        }
        field(50002; "Start Date (BS)"; Code[15])
        {
            CalcFormula = Lookup("English-Nepali Date"."Nepali Date" WHERE("English Date" = FIELD("Start Date (AD)")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "End Date (BS)"; Code[15])
        {
            CalcFormula = Lookup("English-Nepali Date"."Nepali Date" WHERE("English Date" = FIELD("End Date (AD)")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "BG Amount"; Decimal)
        {
            Caption = 'Bank Guarantee Amount';
            Description = 'Bank Guarantee Amount';
        }
        field(50005; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Reminder Days"; Integer)
        {
            Editable = false;
        }
        field(50007; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on "Code(Key)".

        key(Key1; "Customer No.", "Start Date (AD)", "End Date (AD)", "Shortcut Dimension 1 Code")
        {
            //Clustered = true;
        }
    }

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    var
        KMTManagement: Codeunit "IRD Mgt.";   //50000
        SMTPMailSetup: Record "SMTP Mail Setup";
}

