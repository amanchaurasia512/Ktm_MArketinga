tableextension 50433 "VAT Entry_ktm" extends "VAT Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Document No."(Field 5)".


        //Unsupported feature: Property Modification (Editable) on "Amount(Field 9)".


        //Unsupported feature: Property Modification (Editable) on ""VAT Bus. Posting Group"(Field 39)".


        //Unsupported feature: Property Modification (Data type) on ""VAT Prod. Posting Group"(Field 40)".


        //Unsupported feature: Property Modification (Editable) on ""VAT Prod. Posting Group"(Field 40)".

        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
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
        field(50503; "Purchase Consignment No."; Code[20])
        {
            Description = 'VAT1.00';
            TableRelation = "TDS Posting Buffer"."TDS Group" WHERE("GL Account No." = CONST('No'));
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
        }
        field(50600; "VAT Base 1"; Decimal)
        {
            Caption = 'VAT Base Amt 13%';
            Description = 'VAT Base AmT 13%';
        }
        field(50601; "Exempt Amount"; Decimal)
        {
            Caption = 'Vat Base Amt 0%';
            Description = 'VAT Base Amt 0%';
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
    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 5)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CopyPostingGroupsFromGenJnlLine(GenJnlLine);
    "Posting Date" := GenJnlLine."Posting Date";
    "Document Date" := GenJnlLine."Document Date";
    #4..15
    "Bill-to/Pay-to No." := GenJnlLine."Bill-to/Pay-to No.";
    "Country/Region Code" := GenJnlLine."Country/Region Code";
    "VAT Registration No." := GenJnlLine."VAT Registration No.";

    OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..18
     //KMT2016CU5 >>
    "VAT Base 1" := GenJnlLine."VAT Base 1";
    "Exempt Amount" := GenJnlLine."Exempt Amount";
    PragyapanPatra := GenJnlLine.PragyapanPatra;
    "Letter of Credit/Telex Trans." := GenJnlLine."Letter of Credit/Telex Trans.";
    "Free Item Vendor No." := GenJnlLine."Free Item Vendor No.";
    "Free Item Vendor Name" := GenJnlLine."Free Item Vendor Name";
    IF GenJnlLine."Bill-to/Pay-to No." <> '' THEN
      "Bill-to/Pay-to No." := GenJnlLine."Bill-to/Pay-to No."
    ELSE
      "Bill-to/Pay-to No." := GenJnlLine."Party No.";
    "Exclude PP in VAT Book" := GenJnlLine."Exclude PP in VAT Book";
    //KMT2016CU5 <<
    OnAfterCopyVATEntryFromGenJnlLine(GenJnlLine);

    OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: VATEntry) (ParameterCollection) on "OnAfterCopyFromGenJnlLine(PROCEDURE 8)".


    procedure SetUnrealAmountsToZero()
    begin
        "Unrealized Amount" := 0;
        "Unrealized Base" := 0;
        "Remaining Unrealized Amount" := 0;
        "Remaining Unrealized Base" := 0;
        "Add.-Currency Unrealized Amt." := 0;
        "Add.-Currency Unrealized Base" := 0;
        "Add.-Curr. Rem. Unreal. Amount" := 0;
        "Add.-Curr. Rem. Unreal. Base" := 0;
        "Realized Amount" := 0;
        "Realized Base" := 0;
        "Add.-Curr. Realized Amount" := 0;
        "Add.-Curr. Realized Base" := 0;
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterCopyVATEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    //Unsupported feature: Deletion (ParameterCollection) on "OnAfterCopyFromGenJnlLine(PROCEDURE 8).VATEntry(Parameter 1000)".



    //Unsupported feature: Property Modification (Id) on "Text000(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : 1999;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Cust(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //Cust : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Cust : 1998;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Vend(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //Vend : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Vend : 1997;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GLSetup(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //GLSetup : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GLSetup : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GLSetupRead(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //GLSetupRead : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GLSetupRead : 1995;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ConfirmAdjustQst(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //ConfirmAdjustQst : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ConfirmAdjustQst : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ProgressMsg(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //ProgressMsg : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ProgressMsg : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AdjustTitleMsg(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //AdjustTitleMsg : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AdjustTitleMsg : 1992;
    //Variable type has not been exported.

    var
        VendorRec: Record Vendor;
}

