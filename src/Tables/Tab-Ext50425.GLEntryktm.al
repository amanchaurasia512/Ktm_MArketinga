tableextension 50425 "G/L Entry_ktm" extends "G/L Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50000; "Pass Value to Sales/Purch (LCY"; Boolean)
        {
            Caption = 'Pass Value to Report';
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if t he item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50003; "TDS Group"; Code[20])
        {
            Description = 'TDS1.00';
            TableRelation = "TDS Posting Group".Code;
        }
        field(50004; "TDS%"; Decimal)
        {
            Description = 'TDS1.00';
        }
        field(50005; "TDS Type"; Option)
        {
            Description = 'TDS1.00';
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(50006; "TDS Amount"; Decimal)
        {
            Description = 'TDS1.00';
        }
        field(50007; "TDS Base Amount"; Decimal)
        {
            Description = 'TDS1.00';
        }
        field(50008; "TDS Entry No."; Integer)
        {
            Description = 'TDS1.00';
        }
        field(50100; "Employee Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50501; Narration; Text[250])
        {
        }
        field(50502; PragyapanPatra; Code[100])
        {
        }
        field(50503; "Localized VAT Identifier"; Option)
        {
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50504; "Purchase Consignment No."; Code[20])
        {
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
            TableRelation = IF ("Party Type" = CONST(Employee)) "Dimension Value".Code WHERE("Dimension Code" = CONST('EMPLOYEE'))
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
        field(50600; "VAT Base 1"; Decimal)
        {
            Caption = 'VAT Base Amt 13 %';
        }
        field(50601; "Exempt Amount"; Decimal)
        {
            Caption = 'Vat Base Amt 0%';
        }
        field(50602; "RBI Product Code"; Code[10])
        {
        }
        field(50603; "Free Item Vendor No."; Code[20])
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
        field(50604; "Free Item Vendor Name"; Text[50])
        {
            Description = 'Used for the case when we get the free item for foreign vendor and that needs to be shown in the purchase vat book';
        }
        field(50605; "Account Name"; Text[50])
        {
        }
        field(50606; "Party VAT Registration No."; Code[30])
        {
        }
        // field(70000; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,3';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(3));
        // }
        // field(70001; "Shortcut Dimension 4 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,4';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(4));
        // }
        // field(70002; "Shortcut Dimension 5 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,5';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(5));
        // }
        // field(70003; "Shortcut Dimension 6 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,6';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(6));
        // }
        // field(70004; "Shortcut Dimension 7 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,7';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(7));
        // }
        // field(70005; "Shortcut Dimension 8 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,8';
        //     TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(8));
        // }
        field(70007; "Demand loan"; Code[30])
        {
        }
    }
    keys
    {
        key(Key1; "TDS Group", "Party No.")
        {
        }
    }



    procedure CopyShortcutDimensions(var GLEntry: Record "G/L Entry"; DimValueCode: array[8] of Code[20])
    begin
        GLEntry."Shortcut Dimension 3 Code" := DimValueCode[3];
        GLEntry."Shortcut Dimension 4 Code" := DimValueCode[4];
        GLEntry."Shortcut Dimension 5 Code" := DimValueCode[5];
        GLEntry."Shortcut Dimension 6 Code" := DimValueCode[6];
        GLEntry."Shortcut Dimension 7 Code" := DimValueCode[7];
        GLEntry."Shortcut Dimension 8 Code" := DimValueCode[8];
    end;

    var
        VendorRec: Record Vendor;
        DimMgt: Codeunit DimensionManagement;
        ShortcutCustomDimCode: array[8] of Code[20];
}

