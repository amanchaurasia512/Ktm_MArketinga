tableextension 50445 "Tax Detail_ktm" extends "Tax Detail"
{
    fields
    {

        //Unsupported feature: Property Deletion (CaptionML) on ""Tax Jurisdiction Code"(Field 1)".


        //Unsupported feature: Property Deletion (NotBlank) on ""Tax Jurisdiction Code"(Field 1)".

        field(50000; "Concerned Emails"; Text[50])
        {
        }
        field(50001; "Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = FILTER(Report));
        }
        field(50002; "Product Segment Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50003; "Line No."; Integer)
        {
        }
    }
    keys
    {
        key(Key1; "Product Segment Code", "Report ID", "Line No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TaxJurisdiction.GET("Tax Jurisdiction Code");
    "Calculate Tax on Tax" := TaxJurisdiction."Calculate Tax on Tax";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //TaxJurisdiction.GET("Tax Jurisdiction Code");
    //"Calculate Tax on Tax" := TaxJurisdiction."Calculate Tax on Tax";
    */
    //end;     //orginal and modified vcode are same

}

