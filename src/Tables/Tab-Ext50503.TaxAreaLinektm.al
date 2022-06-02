tableextension 50503 "Tax Area Line_ktm" extends "Tax Area Line"
{
    fields
    {

        //Unsupported feature: Property Modification (NotBlank) on ""Tax Jurisdiction Code"(Field 2)".


        //Unsupported feature: Property Modification (Editable) on ""Jurisdiction Description"(Field 3)".


        //Unsupported feature: Property Deletion (FieldClass) on ""Jurisdiction Description"(Field 3)".


        //Unsupported feature: Property Deletion (CalcFormula) on ""Jurisdiction Description"(Field 3)".

        field(5; "Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = FILTER(Report));
        }
        field(6; "Product Segment Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Report Name"; Text[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("Report ID")));

        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Tax Area,Tax Jurisdiction Code"(Key)".

        key(Key1; "Product Segment Code", "Report ID")
        {

        }
    }
}

