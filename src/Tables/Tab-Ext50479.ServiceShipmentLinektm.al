tableextension 50479 "Service Shipment Line_ktm" extends "Service Shipment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST(Cost)) "Service Cost" ELSE
            IF (Type = CONST("G/L Account")) "G/L Account";
        }
        modify("Time Sheet Date")
        {
            TableRelation = "Time Sheet Detail".Date WHERE("Time Sheet No." = FIELD("Time Sheet No."), "Time Sheet Line No." = FIELD("Time Sheet Line No."));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No.")) ELSE
            "Unit of Measure";
        }
        modify("Fault Code")
        {
            TableRelation = "Fault Code".Code WHERE("Fault Area Code" = FIELD("Fault Area Code"), "Symptom Code" = FIELD("Symptom Code"));
        }
        modify("Replaced Item No.")
        {
            TableRelation = IF ("Replaced Item Type" = CONST(Item)) Item ELSE
            IF ("Replaced Item Type" = CONST("Service Item")) "Service Item";
        }
        field(50501; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50502; "Returned Document No."; Code[20])
        {
        }
    }
}

