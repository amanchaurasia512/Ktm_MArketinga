tableextension 50414 "Purch. Rcpt. Line_ktm" extends "Purch. Rcpt. Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Buy-from Vendor No."(Field 2)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Currency Code"(Field 91)".


        //Unsupported feature: Property Modification (Editable) on ""Unit Cost"(Field 100)".


        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50000; "Exmpt. Purchase"; Boolean)
        {
            Caption = 'Exempt Purchase';
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
            FieldClass = Normal;
        }
        field(50502; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            FieldClass = Normal;
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
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


    //Unsupported feature: Code Modification on "GetCurrencyCodeFromHeader(PROCEDURE 1)".

    //procedure GetCurrencyCodeFromHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Document No." = PurchRcptHeader."No." THEN
      EXIT(PurchRcptHeader."Currency Code");
    IF PurchRcptHeader.GET("Document No.") THEN
      EXIT(PurchRcptHeader."Currency Code");
    EXIT('');
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF "Document No." = PurchRcptHeader."No." THEN
      EXIT(PurchRcptHeader."Currecny Code");
    IF PurchRcptHeader.GET("Document No.") THEN
      EXIT(PurchRcptHeader."Currecny Code");
    EXIT('');
    */
    //end;
}

