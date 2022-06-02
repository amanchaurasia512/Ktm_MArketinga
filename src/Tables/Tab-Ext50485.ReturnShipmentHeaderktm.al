tableextension 50485 "Return Shipment Header_ktm" extends "Return Shipment Header"
{
    fields
    {
        modify("Pay-to City")
        {
            TableRelation = IF ("Pay-to Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
        }
        modify("Ship-to City")
        {
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        modify("Buy-from City")
        {
            TableRelation = IF ("Buy-from Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
        }
        modify("Pay-to Post Code")
        {
            TableRelation = IF ("Pay-to Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
        }
        modify("Buy-from Post Code")
        {
            TableRelation = IF ("Buy-from Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
        }
        field(50503; "Purchase Consignment No."; Code[20])
        {
            Description = 'VAT1.00';
            TableRelation = "TDS Posting Buffer"."TDS Group" WHERE("GL Account No." = CONST('NO'));
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
    }
}

