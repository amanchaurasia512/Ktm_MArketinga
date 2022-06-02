tableextension 50462 "tableextension70000053" extends "Purchase Line Archive"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = "Purchase Header Archive"."No." WHERE("Document Type" = FIELD("Document Type"), "Version No." = FIELD("Version No."));
        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE
            IF (Type = CONST("G/L Account")) "G/L Account" ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group" ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        modify("Sales Order Line No.")
        {
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Sales Line"."Line No." WHERE("Document Type" = CONST(Order), "Document No." = FIELD("Sales Order No."));
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Purchase Line Archive"."Line No." WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence"), "Version No." = FIELD("Version No."));
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"), "Document No." = FIELD("Blanket Order No."));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No.")) ELSE
            "Unit of Measure";
        }
        modify("Special Order Sales Line No.")
        {
            TableRelation = IF ("Special Order" = CONST(true)) "Sales Line"."Line No." WHERE("Document Type" = CONST(Order), "Document No." = FIELD("Special Order Sales No."));
        }
        modify("Operation No.")
        {
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE(Status = CONST(Released), "Prod. Order No." = FIELD("Prod. Order No."), "Routing No." = FIELD("Routing No."));
        }
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE(Status = FILTER(Released ..), "Prod. Order No." = FIELD("Prod. Order No."));
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50003; "TDS Group"; Code[20])
        {
            Description = 'TDS1.00';
            TableRelation = "TDS Posting Group".Code WHERE(Type = FILTER("Purchase TDS"), Blocked = CONST(false));
        }
        field(50004; "TDS%"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50005; "TDS Type"; Option)
        {
            Description = 'TDS1.00';
            Editable = false;
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(50006; "TDS Amount"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50007; "TDS Base Amount"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
        }
        field(50502; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
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
            TableRelation = IF ("Party Type" = CONST(Employee)) "Dimension Value".Code WHERE("Dimension Code" = CONST('EMPLOYEE')) ELSE
            IF ("Party Type" = CONST(Branch)) "Dimension Value".Code WHERE("Dimension Code" = CONST('BRANCH')) ELSE
            IF ("Party Type" = CONST(Vendor)) Vendor."No." ELSE
            IF ("Party Type" = CONST(Customer)) Customer."No." ELSE
            IF ("Party Type" = CONST(Party)) "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(Party));
        }
        field(50605; "FA Item Charge"; Code[20])
        {
            TableRelation = "Item Charge";
        }
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
    }
}

