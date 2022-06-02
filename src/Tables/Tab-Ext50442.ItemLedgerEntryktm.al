tableextension 50442 "Item Ledger Entry_ktm" extends "Item Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50001; "Sub-Category"; Option)
        {
            CalcFormula = Lookup(Item."Sub-Category" WHERE("No." = FIELD("Item No.")));
            Caption = 'RBI Sub-Category';
            Description = 'Currently being used for only RBI items';
            FieldClass = FlowField;
            OptionCaption = ' ,Health,HY HO';
            OptionMembers = " ",Health,"HY HO";
        }
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
        }
        field(50502; "Purchase Consignment No."; Code[20])
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
        field(50512; "Item Name"; Code[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50513; "Description 2"; Code[50])
        {
        }
        field(50602; "RBI Product Code"; Code[10])
        {
        }
        field(50603; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
        // field(70000;"Shortcut Dimension 3 Code";Code[20])
        // {
        //     CaptionClass = '1,2,3';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
        // }
        // field(70001;"Shortcut Dimension 4 Code";Code[20])
        // {
        //     CaptionClass = '1,2,4';
        //     TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
        // }
        // field(70002;"Shortcut Dimension 5 Code";Code[20])
        // {
        //     CaptionClass = '1,2,5';
        //     TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(5));
        // }
        // field(70003;"Shortcut Dimension 6 Code";Code[20])
        // {
        //     CaptionClass = '1,2,6';
        //     TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(6));
        // }
        // field(70004;"Shortcut Dimension 7 Code";Code[20])
        // {
        //     CaptionClass = '1,2,7';
        //     TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(7));
        // }
        // field(70005;"Shortcut Dimension 8 Code";Code[20])
        // {
        //     CaptionClass = '1,2,8';
        //     TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(8));
        // }
    }
}

