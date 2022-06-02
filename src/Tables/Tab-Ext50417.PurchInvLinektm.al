tableextension 50417 "Purch. Inv. Line_ktm" extends "Purch. Inv. Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50000; "Exmpt. Purchase"; Boolean)
        {
            Caption = 'Exempt Purchase';
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50003; "TDS Group"; Code[20])
        {
            Description = 'TDS1.00';
            TableRelation = "TDS Posting Group".Code WHERE("Type" = FILTER("Purchase TDS"),
                                                            Blocked = CONST(false));
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
        field(50602; "RBI Product Code"; Code[10])
        {
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

    //Unsupported feature: Variable Insertion (Variable: PurchRcptHeader) (VariableCollection) on "GetPurchRcptLines(PROCEDURE 5)".



    //Unsupported feature: Property Modification (Id) on "DimMgt(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimMgt : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimMgt : 1999;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UOMMgt(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //UOMMgt : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UOMMgt : 1998;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DeferralUtilities(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //DeferralUtilities : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DeferralUtilities : 1997;
    //Variable type has not been exported.

    var
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        PurchRcptLine: Record "Purch. Rcpt. Line";
}

