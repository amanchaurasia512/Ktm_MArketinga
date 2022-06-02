tableextension 50451 "Detailed Cust. Ledg. Entry_ktm" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {

        //Unsupported feature: Property Deletion (CaptionML) on ""Tax Jurisdiction Code"(Field 41)".


        //Unsupported feature: Property Deletion (Editable) on ""Tax Jurisdiction Code"(Field 41)".

        field(50000; "Salesperson Code"; Code[10])
        {
            CalcFormula = Lookup("Cust. Ledger Entry"."Salesperson Code" WHERE("Entry No." = FIELD("Cust. Ledger Entry No.")));
            Caption = 'Salesperson Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70000; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(70001; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(70002; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(70003; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(70004; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(70005; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
    }
}

