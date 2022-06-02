tableextension 50452 "Purchase Header_ktm" extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            TableRelation = Vendor WHERE(Blocked = FILTER(' '));
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                InitRecOnVendUpdate;
                TESTFIELD(Status, Status::Open);
                BEGIN
                    RecreatePurchLines(FIELDCAPTION("Buy-from Vendor No."));
                    //KMT2016CU5 >>
                    VALIDATE("Assigned User ID", USERID);
                    "Location Code" := 'DHUMBARAHI';
                    "Party Type" := "Party Type"::Vendor;
                    "Party No." := "Buy-from Vendor No.";
                    "Party Name" := "Buy-from Vendor Name";
                    //KMT2016CU5 <<
                    IF "No." <> '' THEN
                        StandardCodesMgt.CheckShowPurchRecurringLinesNotification(Rec);
                END;
            end;
        }

        //Unsupported feature: Property Modification (Editable) on ""Currency Factor"(Field 33)".

        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                CALCFIELDS("Nepali Date");
            end;
        }
        field(50501; PragyapanPatra; Code[100])
        {
            Description = 'NP15.1001';
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(PragyapanPatra),
                                                                            Blocked = CONST(false));

            trigger OnValidate()
            begin
                UpdatePurchLines(FIELDCAPTION(PragyapanPatra), FALSE);
                UpdatePurchLine("No.");
            end;
        }
        field(50503; "Purchase Consignment No."; Code[20])
        {
            Description = 'VAT1.00';

            trigger OnValidate()
            begin
                UpdatePurchLine("No.");
            end;
        }
        field(50505; "Party Name"; Text[250])
        {
            Editable = true;
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));

            trigger OnValidate()
            begin
                UpdatePurchLine("No.");
            end;
        }
        field(50507; "Party Type"; Option)
        {
            OptionCaption = ' ,Employee,Branch,Vendor,Customer,Party';
            OptionMembers = " ",Employee,Branch,Vendor,Customer,Party;

            trigger OnValidate()
            begin

                TESTFIELD("Payment Method Code");
                "Party No." := '';
                UpdatePurchLine("No.");
            end;
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

            trigger OnValidate()
            begin
                UpdatePurchLine("No.");
            end;
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

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(70001; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(70002; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(70003; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(70004; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(70005; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(70006; "Delete Record"; Boolean)
        {
        }
    }
    trigger OnInsert()
    begin
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header", "Document Type", "No.");
        "Location Code" := 'DHUMBARAHI';  //KMT2016CU5
    end;
    //Unsupported feature: Code Modification on "UpdatePurchLinesByFieldNo(PROCEDURE 99)".

    //procedure UpdatePurchLinesByFieldNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := FALSE;
    OnBeforeUpdatePurchLinesByFieldNo(Rec,ChangedFieldNo,AskQuestion,IsHandled);
    IF IsHandled THEN
    #4..72
          ELSE
            OnUpdatePurchLinesByChangedFieldName(Rec,PurchLine,Field.FieldName,ChangedFieldNo);
        END;
        PurchLine.MODIFY(TRUE);
        PurchLineReserve.VerifyChange(PurchLine,xPurchLine);
      UNTIL PurchLine.NEXT = 0;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..75                                                           //There is nothing in modified code
        OnAfterUpdatePurchaseLine(ChangedFieldName,PurchLine);
    #76..78
    */
    //end;

    local procedure TransferSavedFieldsSpecialOrder(var DestinationPurchaseLine: Record "Purchase Line"; var SourcePurchaseLine: Record "Purchase Line")
    var
        SalesLine: Record "Sales Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    begin
        SalesLine.GET(SalesLine."Document Type"::Order,
          SourcePurchaseLine."Special Order Sales No.",
          SourcePurchaseLine."Special Order Sales Line No.");
        CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine, DestinationPurchaseLine);
        DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order";
        DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
        DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
        DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
        DestinationPurchaseLine.VALIDATE("Unit of Measure Code", SourcePurchaseLine."Unit of Measure Code");
        IF SourcePurchaseLine.Quantity <> 0 THEN
            DestinationPurchaseLine.VALIDATE(Quantity, SourcePurchaseLine.Quantity);

        SalesLine.VALIDATE("Unit Cost (LCY)", DestinationPurchaseLine."Unit Cost (LCY)");
        SalesLine."Special Order Purchase No." := DestinationPurchaseLine."Document No.";
        SalesLine."Special Order Purch. Line No." := DestinationPurchaseLine."Line No.";
        SalesLine.MODIFY;
    end;

    procedure CheckSpecOrderAddressDetails(SalesHeader: Record "Sales Header"): Boolean
    var
        LocationCode: Record Location;
    begin
        NameAddressDetails := SpecOrderNameAddressDetails;
        IF LocationCode.GET(SalesHeader."Location Code") THEN
            SpecOrderNameAddressDetails :=
              LocationCode.Name + LocationCode."Name 2" +
              LocationCode.Address + LocationCode."Address 2" +
              LocationCode."Post Code" + LocationCode.City +
              LocationCode.Contact
        ELSE BEGIN
            CompanyInfo.GET;
            SpecOrderNameAddressDetails :=
              CompanyInfo."Ship-to Name" + CompanyInfo."Ship-to Name 2" +
              CompanyInfo."Ship-to Address" + CompanyInfo."Ship-to Address 2" +
              CompanyInfo."Ship-to Post Code" + CompanyInfo."Ship-to City" +
              CompanyInfo."Ship-to Contact";
        END;
        IF NameAddressDetails = '' THEN
            NameAddressDetails := SpecOrderNameAddressDetails;
        EXIT(NameAddressDetails = SpecOrderNameAddressDetails);
    end;

    local procedure InitRecOnVendUpdate()
    begin
        IF NOT SkipInitialization THEN
            InitInsert;
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterUpdatePurchaseLine(ChangedFieldName: Text[100]; var PurchaseLine: Record "Purchase Line")
    begin
    end;

    local procedure "--KMT2016CU5--"()
    begin
    end;

    local procedure UpdatePurchLine(DocumentNo: Code[20])
    var
        PurchLineRec: Record "Purchase Line";
    begin
        //KMT2016CU5 >>
        PurchLineRec.RESET;
        PurchLineRec.SETRANGE("Document No.", DocumentNo);
        IF PurchLineRec.FINDSET THEN BEGIN
            REPEAT
                PurchLineRec."Letter of Credit/Telex Trans." := "Letter of Credit/Telex Trans.";
                PurchLineRec.PragyapanPatra := PragyapanPatra; //VAT1.00
                PurchLineRec.VALIDATE("Party Type", "Party Type");
                PurchLineRec."Party No." := "Party No.";
                PurchLineRec."Purchase Consignment No." := "Purchase Consignment No."; //VAT1.00
                PurchLineRec.MODIFY;
            UNTIL PurchLineRec.NEXT = 0;
        END;
        // KMT2016CU5 <<
    end;

    procedure CalculateTDS()
    var
        TDSPostingGroup: Record "TDS Posting Group";
        PurchaseLine: Record "Purchase Line";
        Currency: Record Currency;
    begin
        // TDS1.00 >>
        Currency.InitRoundingPrecision;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", "Document Type");
        PurchaseLine.SETRANGE("Document No.", "No.");
        PurchaseLine.SETFILTER("TDS Group", '<>%1', '');
        IF PurchaseLine.FINDFIRST THEN BEGIN
            REPEAT
                IF "Prices Including VAT" THEN
                    PurchaseLine."TDS Base Amount" := (PurchaseLine."Direct Unit Cost" - (PurchaseLine."Direct Unit Cost" * PurchaseLine."VAT %" / 100)) * PurchaseLine."Qty. to Invoice"
                ELSE
                    PurchaseLine."TDS Base Amount" := PurchaseLine."Direct Unit Cost" * PurchaseLine."Qty. to Invoice";

                PurchaseLine."TDS Amount" := ROUND(PurchaseLine."TDS Base Amount" * PurchaseLine."TDS%" / 100, Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                PurchaseLine."TDS Type" := PurchaseLine."TDS Type"::"Purchase TDS";
                PurchaseLine.MODIFY;
            UNTIL PurchaseLine.NEXT = 0;
        END;
        //TDS1.00 <<
    end;

    var
        ChangeCurrencyQst: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created. You may need to update the price information manually.\\Do you want to change %1?';

        VendorRec: Record Vendor;
        ChangedFieldName: Text[100];
        NameAddressDetails: Text[512];
        SpecOrderNameAddressDetails: Text[512];
        SkipInitialization: Boolean;
        CompanyInfo: Record "Company Information";
        StandardCodesMgt: Codeunit "Standard Codes Mgt.";
        ArchiveManagement: Codeunit ArchiveManagement;
}

