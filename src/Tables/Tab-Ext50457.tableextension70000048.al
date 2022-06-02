tableextension 50457 "tableextension70000048" extends "Invoice Post. Buffer"
{
    fields
    {
        modify("Tax Area Code")
        {
            TableRelation = "Transaction Specification";
        }

        //Unsupported feature: Property Deletion (DataClassification) on ""System-Created Entry"(Field 17)".


        //Unsupported feature: Property Deletion (DataClassification) on ""Tax Area Code"(Field 18)".

        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
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
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
        field(50502; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50505; "Party Name"; Text[250])
        {
            Editable = false;
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
        field(50510; Loan; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("T/R"));
        }
        field(50511; Margin; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(Margin));
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
        field(50605; "FA Item Charge"; Code[20])
        {
            TableRelation = "Item Charge";
        }
        field(50609; "TDS Amount (ACY)"; Decimal)
        {
            Caption = 'TDS Amount (ACY)';
            DataClassification = ToBeClassified;
        }
        field(50610; "TDS Base Amount (ACY)"; Decimal)
        {
            Caption = '"TDS Base Amount (ACY)"';
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "PrepareSales(PROCEDURE 1)".

    //procedure PrepareSales();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(Rec);
    Type := SalesLine.Type;
    "System-Created Entry" := TRUE;
    #4..31
      "VAT Amount (ACY)" := 0;
    END;

    OnAfterInvPostBufferPrepareSales(SalesLine,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..34
    //OnAfterInvPostBufferPrepareSales(SalesLine,Rec);        //they both are event 
    OnAfterPrepareSales(SalesLine);
    */
    //end;




    //Unsupported feature: Code Modification on "PrepareService(PROCEDURE 11)".

    //procedure PrepareService();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(Rec);
    CASE ServiceLine.Type OF
      ServiceLine.Type::Item:
    #4..25
      "Use Tax" := FALSE;
      Quantity := ServiceLine."Qty. to Invoice (Base)";
    END;

    OnAfterInvPostBufferPrepareService(ServiceLine,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..28
    OnAfterPrepareService(ServiceLine);         //Event is called in modified code 
    */
    //end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPrepareSales(SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPreparePurchase(PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPrepareService(ServiceLine: Record "Service Line")
    begin
    end;

    procedure SetTDSAccount(var PurchLine: Record "Purchase Line")
    begin
        //TDS1.00
        IF PurchLine."TDS Group" <> '' THEN
            "TDS Group" := PurchLine."TDS Group";
        IF PurchLine."TDS%" <> 0 THEN
            "TDS%" := PurchLine."TDS%";
        IF PurchLine."TDS Type" <> PurchLine."TDS Type"::" " THEN
            "TDS Type" := PurchLine."TDS Type";
        //TDS1.00
    end;

    procedure SetTDSAmounts(TotalTDSAmount: Decimal; TotalTDSBaseAmount: Decimal)
    begin
        //TDS1.00
        "TDS Amount" := TotalTDSAmount;
        "TDS Base Amount" := TotalTDSBaseAmount;
        //TDS1.00
    end;

    procedure ReverseTDSAmounts()
    begin
        //TDS1.00
        "TDS Amount" := -"TDS Amount";
        "TDS Base Amount" := -"TDS Base Amount";
        //TDS1.00
    end;

    procedure UpdateTDSFields(var PurchLine: Record "Purchase Line")
    begin
        //TDS1.00
        IF PurchLine."TDS Group" <> '' THEN
            "TDS Group" := PurchLine."TDS Group";
        IF PurchLine."TDS%" <> 0 THEN
            "TDS%" := PurchLine."TDS%";
        IF PurchLine."TDS Type" <> PurchLine."TDS Type"::" " THEN
            "TDS Type" := PurchLine."TDS Type";
        //TDS1.00

        //OnAfterInvPostBufferPrepareService(ServiceLine, Rec);
    end;

    var
        VendorRec: Record Vendor;
        ServiceLine: Record "Service Line";
}

