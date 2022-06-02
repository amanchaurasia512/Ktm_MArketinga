tableextension 50473 "Transfer Receipt Line_ktm" extends "Transfer Receipt Line"
{
    fields
    {
        modify("Transfer-To Bin Code")
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-to Code"), "Item Filter" = FIELD("Item No."), "Variant Filter" = FIELD("Variant Code"));
        }
        field(50000; "Source Document No."; Code[20])
        {
        }
        field(50001; "Source Document Line No."; Integer)
        {
        }
    }
}

