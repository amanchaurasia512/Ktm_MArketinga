tableextension 50476 "Item Charge Assignment (Purch)" extends "Item Charge Assignment (Purch)"
{
    fields
    {
        modify("Document Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."));
        }
        modify("Applies-to Doc. No.")
        {
            TableRelation = IF ("Applies-to Doc. Type" = CONST(Order)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order)) ELSE
            IF ("Applies-to Doc. Type" = CONST(Invoice)) "Purchase Header"."No." WHERE("Document Type" = CONST(Invoice)) ELSE
            IF ("Applies-to Doc. Type" = CONST("Return Order")) "Purchase Header"."No." WHERE("Document Type" = CONST("Return Order")) ELSE
            IF ("Applies-to Doc. Type" = CONST("Credit Memo")) "Purchase Header"."No." WHERE("Document Type" = CONST("Credit Memo")) ELSE
            IF ("Applies-to Doc. Type" = CONST(Receipt)) "Purch. Rcpt. Header"."No." ELSE
            IF ("Applies-to Doc. Type" = CONST("Return Shipment")) "Return Shipment Header"."No.";
        }
        modify("Applies-to Doc. Line No.")
        {
            TableRelation = IF ("Applies-to Doc. Type" = CONST(Order)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order), "Document No." = FIELD("Applies-to Doc. No.")) ELSE
            IF ("Applies-to Doc. Type" = CONST(Invoice)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Invoice), "Document No." = FIELD("Applies-to Doc. No.")) ELSE
            IF ("Applies-to Doc. Type" = CONST("Return Order")) "Purchase Line"."Line No." WHERE("Document Type" = CONST("Return Order"), "Document No." = FIELD("Applies-to Doc. No.")) ELSE
            IF ("Applies-to Doc. Type" = CONST("Credit Memo")) "Purchase Line"."Line No." WHERE("Document Type" = CONST("Credit Memo"), "Document No." = FIELD("Applies-to Doc. No.")) ELSE
            IF ("Applies-to Doc. Type" = CONST(Receipt)) "Purch. Rcpt. Line"."Line No." WHERE("Document No." = FIELD("Applies-to Doc. No.")) ELSE
            IF ("Applies-to Doc. Type" = CONST("Return Shipment")) "Return Shipment Line"."Line No." WHERE("Document No." = FIELD("Applies-to Doc. No."));
        }
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Amount to Assign");  //standard code
                VALIDATE("Qty. to Assign");
            end;
        }
        modify("Amount to Assign")
        {
            trigger OnAfterValidate()
            begin
                "Amount to Assign" := ROUND("Qty. to Assign" * "Unit Cost", Currency."Amount Rounding Precision");
                "Qty. to Assign" := ROUND("Amount to Assign" / "Unit Cost", Currency."Amount Rounding Precision");
                VALIDATE("Qty. to Assign");
            end;
        }

        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(PragyapanPatra), Blocked = CONST(false));
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
    }

    var
        PurchHeader: Record "Purchase Header";
        Currency: Record Currency;
}

