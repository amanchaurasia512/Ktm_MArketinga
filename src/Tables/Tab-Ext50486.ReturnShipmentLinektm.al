tableextension 50486 "Return Shipment Line_ktm" extends "Return Shipment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account" ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group" ELSE
            IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"), "Document No." = FIELD("Blanket Order No."));
        }
        modify("Bin Code")
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"), "Item Filter" = FIELD("No."), "Variant Filter" = FIELD("Variant Code"));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No.")) ELSE
            "Unit of Measure";
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

