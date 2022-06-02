tableextension 50475 "Value Entry_ktm" extends "Value Entry"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor ELSE
            IF ("Source Type" = CONST(Item)) Item;
        }
        modify("Source Posting Group")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) "Customer Posting Group" ELSE
            IF ("Source Type" = CONST(Vendor)) "Vendor Posting Group" ELSE
            IF ("Source Type" = CONST(Item)) "Inventory Posting Group";
        }

        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        modify("No.")
        {
            TableRelation = IF (Type = CONST("Machine Center")) "Machine Center" ELSE
            IF (Type = CONST("Work Center")) "Work Center" ELSE
            IF (Type = CONST(Resource)) Resource;
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
        }
        field(50502; "Purchase Consignment No."; Code[20])
        {
            Description = 'VAT1.00';
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
        field(50512; "Item Name"; Code[50])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50602; "RBI Product Code"; Code[10])
        {
        }
        // field(70000;"Shortcut Dimension 3 Code";Code[20])
        // {
        //     CaptionClass = '1,2,3';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
        // }
        // field(70001;"Shortcut Dimension 4 Code";Code[20])
        // {
        //     CaptionClass = '1,2,4';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(4));
        // }
        // field(70002;"Shortcut Dimension 5 Code";Code[20])
        // {
        //     CaptionClass = '1,2,5';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(5));
        // }
        // field(70003;"Shortcut Dimension 6 Code";Code[20])
        // {
        //     CaptionClass = '1,2,6';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(6));
        // }
        // field(70004;"Shortcut Dimension 7 Code";Code[20])
        // {
        //     CaptionClass = '1,2,7';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(7));
        // }
        // field(70005;"Shortcut Dimension 8 Code";Code[20])
        // {
        //     CaptionClass = '1,2,8';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(8));
        // }
    }
    keys
    {
        // key(Key1;PragyapanPatra,"Item No.")
        // {
        // }
    }
}

