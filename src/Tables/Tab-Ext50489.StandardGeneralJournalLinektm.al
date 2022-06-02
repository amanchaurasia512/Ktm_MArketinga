tableextension 50489 "Standard General Journal Line" extends "Standard General Journal Line"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";
        }
        modify("Bill-to/Pay-to No.")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor;
        }
        modify("Posting Group")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group" ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group";
        }
        modify("Source No.")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        modify("Ship-to/Order Address Code")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Bill-to/Pay-to No.")) ELSE
            IF ("Account Type" = CONST(Vendor)) "Order Address".Code WHERE("Vendor No." = FIELD("Bill-to/Pay-to No.")) ELSE
            IF ("Bal. Account Type" = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Bill-to/Pay-to No.")) ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) "Order Address".Code WHERE("Vendor No." = FIELD("Bill-to/Pay-to No."));
        }
        modify("Sell-to/Buy-from No.")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor;
        }

        //Unsupported feature: Deletion on ""Tax Area Code"(Field 82).OnValidate".


        //Unsupported feature: Property Deletion (CaptionML) on ""Tax Area Code"(Field 82)".


        //Unsupported feature: Deletion on ""Bal. Tax Area Code"(Field 86).OnValidate".


        //Unsupported feature: Property Deletion (CaptionML) on ""Bal. Tax Area Code"(Field 86)".

        field(50000; "Pass Value to Sales/Purch (LCY"; Boolean)
        {
            Caption = 'Pass Value to Report';
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50004; "Purchase Consignment No."; Code[20])
        {
        }
        field(50005; "TDS Group"; Code[20])
        {
            Description = 'TDS1.00';
            TableRelation = "TDS Posting Group".Code WHERE(Blocked = CONST(false));
        }
        field(50006; "TDS%"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50007; "TDS Type"; Option)
        {
            Description = 'TDS1.00';
            Editable = false;
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(50008; "TDS Amount"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50009; "TDS Base Amount"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50010; "TDS Entry No."; Integer)
        {
            Description = 'TDS1.00';
        }
        field(50501; Narration; Text[250])
        {
        }
        field(50502; PragyapanPatra; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(PragyapanPatra), Blocked = CONST(false));
        }
        field(50503; "Localized VAT Identifier"; Option)
        {
            Editable = true;
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50505; "Party Name"; Text[250])
        {
            Editable = false;
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
        field(50507; "Party Type"; Option)
        {
            OptionCaption = ' ,Employee,Branch,Vendor,Customer,Party';
            OptionMembers = " ",Employee,Branch,Vendor,Customer,Party;
        }
        field(50508; "Party No."; Code[100])
        {
            TableRelation = IF ("Party Type" = CONST(Employee)) Employee."No." ELSE
            IF ("Party Type" = CONST(Branch)) "Dimension Value".Code WHERE("Dimension Code" = CONST('BRANCH')) ELSE
            IF ("Party Type" = CONST(Vendor)) Vendor."No." ELSE
            IF ("Party Type" = CONST(Customer)) Customer."No." ELSE
            IF ("Party Type" = CONST(Party)) "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(Party));
        }
        field(50510; "T/R"; Code[100])
        {
            Caption = 'T/R';
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("T/R"));
        }
        field(50511; Margin; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(Margin));
        }
        field(50600; "VAT Base 1"; Decimal)
        {
            Caption = 'VAT Base Amt 13 %';
        }
        field(50601; "Exempt Amount"; Decimal)
        {
            Caption = 'Vat Base Amt 0%';
        }
        field(50602; "RBI Product Code"; Code[10])
        {
        }
        field(50603; "Free Item Vendor No."; Code[20])
        {
            Description = 'Used for the case when we get the free item for foreign vendor and that needs to be shown in the purchase vat book';
            TableRelation = Vendor;
        }
        field(50604; "Free Item Vendor Name"; Text[50])
        {
            Description = 'Used for the case when we get the free item for foreign vendor and that needs to be shown in the purchase vat book';
        }
        field(50605; "Account Name"; Text[50])
        {
        }
        field(50606; "VAT. Registration No."; Code[30])
        {
        }
        field(50607; "FA Item Charge"; Code[20])
        {
            TableRelation = "Item Charge";
        }
    }
}

