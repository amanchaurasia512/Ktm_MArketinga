tableextension 50471 "Transfer Shipment Line_ktm" extends "Transfer Shipment Line"
{
    fields
    {
        modify("Transfer-from Bin Code")
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-from Code"), "Item Filter" = FIELD("Item No."), "Variant Filter" = FIELD("Variant Code"));
        }
        field(50000; "Source Document No."; Code[20])
        {
        }
        field(50001; "Source Document Line No."; Integer)
        {
        }
    }
}

