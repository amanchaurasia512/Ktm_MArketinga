tableextension 50454 "Purchase Line_ktm" extends "Purchase Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Buy-from Vendor No."(Field 2)".

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                PurchHeader.TESTFIELD("Buy-from Vendor No.");
                "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                "Currency Code" := PurchHeader."Currency Code";
                "Expected Receipt Date" := PurchHeader."Expected Receipt Date";
                "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                IF NOT IsServiceItem THEN
                    "Location Code" := PurchHeader."Location Code";
                "Transaction Type" := PurchHeader."Transaction Type";
                "Transport Method" := PurchHeader."Transport Method";
                "Pay-to Vendor No." := PurchHeader."Pay-to Vendor No.";
                "Gen. Bus. Posting Group" := PurchHeader."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := PurchHeader."VAT Bus. Posting Group";
                "Entry Point" := PurchHeader."Entry Point";
                Area := PurchHeader.Area;
                "Transaction Specification" := PurchHeader."Transaction Specification";
                "Tax Area Code" := PurchHeader."Tax Area Code";
                "Tax Liable" := PurchHeader."Tax Liable";
                IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order) AND (Type <> Type::" ") THEN
                    "Prepayment %" := PurchHeader."Prepayment %";
                "Prepayment Tax Area Code" := PurchHeader."Tax Area Code";
                "Prepayment Tax Liable" := PurchHeader."Tax Liable";
                "Responsibility Center" := PurchHeader."Responsibility Center";

                "Requested Receipt Date" := PurchHeader."Requested Receipt Date";
                "Promised Receipt Date" := PurchHeader."Promised Receipt Date";
                "Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";
                "Order Date" := PurchHeader."Order Date";
                UpdateLeadTimeFields;
                UpdateDates;

                CASE Type OF
                    Type::" ":
                        BEGIN
                            StdTxt.GET("No.");
                            Description := StdTxt.Description;
                            "Allow Item Charge Assignment" := FALSE;
                        END;
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET("No.");
                            GLAcc.CheckGLAcc;
                            IF NOT "System-Created Entry" THEN
                                GLAcc.TESTFIELD("Direct Posting", TRUE);
                            Description := GLAcc.Name;
                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                            "Tax Group Code" := GLAcc."Tax Group Code";
                            "Allow Invoice Disc." := FALSE;
                            "Allow Item Charge Assignment" := FALSE;
                            InitDeferralCode;
                        END;
                    Type::Item:
                        BEGIN

                            GetItem_ktm(Item);
                            GetGLSetup_ktm();
                            Item.TESTFIELD(Blocked, FALSE);
                            Item.TESTFIELD("Gen. Prod. Posting Group");
                            IF Item.Type = Item.Type::Inventory THEN BEGIN
                                Item.TESTFIELD("Inventory Posting Group");
                                "Posting Group" := Item."Inventory Posting Group";
                            END;
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            "Unit Price (LCY)" := Item."Unit Price";
                            "Units per Parcel" := Item."Units per Parcel";
                            "Indirect Cost %" := Item."Indirect Cost %";
                            "Overhead Rate" := Item."Overhead Rate";
                            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                            "Tax Group Code" := Item."Tax Group Code";
                            Nonstock := Item."Created From Nonstock Item";
                            "Item Category Code" := Item."Item Category Code";
                            // "Product Group Code" := Item."Product Group Code";
                            "Allow Item Charge Assignment" := TRUE;

                            "RBI Product Code" := Item."RBI Product Code";   //KMT2016CU5
                                                                             //PrepmtMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");

                            IF Item."Price Includes VAT" THEN BEGIN
                                IF NOT VATPostingSetup.GET(
                                     Item."VAT Bus. Posting Gr. (Price)", Item."VAT Prod. Posting Group")
                                THEN
                                    VATPostingSetup.INIT;
                                CASE VATPostingSetup."VAT Calculation Type" OF
                                    VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                                        VATPostingSetup."VAT %" := 0;
                                    VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                                        ERROR(
                                          Text002,
                                          VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                                          VATPostingSetup."VAT Calculation Type");
                                END;
                                "Unit Price (LCY)" :=
                                  ROUND("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
                                    GLSetup."Unit-Amount Rounding Precision");
                            END;

                            IF PurchHeader."Language Code" <> '' THEN
                                GetItemTranslation;

                            "Unit of Measure Code" := Item."Purch. Unit of Measure";
                            InitDeferralCode;
                        END;
                    Type::"Resource":
                        ERROR('Text003');
                    Type::"Fixed Asset":
                        BEGIN
                            FA.GET("No.");
                            FA.TESTFIELD(Inactive, FALSE);
                            FA.TESTFIELD(Blocked, FALSE);
                            GetFAPostingGroup_ktm;       //local procudure
                            Description := FA.Description;
                            "Description 2" := FA."Description 2";
                            "Allow Invoice Disc." := FALSE;
                            "Allow Item Charge Assignment" := FALSE;
                        END;
                    Type::"Charge (Item)":
                        BEGIN
                            CheckVendorApplicableItemCharge; //SRT June 15th 2020
                            ItemCharge.GET("No.");
                            Description := ItemCharge.Description;
                            "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                            "Tax Group Code" := ItemCharge."Tax Group Code";
                            "Allow Invoice Disc." := FALSE;
                            "Allow Item Charge Assignment" := FALSE;
                            "Indirect Cost %" := 0;
                            "Overhead Rate" := 0;
                            "Exclude PP in VAT Book" := ItemCharge."Exclude PP in VAT Book"; //SRT Sept 3rd 2019

                        END;
                END;
                //KMT2016CU5 >>
                "Location Code" := PurchHeader."Location Code";
                "Letter of Credit/Telex Trans." := PurchHeader."Letter of Credit/Telex Trans.";
                PragyapanPatra := PurchHeader.PragyapanPatra; //VAT1.00
                "Party Type" := PurchHeader."Party Type";
                "Party No." := PurchHeader."Party No.";
                "Free Item Vendor No." := PurchHeader."Free Item Vendor No.";
                "Free Item Vendor Name" := PurchHeader."Free Item Vendor Name";
                //KMT2016CU5 <<
            end;
        }


        //Unsupported feature: Property Modification (Editable) on ""Amt. Rcd. Not Invoiced"(Field 59)".


        //Unsupported feature: Property Modification (Editable) on ""Pay-to Vendor No."(Field 68)".


        //Unsupported feature: Property Modification (Editable) on ""Amt. Rcd. Not Invoiced (LCY)"(Field 93)".

        modify("Prepayment Tax Area Code")
        {
            TableRelation = "Transaction Specification";
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                "Location Code" := 'DHUMBARAHI';   //KMT2016CU5
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    UpdateDirectUnitCost(FIELDNO(Quantity))
                END;
                SingleQtyRestriction; //KMT2016CU5
                ClearTDSFields;
                "TDS Group" := '';
            end;
        }

        modify("Qty. to Invoice")
        {
            trigger OnAfterValidate()
            begin
                ClearTDSFields;
                "TDS Group" := '';
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Line Discount %");
                ClearTDSFields;
                "TDS Group" := '';
            end;
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50003; "TDS Group"; Code[20])
        {
            Description = 'TDS1.00';
            TableRelation = "TDS Posting Group".Code WHERE(Type = FILTER("Purchase TDS"),
                                                            Blocked = CONST(false));

            trigger OnValidate()
            var
                ItemCharge: Record "Item Charge";
                MistakeTDSGrpErr: Label '%1 %2 is not applicable for item charge %3.';
                TDSPostingGroup: Record "TDS Posting Group";
            begin
                // TDS1.00 >>
                ClearTDSFields();
                TDSPostingGroup.RESET;
                TDSPostingGroup.SETRANGE(Code, "TDS Group");
                IF TDSPostingGroup.FINDFIRST THEN BEGIN
                    TDSPostingGroup.TESTFIELD("TDS%");
                    TDSPostingGroup.TESTFIELD("GL Account No.");
                    "TDS Type" := "TDS Type"::"Purchase TDS";
                    "TDS%" := TDSPostingGroup."TDS%";
                    CalculateTDS;
                END;
                // TDS1.00 <<

                //ASPL Dec 24th 2020 >>
                IF (Type = Type::"Charge (Item)") AND ("TDS Group" <> '') THEN BEGIN
                    ItemCharge.GET("No.");
                    ItemCharge.TESTFIELD("Applicable TDS Posting Groups");
                    IF ItemCharge."Applicable TDS Posting Groups" <> '' THEN BEGIN
                        IF STRPOS(ItemCharge."Applicable TDS Posting Groups", "TDS Group") = 0 THEN
                            ERROR(MistakeTDSGrpErr, FIELDCAPTION("TDS Group"), "TDS Group", "No.");
                    END;
                END;
                //ASPL Dec 24th 2020 <<
            end;
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
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
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

            trigger OnValidate()
            begin
                "Party No." := '';  //KMT2016CU5
            end;
        }
        field(50508; "Party No."; Code[100])
        {
            TableRelation = IF ("Party Type" = CONST(Employee)) "Dimension Value".Code WHERE("Dimension Code" = filter('Employee'))
            ELSE
            IF ("Party Type" = CONST(Branch)) "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'))
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
        field(50600; "VAT Base 1"; Decimal)
        {
            Caption = 'VAT Base Amt 13 %';
            Description = 'VAT Base Amt 13%';

            trigger OnValidate()
            var
                PurchHeader: Record "Purchase Header";
            begin
                //KMT2016CU5 >>
                IF (Type = Type::"G/L Account") AND ("No." = '2262200') THEN BEGIN
                    PurchHeader.RESET;
                    PurchHeader.SETRANGE("No.", "Document No.");
                    IF PurchHeader.FINDFIRST THEN BEGIN
                        PurchHeader."VAT Base 1" := "VAT Base 1";
                        PurchHeader.MODIFY;
                    END;
                END;
                //KMT2016CU5 <<
            end;
        }
        field(50601; "Exempt Amount"; Decimal)
        {
            Caption = 'Vat Base Amt 0%';
            Description = 'VAT Base Amt 0%';

            trigger OnValidate()
            begin
                //KMT2016CU5 >>
                IF (Type = Type::"G/L Account") AND ("No." = '2262200') THEN BEGIN
                    PurchHeader.RESET;
                    PurchHeader.SETRANGE("No.", "Document No.");
                    IF PurchHeader.FINDFIRST THEN BEGIN
                        PurchHeader."Exempt Amount" := "Exempt Amount";
                        PurchHeader.MODIFY;
                    END;
                END;
                //KMT2016CU5 <<
            end;
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

            trigger OnValidate()
            begin
                SingleQtyRestriction; //KMT2016CU5
            end;
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

    }


    //Unsupported feature: Code Modification on "UpdateItemChargeAssgnt(PROCEDURE 5807)".

    //procedure UpdateItemChargeAssgnt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Document Type" = "Document Type"::"Blanket Order" THEN
      EXIT;

    #4..44
          TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
          TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
        END;
        ItemChargeAssgntPurch.MODIFY;
      UNTIL ItemChargeAssgntPurch.NEXT = 0;
      CALCFIELDS("Qty. to Assign");
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin                                            //There is no event called for this funtion 
    /*
    #1..47
        {//KMT2016CU5 >>
        ItemChargeAssgntPurch.PragyapanPatra := PragyapanPatra;
        ItemChargeAssgntPurch."Letter of Credit/Telex Trans." := "Letter of Credit/Telex Trans.";
        //KMT2016CU5 <<}
    #48..51
    */
    //end;

    local procedure SingleQtyRestriction()
    begin
        IF Type = Type::"Fixed Asset" THEN BEGIN
            IF (Quantity > 1) AND ("FA Item Charge" <> '') THEN
                ERROR(Text055, "Line No.");
        END;
    end;

    local procedure "--KMT2016CU5--"()
    begin
    end;

    procedure GetGLSetup_ktm()
    var
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
    begin
        if not GLSetupRead then
            GLSetup.Get();
        GLSetupRead := true;
    end;

    procedure GetItem_ktm(var Item: Record Item)
    begin
        TestField("No.");
        Item.Get("No.");
    end;

    procedure GetFAPostingGroup_ktm()
    var
        LocalGLAcc: Record "G/L Account";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";

        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeGetFAPostingGroup(Rec, IsHandled);
        if IsHandled then
            exit;

        if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;
        // if "Depreciation Book Code" = '' then
        //     if not FindDefaultFADeprBook() then
        //         exit;

        if "FA Posting Type" = "FA Posting Type"::" " then
            "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
        FADeprBook.Get("No.", "Depreciation Book Code");
        FADeprBook.TestField("FA Posting Group");
        FAPostingGr.GetPostingGroup(FADeprBook."FA Posting Group", FADeprBook."Depreciation Book Code");
        case "FA Posting Type" of
            "FA Posting Type"::"Acquisition Cost":
                LocalGLAcc.Get(FAPostingGr.GetAcquisitionCostAccount);
            "FA Posting Type"::Appreciation:
                LocalGLAcc.Get(FAPostingGr.GetAppreciationAccount);
            "FA Posting Type"::Maintenance:
                LocalGLAcc.Get(FAPostingGr.GetMaintenanceExpenseAccount);
        end;
        LocalGLAcc.CheckGLAcc;
        if not ApplicationAreaMgmt.IsSalesTaxEnabled then
            LocalGLAcc.TestField("Gen. Prod. Posting Group");
        "Posting Group" := FADeprBook."FA Posting Group";
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        Validate("VAT Prod. Posting Group", LocalGLAcc."VAT Prod. Posting Group");
    end;

    local procedure ClearTDSFields()
    begin
        //TDS1.00
        "TDS%" := 0;
        "TDS Type" := "TDS Type"::" ";
        "TDS Amount" := 0;
        "TDS Base Amount" := 0;
        //TDS1.00
    end;

    procedure CalculateTDS()
    var
        TDSPostingGroup: Record "TDS Posting Group";
        PurchaseLine: Record "Purchase line";
        Currency: Record "Currency";
    begin
        // TDS1.00 >>
        Currency.InitRoundingPrecision;
        GetPurchHeader;
        IF PurchHeader."Prices Including VAT" THEN
            "TDS Base Amount" := ("Direct Unit Cost" - ("Direct Unit Cost" * "VAT %" / 100)) * "Qty. to Invoice"
        ELSE
            "TDS Base Amount" := "Direct Unit Cost" * "Qty. to Invoice";
        "TDS Amount" := ROUND("TDS Base Amount" * "TDS%" / 100, Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
        "TDS Type" := "TDS Type"::"Purchase TDS";
        MODIFY;
        // TDS1.00 <<
    end;

    procedure CheckVendorApplicableItemCharge()
    var
        ItemCharge: Record "Item Charge";
    begin
        IF Type <> Type::"Charge (Item)" THEN
            EXIT;
        ItemCharge.GET("No.");
        GetPurchHeader;
        VendorRec.GET("Pay-to Vendor No.");
        IF VendorRec."Applicable Item Charges" <> '' THEN BEGIN
            IF STRPOS(VendorRec."Applicable Item Charges", "No.") = 0 THEN
                PurchHeader.TESTFIELD("Pay-to Vendor No.", VendorRec."Applicable Item Charges");
        END;
        /*
        IF ItemCharge."Default Vendor No." <> '' THEN BEGIN
          IF STRPOS(ItemCharge."Default Vendor No.",PurchHeader."Buy-from Vendor No.") = 0 THEN
            PurchHeader.TESTFIELD("Buy-from Vendor No.",ItemCharge."Default Vendor No.");
        END;
        */

    end;

    var
        VendorRec: Record Vendor;
        Text055: Label 'Quantity must be 1 in Line No. %1 if the FA Item Charge is not blank.';
        "--KMT2016CU5---": Integer;
        TDSPostingGroup: Record "TDS Posting Group";
        IsServiceItem: Boolean;
        StdTxt: Record "Standard Text";
        Item: Record Item;
        FA: Record "Fixed Asset";
        PurchHeader: Record "Purchase Header";
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt.";
        GLAcc: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        Text002: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        ItemCharge: Record "Item Charge";
        Text003: Label 'You cannot purchase resources.';

}

