tableextension 50450 "Sales Line_ktm" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                CalChange: Record "Customized Calendar Change";
                CalendarMgmt: Codeunit "Calendar Management";

            begin
                // "Shipment Date" :=
                // CalendarMgmt.CalcDateBOC(
                //   '',
                //    SalesHeader."Shipment Date",
                //    CalChange."Source Type"::Location,
                //    "Location Code",
                //    '',
                //    CalChange."Source Type"::"Shipping Agent",
                //    "Shipping Agent Code",
                //    "Shipping Agent Service Code",
                //    FALSE);

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
                            InitDeferralCode_ktm;
                        END;

                    Type::Item:
                        BEGIN
                            GetItem(Item);
                            Item.TESTFIELD(Blocked, FALSE);
                            Item.TESTFIELD("Gen. Prod. Posting Group");
                            IF Item.Type = Item.Type::Inventory THEN BEGIN
                                Item.TESTFIELD("Inventory Posting Group");
                                "Posting Group" := Item."Inventory Posting Group";
                            END;
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            GetUnitCost;
                            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
                            "Units per Parcel" := Item."Units per Parcel";
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                            "Tax Group Code" := Item."Tax Group Code";
                            "Item Category Code" := Item."Item Category Code";
                            //"Product Group Code" := Item."Product Group Code";
                            Nonstock := Item."Created From Nonstock Item";
                            "Profit %" := Item."Profit %";
                            "Allow Item Charge Assignment" := TRUE;
                            "RBI Product Code" := Item."RBI Product Code";   //KMT2016CU5
                                                                             //PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");

                            IF SalesHeader."Language Code" <> '' THEN
                                GetItemTranslation;

                            IF Item.Reserve = Item.Reserve::Optional THEN
                                Reserve := SalesHeader.Reserve
                            ELSE
                                Reserve := Item.Reserve;

                            "Unit of Measure Code" := Item."Sales Unit of Measure";
                            InitDeferralCode_ktm;
                            //KMT2016CU5 >>
                            SalesSetup.GET;
                            IF NOT SalesSetup."Skip Product Group Check" THEN BEGIN
                                SalesHeader.RESET;
                                SalesHeader.SETRANGE("No.", "Document No.");
                                IF SalesHeader.FINDFIRST THEN BEGIN
                                    Item.SETRANGE("No.", "No.");
                                    IF Item.FINDFIRST THEN BEGIN
                                        IF Item."Inventory Posting Group" <> SalesHeader."Inventory Posting Group" THEN
                                            ERROR('You must select the item based on product segment %1 selected in the header.', SalesHeader."Inventory Posting Group");
                                    END;
                                END;
                            END;
                            //KMT2016CU5 <<
                        END;
                    Type::Resource:
                        BEGIN
                            Res.GET("No.");
                            Res.TESTFIELD(Blocked, FALSE);
                            Res.TESTFIELD("Gen. Prod. Posting Group");
                            Description := Res.Name;
                            "Description 2" := Res."Name 2";
                            "Unit of Measure Code" := Res."Base Unit of Measure";
                            "Unit Cost (LCY)" := Res."Unit Cost";
                            "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                            "Tax Group Code" := Res."Tax Group Code";
                            "Allow Item Charge Assignment" := FALSE;
                            FindResUnitCost;
                            InitDeferralCode_ktm();
                            ;
                        END;
                    Type::"Fixed Asset":
                        BEGIN
                            FA.GET("No.");
                            FA.TESTFIELD(Inactive, FALSE);
                            FA.TESTFIELD(Blocked, FALSE);
                            GetFAPostingGroup_ktm;
                            Description := FA.Description;
                            "Description 2" := FA."Description 2";
                            "Allow Invoice Disc." := FALSE;
                            "Allow Item Charge Assignment" := FALSE;
                        END;
                    Type::"Charge (Item)":
                        BEGIN
                            ItemCharge.GET("No.");
                            Description := ItemCharge.Description;
                            "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                            "Tax Group Code" := ItemCharge."Tax Group Code";
                            "Allow Invoice Disc." := FALSE;
                            "Allow Item Charge Assignment" := FALSE;
                        END;
                end;
                IF "Document Type" = "Document Type"::Invoice THEN begin
                    "Location Code" := 'DHUMBARAHI';  //KMT2016CU5
                    UpdateItemCrossRef;
                end;
            end;
        }
        modify("Prepayment Tax Area Code")
        {
            TableRelation = "Transaction Specification";
        }


        modify("VAT Prod. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                IRDMgt.GetCustomVATPostingSetupOnSalesLine(Rec, xRec, FIELDNO("VAT Prod. Posting Group"));
            end;
        }
        modify("Return Reason Code")
        {
            trigger OnAfterValidate()
            begin
                ValidateReturnReasonCode(FIELDNO("Return Reason Code"));
                //KMT2016CU5 >>
                SalesHeader.RESET;
                SalesHeader.SETRANGE("No.", "Document No.");
                IF SalesHeader.FINDFIRST THEN BEGIN
                    SalesHeader."Reason Code" := "Return Reason Code";
                    SalesHeader.MODIFY;
                end;
            end;
        }

        field(50501; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(50502; "Returned Document No."; Code[20])
        {
        }
        field(50503; "Returned Document Line No."; Integer)
        {
        }
        field(50602; "RBI Product Code"; Code[10])
        {
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
        field(70005; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(70007; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(70008; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(70009; "TDS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(70010; "TDS Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70011; "TDS%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "GetItem(PROCEDURE 9)".

    //procedure GetItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD("No.");
    Item.GET("No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TESTFIELD("No.");
    IF "No." <> Item."No." THEN
    Item.GET("No.");
    */
    //end;

    var
        SalesHeader: Record "Sales Header";


    //Unsupported feature: Property Modification (Id) on "LineAmountInvalidErr(Variable 1089)".

    //var
    //>>>> ORIGINAL VALUE:
    //LineAmountInvalidErr : 1089;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //LineAmountInvalidErr : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "LineInvoiceDiscountAmountResetTok(Variable 1096)".

    //var
    //>>>> ORIGINAL VALUE:
    //LineInvoiceDiscountAmountResetTok : 1096;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //LineInvoiceDiscountAmountResetTok : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UnitPriceChangedMsg(Variable 1091)".

    //var
    //>>>> ORIGINAL VALUE:
    //UnitPriceChangedMsg : 1091;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UnitPriceChangedMsg : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CannotAllowInvDiscountErr(Variable 1049)".

    //var
    //>>>> ORIGINAL VALUE:
    //CannotAllowInvDiscountErr : 1049;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CannotAllowInvDiscountErr : 1995;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CannotChangeVATGroupWithPrepmInvErr(Variable 1069)".

    //var
    //>>>> ORIGINAL VALUE:
    //CannotChangeVATGroupWithPrepmInvErr : 1069;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CannotChangeVATGroupWithPrepmInvErr : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CannotChangePrepmtAmtDiffVAtPctErr(Variable 1095)".

    //var
    //>>>> ORIGINAL VALUE:
    //CannotChangePrepmtAmtDiffVAtPctErr : 1095;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CannotChangePrepmtAmtDiffVAtPctErr : 1997;
    //Variable type has not been exported.
    procedure GetFAPostingGroup_ktm()
    var
        LocalGLAcc: Record "G/L Account";
        FASetup: Record "FA Setup";
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
        ShouldExit: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeGetFAPostingGroup(Rec, IsHandled);
        if IsHandled then
            exit;

        if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;

        if "Depreciation Book Code" = '' then begin
            FASetup.Get();
            "Depreciation Book Code" := FASetup."Default Depr. Book";
            if not FADeprBook.Get("No.", "Depreciation Book Code") then
                "Depreciation Book Code" := '';

            ShouldExit := "Depreciation Book Code" = '';
            //OnGetGetFAPostingGroupOnBeforeExit(Rec, ShouldExit);
            if ShouldExit then
                exit;
        end;

        FADeprBook.Get("No.", "Depreciation Book Code");
        FADeprBook.TestField("FA Posting Group");
        FAPostingGr.GetPostingGroup(FADeprBook."FA Posting Group", FADeprBook."Depreciation Book Code");
        LocalGLAcc.Get(FAPostingGr.GetAcquisitionCostAccountOnDisposal);
        LocalGLAcc.CheckGLAcc();
        if not ApplicationAreaMgmt.IsSalesTaxEnabled then
            LocalGLAcc.TestField("Gen. Prod. Posting Group");
        "Posting Group" := FADeprBook."FA Posting Group";
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        Validate("VAT Prod. Posting Group", LocalGLAcc."VAT Prod. Posting Group");

        //OnAfterGetFAPostingGroup(Rec, LocalGLAcc);
    end;

    procedure InitDeferralCode_ktm()
    var
        Item: Record Item;
    begin
        if "Document Type" in
           ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::"Credit Memo", "Document Type"::"Return Order"]
        then
            case Type of
                Type::"G/L Account":
                    Validate("Deferral Code", GLAcc."Default Deferral Template Code");
                Type::Item:
                    begin
                        GetItem(Item);
                        Validate("Deferral Code", Item."Default Deferral Template Code");
                    end;
                Type::Resource:
                    Validate("Deferral Code", Res."Default Deferral Template Code");
            end;
    end;

    procedure UpdateItemCrossRef()
    begin
        DistIntegration.EnterSalesItemCrossRef(Rec);
        UpdateICPartner;
    end;

    var

        DeferralPostDate: Date;
        IRDMgt: Codeunit "IRD Mgt.";
        StdTxt: Record "Standard Text";
        Item: Record Item;
        FA: Record "Fixed Asset";
        GLAcc: Record "G/L Account";
        Res: Record Resource;
        SalesSetup: Record "Sales & Receivables Setup";
        ItemCharge: Record "Item Charge";
        DistIntegration: Codeunit "Dist. Integration";
        ApplicationAreaMgmt: codeunit "Application Area Mgmt.";



}

