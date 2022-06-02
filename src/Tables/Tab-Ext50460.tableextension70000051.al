tableextension 50460 "tableextension70000051" extends "Sales Line Archive"
{
    fields
    {
        modify("Document No.")
        {
            TableRelation = "Sales Header Archive"."No." WHERE("Document Type" = FIELD("Document Type"), "Version No." = FIELD("Version No."));
        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE
            IF (Type = CONST("G/L Account")) "G/L Account" ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group" ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        modify("Purch. Order Line No.")
        {
            TableRelation = IF ("Drop Shipment" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order), "Document No." = FIELD("Purchase Order No."));
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Sales Line Archive"."Line No." WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence"), "Version No." = FIELD("Version No."));
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"), "Document No." = FIELD("Blanket Order No."));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No.")) ELSE
            "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Substitution Available"(Field 5702)".

        modify("Special Order Purch. Line No.")
        {
            TableRelation = IF ("Special Order" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order), "Document No." = FIELD("Special Order Purchase No."));
        }
        modify("Service Contract No.")
        {
            TableRelation = "Service Contract Header"."Contract No." WHERE("Contract Type" = CONST(Contract), "Customer No." = FIELD("Sell-to Customer No."), "Bill-to Customer No." = FIELD("Bill-to Customer No."));
        }
        field(50501; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
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

