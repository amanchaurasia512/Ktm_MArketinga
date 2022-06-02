tableextension 50465 "FA Ledger Entry_ktm" extends "FA Ledger Entry"
{
    fields
    {
        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(PragyapanPatra), Blocked = CONST(false));
        }
        field(50605; "FA Item Charge"; Code[20])
        {
            TableRelation = "Item Charge";
        }
    }
}

