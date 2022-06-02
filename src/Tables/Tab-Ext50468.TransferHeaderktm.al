tableextension 50468 "Transfer Header_ktm" extends "Transfer Header"
{
    fields
    {
        modify("Transfer-from Post Code")
        {
            TableRelation = IF ("Trsf.-from Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Trsf.-from Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Trsf.-from Country/Region Code"));
        }
        modify("Transfer-from City")
        {
            TableRelation = IF ("Trsf.-from Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Trsf.-from Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Trsf.-from Country/Region Code"));
        }
        modify("Transfer-to City")
        {
            TableRelation = IF ("Trsf.-to Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Trsf.-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Trsf.-to Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 24)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Shipped"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Received"(Field 5753)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Has Shipped Lines"(Field 8000)".

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                SalesSetup.GET;
                IF SalesSetup."Default Transfer-from Code" <> '' THEN
                    VALIDATE("Transfer-from Code", SalesSetup."Default Transfer-from Code");

                IF SalesSetup."Default Transfer-to Code" <> '' THEN
                    VALIDATE("Transfer-to Code", SalesSetup."Default Transfer-to Code");
            end;
        }

        field(50000; "Source Document No."; Code[20])
        {
        }
    }



    var
        "--ASPL--": Integer;
        SalesSetup: Record "Sales & Receivables Setup";
}

