table 50007 "Customer Credit Limit Detail"
{
    DrillDownPageID = "Customer Credit Limit";
    LookupPageID = "Customer Credit Limit";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(2; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
        }
        field(3; "Credit Limit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Credit Limit (LCY)';

            trigger OnValidate()
            begin
                IF "Credit Limit (LCY)" < 0 THEN
                    ERROR('%1 cannot be less than zero', FIELDCAPTION("Credit Limit (LCY)"));

                /*IF "Credit Limit (LCY)" <> 0 THEN
                  TESTFIELD("Expiry Date");*/

            end;
        }
        field(4; "Created By"; Code[20])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(5; "Last Modified By"; Code[20])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(6; "Created Date"; Date)
        {
            Editable = false;
        }
        field(7; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(8; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Reason; Text[250])
        {
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(14; "Expiry Date"; Date)
        {
        }
        field(15; "Skip Credit Limit Control"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Global Dimension 1 Code", "Expiry Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Text000: Label 'Responsibility Center Cannot be Blank.';
    begin
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Last Modified By" := USERID;
        "Last Modified Date" := TODAY;
        /*
        IF "Responsibility Center" = '' THEN
          ERROR(Text000);
        TESTFIELD("Global Dimension 1 Code");
        TESTFIELD("Global Dimension 2 Code");
        */ // allow to insert blank // june 15, 2016 ZM

    end;

    trigger OnModify()
    begin
        "Last Modified By" := USERID;
        "Last Modified Date" := TODAY;

        TESTFIELD("Global Dimension 1 Code");
        /*TESTFIELD("Global Dimension 2 Code");
        TESTFIELD("Responsibility Center");
        */ // allow to insert blank // june 15, 2016 ZM

    end;
}

