tableextension 50493 "Item Journal Line_ktm" extends "Item Journal Line"
{
    fields
    {
        field(50002; "Transfer Receipt No."; Code[20])
        {
            TableRelation = "Transfer Receipt Header";
        }
        field(50003; "Transfer Receipt Line No."; Integer)
        {
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
        field(50502; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            Editable = false;
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50503; "Purchase Consignment No."; Code[20])
        {
            Description = 'VAT1.00';
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
            TableRelation = IF ("Party Type" = CONST(Employee)) Employee."No."
            ELSE
            IF ("Party Type" = CONST(Branch)) "Dimension Value".Code WHERE("Dimension Code" = CONST('BRANCH'))
            ELSE
            IF ("Party Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Party Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Party Type" = CONST(Party)) "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(Party));
        }
        field(50509; "Nepali Date"; Code[10])
        {
            CalcFormula = Lookup("English-Nepali Date"."Nepali Date" WHERE("English Date" = FIELD("Posting Date")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50510; Loan; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("T/R"));
        }
        field(50511; Margin; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(Margin));
        }
        field(50512; "Item Name"; Code[50])
        {
        }
        field(50513; "Description 2"; Code[50])
        {
        }
        field(50602; "RBI Product Code"; Code[10])
        {
        }
    }
}

