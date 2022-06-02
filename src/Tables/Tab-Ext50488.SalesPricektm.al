tableextension 50488 "Sales Price_ktm" extends "Sales Price"
{
    fields
    {
        modify("Sales Code")
        {
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group" ELSE
            IF ("Sales Type" = CONST(Customer)) Customer ELSE
            IF ("Sales Type" = CONST(Campaign)) Campaign;
        }
        field(50000; "Item Name"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50001; "Product Segment Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Global Dimension 1 Code" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('PRODUCT SEGMENT'));
        }
    }
}

