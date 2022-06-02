tableextension 50459 "tableextension70000050" extends "Sales Header Archive"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount Including VAT"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Archived Versions"(Field 145)".

        modify("Sales Quote No.")
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Quote), "No." = FIELD("Sales Quote No."));
        }
        modify("Opportunity No.")
        {
            TableRelation = Opportunity."No." WHERE("Contact No." = FIELD("Sell-to Contact No."), Closed = CONST(false));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Shipped"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Late Order Shipping"(Field 5795)".

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
        field(70006; "Phone No."; Text[100])
        {

        }
    }
}

