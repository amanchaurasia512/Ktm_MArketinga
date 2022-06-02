tableextension 50415 "Purch. Inv. Header_ktm" extends "Purch. Inv. Header"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Vendor Posting Group"(Field 31)".


        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".


        //Unsupported feature: Property Modification (Name) on "Closed(Field 1302)".

        field(1300; "Canceled By"; Code[20])
        {
            Caption = 'Canceled By';
            Editable = false;
            TableRelation = "Purch. Cr. Memo Hdr.";
        }
        field(1301; Canceled; Boolean)
        {
            CalcFormula = Exist("Purch. Cr. Memo Hdr." WHERE(Cancelled = CONST(true),
                                                             "Applies-to Doc. Type" = CONST(Invoice),
                                                             "Applies-to Doc. No." = FIELD("No.")));
            Caption = 'Canceled';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
        }
        field(50502; "Posting Time"; Time)
        {
            Description = 'NP15.1001';
        }
        field(50503; "Purchase Consignment No."; Code[20])
        {
            Description = 'VAT1.00';
        }
        field(50505; "Party Name"; Text[250])
        {
            Editable = true;
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
        field(50600; "VAT Base 1"; Decimal)
        {
            Caption = 'VAT Base Amt 13 %';
            Description = 'VAT Base Amt 13%';
        }
        field(50601; "Exempt Amount"; Decimal)
        {
            Caption = 'Vat Base Amt 0%';
            Description = 'VAT Base Amt 0%';
        }
        field(50602; "Free Item Vendor No."; Code[20])
        {
            Description = 'Used for the case when we get the free item for foreign vendor and that needs to be shown in the purchase vat book';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                //KMT2016CU5 >>
                VendorRec.RESET;
                VendorRec.SETRANGE("No.", "Free Item Vendor No.");
                IF VendorRec.FINDFIRST THEN
                    "Free Item Vendor Name" := VendorRec.Name;
                //KMT2016CU5 <<
            end;
        }
        field(50603; "Free Item Vendor Name"; Text[50])
        {
            Description = 'Used for the case when we get the free item for foreign vendor and that needs to be shown in the purchase vat book';
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
        field(70006; Delete; Boolean)
        {
        }
    }

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    //Unsupported feature: Property Modification (Fields) on "Brick(FieldGroup 2)".


    var
        VendorRec: Record Vendor;
}

