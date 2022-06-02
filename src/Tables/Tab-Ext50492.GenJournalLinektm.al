tableextension 50492 "Gen. Journal Line_ktm" extends "Gen. Journal Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Bill-to/Pay-to No."(Field 22)".


        //Unsupported feature: Property Modification (Data type) on ""Posting Group"(Field 23)".

        modify("External Document No.")
        {
            Caption = 'Cheque/Bill No.';
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            "Account Name" := GLAcc.Name;    //KMT2016CU5
                            "Main G/L Account" := "Account No."; //KMT2016CU5
                        end;
                    "Account Type"::Customer:
                        begin
                            "Account Name" := Cust.Name;
                        end;
                    "Account Type"::Vendor:
                        begin
                            "Account Name" := Vend.Name;    //KMT2016CU5
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            "Account Name" := BankAcc.Name;    //KMT2016CU5
                        end;
                    "Account Type"::"Fixed Asset":
                        begin
                            "Account Name" := FA.Description;
                        end;
                    "Account Type"::"IC Partner":
                        begin
                            "Account Name" := ICPartner.Name;    //KMT2016CU5
                        end;

                end;
            end;
        }

        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                ValidateAmount_ktm;
                GetCurrency;
                IF "Currency Code" = '' THEN BEGIN
                    "Amount (LCY)" := Amount;
                    //KMT2016CU5 >>     this code is used to pass the sales/purch lcy for debit note or credit note to ledger entries
                    IF ("Source Code" = 'SALESJNL') OR ("Source Code" = 'PURCHJNL') THEN BEGIN
                        IF ("Account Type" = "Account Type"::Customer) OR ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                            genjnlline1.RESET;
                            genjnlline1.SETRANGE("Journal Template Name", "Journal Template Name");
                            genjnlline1.SETRANGE("Journal Batch Name", "Journal Batch Name");
                            genjnlline1.SETRANGE("Document No.", "Document No.");
                            genjnlline1.SETRANGE("Account Type", "Account Type"::"G/L Account");
                            IF genjnlline1.FINDFIRST THEN BEGIN
                                GLAcc1.RESET;
                                GLAcc1.SETRANGE("No.", genjnlline1."Account No.");
                                IF GLAcc1.FINDFIRST THEN BEGIN
                                    IF GLAcc1."To Sales/Purch. (LCY)" THEN
                                        "Sales/Purch. (LCY)" := Amount + genjnlline1."VAT Amount"
                                    ELSE
                                        "Sales/Purch. (LCY)" := 0;
                                END;
                                IF genjnlline1."Party No." <> '' THEN BEGIN
                                    IF "Account No." <> genjnlline1."Party No." THEN
                                        ERROR(Text095);
                                END;
                            END;
                        END;
                        IF "Skip Document Type" THEN
                            //"Document Type" := "Document Type"::" ";
                            VALIDATE("Sales/Purch. (LCY)", 0);
                    END;
                    //KMT2016CU5 <<
                END ELSE
                    "Amount (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code",
                          Amount, "Currency Factor"));

                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                IF (CurrFieldNo <> 0) AND
                   (CurrFieldNo <> FIELDNO("Applies-to Doc. No.")) AND
                   ((("Account Type" = "Account Type"::Customer) AND
                     ("Account No." <> '') AND (Amount > 0) AND
                     (CurrFieldNo <> FIELDNO("Bal. Account No."))) OR
                    (("Bal. Account Type" = "Bal. Account Type"::Customer) AND
                     ("Bal. Account No." <> '') AND (Amount < 0) AND
                     (CurrFieldNo <> FIELDNO("Account No."))))
                THEN
                    CustCheckCreditLimit.GenJnlLineCheck(Rec);

                VALIDATE("VAT %");
                VALIDATE("Bal. VAT %");
                UpdateLineBalance;
                IF "Deferral Code" <> '' THEN
                    VALIDATE("Deferral Code");

                IF Amount <> xRec.Amount THEN BEGIN
                    IF ("Applies-to Doc. No." <> '') OR ("Applies-to ID" <> '') THEN
                        SetApplyToAmount;
                    PaymentToleranceMgt.PmtTolGenJnl(Rec);
                END;

                IF JobTaskIsSet THEN BEGIN
                    CreateTempJobJnlLine;
                    UpdatePricesFromJobJnlLine;
                END;
                CalculateTDSAmount; //TDS1.00

            end;
            //end;
        }
        modify("Amount (LCY)")
        {
            trigger OnAfterValidate()
            begin
                //KMT2016CU5 >>     this code is used to pass the sales/purch lcy for debit note or credit note to ledger entries
                IF ("Source Code" = 'SALESJNL') OR ("Source Code" = 'PURCHJNL') THEN BEGIN
                    IF ("Account Type" = "Account Type"::Customer) OR ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                        genjnlline1.RESET;
                        genjnlline1.SETRANGE("Journal Template Name", "Journal Template Name");
                        genjnlline1.SETRANGE("Journal Batch Name", "Journal Batch Name");
                        genjnlline1.SETRANGE("Document No.", "Document No.");
                        genjnlline1.SETRANGE("Account Type", "Account Type"::"G/L Account");
                        IF genjnlline1.FINDFIRST THEN BEGIN
                            GLAcc1.RESET;
                            GLAcc1.SETRANGE("No.", genjnlline1."Account No.");
                            IF GLAcc1.FINDFIRST THEN BEGIN
                                IF GLAcc1."To Sales/Purch. (LCY)" THEN
                                    "Sales/Purch. (LCY)" := "Amount (LCY)" + genjnlline1."VAT Amount"
                                ELSE
                                    "Sales/Purch. (LCY)" := 0;
                            END;
                            IF genjnlline1."Party No." <> '' THEN BEGIN
                                IF "Account No." <> genjnlline1."Party No." THEN
                                    ERROR(Text095);
                            END;
                        END;
                    END;
                    IF "Skip Document Type" THEN
                        "Document Type" := "Document Type"::" ";
                END;
                //KMT2016CU5 <<
            end;
        }

        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                //KMT2016CU5 >>
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    SalesPersonPosting.SETRANGE("Customer No.", "Account No.");
                    IF SalesPersonPosting.FINDSET THEN BEGIN
                        SalesPersonPosting.SETRANGE("Product Segment Code", "Shortcut Dimension 1 Code");
                        IF SalesPersonPosting.FINDFIRST THEN BEGIN
                            VALIDATE("Shortcut Dimension 2 Code", SalesPersonPosting."Area Code");
                            "Salespers./Purch. Code" := SalesPersonPosting."Area Code";
                        END;
                    END;
                END;
            end;
        }
        modify("Shortcut Dimension 2 Code")
        {
            trigger OnAfterValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                "Salespers./Purch. Code" := "Shortcut Dimension 2 Code";
            end;
        }
        modify("VAT Amount")
        {
            trigger OnAfterValidate()
            begin
                CalculateTDSAmount;
            end;
        }

        modify("VAT Prod. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                CalculateTDSAmount; //TDS1.00
                                    //let the subcirber work (bug in 2016 nav, does not work unitl there is a commnet on the code)
            end;
        }

        field(50000; "Skip Document Type"; Boolean)
        {
            Caption = 'Skip Document Type';

            trigger OnValidate()
            var
                GenJnlLine: Record "Gen. Journal Line";
            begin
                //KMT2016CU5 >>
                IF "Skip Document Type" THEN BEGIN
                    IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor] THEN BEGIN
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                        GenJnlLine.SETRANGE("Document No.", "Document No.");
                        GenJnlLine.SETFILTER("VAT Prod. Posting Group", '<>%1', '');
                        IF GenJnlLine.FINDFIRST THEN
                            ERROR('The entry is related to vat book. Unable to skip.')
                        ELSE
                            VALIDATE("Document Type", "Document Type"::" ");
                    END;
                END ELSE BEGIN
                    IF "Document Type" = "Document Type"::" " THEN
                        VALIDATE("Document Type", "Document Type"::"Credit Memo");
                    UpdateSalesPurchLCY;
                END;
                //KMT2016CU5 <<
            end;
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50004; "Purchase Consignment No."; Code[20])
        {
        }
        field(50005; "TDS Group"; Code[20])
        {
            Description = 'TDS1.00';
            TableRelation = "TDS Posting Group".Code WHERE(Blocked = CONST(false));

            trigger OnValidate()
            begin
                CalculateTDSAmount; //TDS1.00
            end;
        }
        field(50006; "TDS%"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50007; "TDS Type"; Option)
        {
            Description = 'TDS1.00';
            Editable = false;
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(50008; "TDS Amount"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50009; "TDS Base Amount"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
        }
        field(50010; "TDS Entry No."; Integer)
        {
            Description = 'TDS1.00';
        }
        field(50011; "Main G/L Account"; Code[20])
        {
            Description = 'TDS1.00';
        }
        field(50501; Narration; Text[250])
        {
        }
        field(50502; PragyapanPatra; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(PragyapanPatra),
                                                                            Blocked = CONST(false));
        }
        field(50503; "Localized VAT Identifier"; Option)
        {
            Editable = true;
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50505; "Party Name"; Text[250])
        {
            Editable = false;
        }
        field(50506; "Letter of Credit/Telex Trans."; Code[100])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = FILTER("Letter of Credit/Telex Transfer" | "Demand loan"));
        }
        field(50507; "Party Type"; Option)
        {
            OptionCaption = ' ,Employee,Branch,Vendor,Customer,Party';
            OptionMembers = " ",Employee,Branch,Vendor,Customer,Party;

            trigger OnValidate()
            begin
                //KMT2016CU5 >>
                "Party No." := '';
                "Party Name" := '';
                //KMT2016CU5 <<
            end;
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

            trigger OnValidate()
            begin
                //KMT2016CU5 >>
                IF "Party Type" = "Party Type"::Vendor THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", "Party No.");
                    IF Vendor.FINDFIRST THEN
                        "VAT Registration No." := Vendor."VAT Registration No.";
                END;
                IF "Party Type" = "Party Type"::Customer THEN BEGIN
                    Customer.RESET;
                    Customer.SETRANGE("No.", "Party No.");
                    IF Customer.FINDFIRST THEN
                        "VAT Registration No." := Customer."VAT Registration No.";
                END;
                //KMT2016CU5 <<
            end;
        }
        field(50509; "Nepali Date"; Code[10])
        {
            CalcFormula = Lookup("English-Nepali Date"."Nepali Date" WHERE("English Date" = FIELD("Posting Date")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50510; "T/R"; Code[100])
        {
            Caption = 'T/R';
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
        field(50606; "VAT. Registration No."; Code[30])
        {
        }
        field(50607; "FA Item Charge"; Code[20])
        {
            TableRelation = "Item Charge";
        }
        field(50608; "demand loan"; Code[30])
        {
            TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("Demand loan"));
        }
    }


    //Unsupported feature: Code Modification on "SetUpNewLine(PROCEDURE 9)".

    //procedure SetUpNewLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GenJnlTemplate.GET("Journal Template Name");
    GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
    GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
    #4..8
      OnSetUpNewLineOnBeforeIncrDocNo(GenJnlLine,LastGenJnlLine);
      IF BottomLine AND
         (Balance - LastGenJnlLine."Balance (LCY)" = 0) AND
         NOT LastGenJnlLine.EmptyLine
      THEN
        IncrementDocumentNo(GenJnlBatch,"Document No.");
    #15..48
    UpdateJournalBatchID;

    OnAfterSetupNewLine(Rec,GenJnlTemplate,GenJnlBatch,LastGenJnlLine,Balance,BottomLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
         //(Balance - (LastGenJnlLine."Balance (LCY)" - LastGenJnlLine."TDS Amount") = 0) AND //TDS1.00       //only this line modified
    #12..51
    */
    //end;


    //Unsupported feature: Variable Insertion (Variable: SourceCodeSetup) (VariableCollection) on "UpdateSalesPurchLCY(PROCEDURE 19)".


    //Unsupported feature: Variable Insertion (Variable: GenJnlLine1) (VariableCollection) on "UpdateSalesPurchLCY(PROCEDURE 19)".


    //Unsupported feature: Variable Insertion (Variable: ToSalesPurchLCY) (VariableCollection) on "UpdateSalesPurchLCY(PROCEDURE 19)".



    //Unsupported feature: Code Modification on "UpdateSalesPurchLCY(PROCEDURE 19)".
    procedure ValidateAmount_ktm()
    var
        IsHandled: Boolean;
    begin
        GetCurrency;
        if "Currency Code" = '' then
            "Amount (LCY)" := Amount
        else
            "Amount (LCY)" := Round(
                CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", Amount, "Currency Factor"));
        //OnValidateAmountOnAfterAssignAmountLCY("Amount (LCY)");

        Amount := Round(Amount, Currency."Amount Rounding Precision");

        IsHandled := false;
        // OnValidateAmountOnBeforeCheckCreditLimit(Rec, CurrFieldNo, CustCheckCreditLimit, IsHandled);
        if not IsHandled then
            if (CurrFieldNo <> 0) and
            (CurrFieldNo <> FieldNo("Applies-to Doc. No.")) and
            ((("Account Type" = "Account Type"::Customer) and
                ("Account No." <> '') and (Amount > 0) and
                (CurrFieldNo <> FieldNo("Bal. Account No."))) or
                (("Bal. Account Type" = "Bal. Account Type"::Customer) and
                ("Bal. Account No." <> '') and (Amount < 0) and
                (CurrFieldNo <> FieldNo("Account No."))))
            then
                CustCheckCreditLimit.GenJnlLineCheck(Rec);

        Validate("VAT %");
        Validate("Bal. VAT %");
        UpdateLineBalance;
        if "Deferral Code" <> '' then
            Validate("Deferral Code");

        //UpdateApplyToAmount();

        if JobTaskIsSet then begin
            CreateTempJobJnlLine();
            UpdatePricesFromJobJnlLine();
        end;

        // OnAfterValidateAmount(Rec);
    end;


    procedure CheckDirectPosting_ktm(var GLAccount: Record "G/L Account")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeCheckDirectPosting(GLAccount, IsHandled, Rec);
        if IsHandled then
            exit;

        GLAccount.TestField("Direct Posting", true);

        //OnAfterCheckDirectPosting(GLAccount, Rec);
    end;


    procedure SetSalespersonPurchaserCode_ktm(SalesperPurchCodeToCheck: Code[20]; var SalesperPuchCodeToAssign: Code[20])
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if SalesperPurchCodeToCheck <> '' then
            if SalespersonPurchaser.Get(SalesperPurchCodeToCheck) then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    SalesperPuchCodeToAssign := ''
                else
                    SalesperPuchCodeToAssign := SalesperPurchCodeToCheck;
    end;


    procedure UpdateSalesPurchLCY();
    begin
        SourceCodeSetup.GET; //KMT2016CU5
        IF ("Source Code" = SourceCodeSetup."Purchase Journal") OR ("Source Code" = SourceCodeSetup."Sales Journal") THEN BEGIN
            IF "Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor] THEN BEGIN
                //update based on g/l account selected in previous line
                GenJnlLine1.RESET;
                GenJnlLine1.SETRANGE("Journal Template Name", "Journal Template Name");
                GenJnlLine1.SETRANGE("Journal Batch Name", "Journal Batch Name");
                GenJnlLine1.SETRANGE("Document No.", "Document No.");
                GenJnlLine1.SETRANGE("Account Type", "Account Type"::"G/L Account");
                IF GenJnlLine1.FINDFIRST THEN BEGIN
                    GLAcc1.GET(GenJnlLine1."Account No.");
                    IF GLAcc1."To Sales/Purch. (LCY)" THEN
                        "Sales/Purch. (LCY)" := Amount + GenJnlLine1."VAT Amount"
                    ELSE
                        "Sales/Purch. (LCY)" := 0;
                    IF (GenJnlLine1."Party No." <> '') AND ("Account No." <> '') THEN BEGIN
                        IF "Account No." <> GenJnlLine1."Party No." THEN
                            ERROR(Text095);
                    END;
                END;
            END ELSE
                IF ("Account Type" = "Account Type"::"G/L Account") AND ("VAT Prod. Posting Group" <> '') THEN BEGIN
                    //update in customer,vendor line
                    GenJnlLine1.RESET;
                    GenJnlLine1.SETRANGE("Journal Template Name", "Journal Template Name");
                    GenJnlLine1.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    GenJnlLine1.SETRANGE("Document No.", "Document No.");
                    GenJnlLine1.SETFILTER("Account Type", '<>%1', "Account Type");
                    IF GenJnlLine1.FINDFIRST THEN BEGIN
                        GLAcc.GET("Account No.");
                        IF GLAcc."To Sales/Purch. (LCY)" THEN BEGIN
                            GenJnlLine1."Sales/Purch. (LCY)" := GenJnlLine1.Amount + "VAT Amount";
                            GenJnlLine1.MODIFY;
                        END;
                    END;
                END;
        End;
    end;

    local procedure "--KMT2016Cu5---"()
    begin
    end;

    local procedure CalculateTDSAmount()
    var
        AmountNegativeOrZero: Label 'Amount is Negative or Zero. Do you want to Reverse Purchase TDS Entries?';
        TDSTypeBlank: Label 'TDS Type of %1 cannot be Blank in TDS Posting Group.';
        AmountPositiveOrZero: Label 'Amount is Positive or Zero. Do you want to Reverse Sale TDS Entries?';
    begin
        //TDS1.00
        //for Purchase TDS
        //MESSAGE('findtdstype-->'+FORMAT(FindTDSType));
        IF "TDS Group" <> '' THEN BEGIN
            IF (FindTDSType = 1) AND (Amount >= 0) THEN
                CalculateTDSAmount2
            ELSE
                IF (FindTDSType = 1) AND (Amount < 0) THEN //amount less than zero in case of manual reverse
                BEGIN
                    IF NOT CONFIRM(AmountNegativeOrZero, FALSE) THEN
                        EXIT;
                    CalculateTDSAmount2;
                END;

            //for blank
            IF (FindTDSType = 0) THEN
                ERROR(TDSTypeBlank, "TDS Group");

            //for Sales TDS
            IF (FindTDSType = 2) AND (Amount <= 0) THEN
                CalculateTDSAmount2
            ELSE
                IF (FindTDSType = 2) AND (Amount > 0) THEN //amount greater than zero in case of manual reverse
                BEGIN
                    IF NOT CONFIRM(AmountPositiveOrZero, FALSE) THEN
                        EXIT;
                    CalculateTDSAmount2;
                END;
        END
        ELSE
            ClearTDSFields;
        //TDS1.00
    end;

    local procedure CalculateTDSAmount2()
    var
        AmountNegativeOrZero: Label 'Amount in Negative or Zero. Do you want to Reverse TDS Entries?';
        TDSSetup2: Record "TDS Posting Group";
    begin
        //TDS1.00
        GetCurrency;

        ClearTDSFields;
        TDSSetup2.RESET;
        TDSSetup2.SETRANGE(Code, "TDS Group");
        IF TDSSetup2.FINDFIRST THEN BEGIN
            "TDS%" := TDSSetup2."TDS%";
            "TDS Type" := TDSSetup2.Type;
            "TDS Base Amount" := "VAT Base Amount";
            "TDS Amount" := ROUND(TDSSetup2."TDS%" / 100 * "VAT Base Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
        END;
        //TDS1.00
    end;

    local procedure ClearTDSFields()
    begin
        "TDS%" := 0;
        "TDS Type" := "TDS Type"::" ";
        "TDS Amount" := 0;
        "TDS Base Amount" := 0;
    end;

    local procedure FindTDSType(): Integer
    var
        TDSSetup2: Record "TDS Posting Group";
    begin
        TDSSetup2.RESET;
        TDSSetup2.SETRANGE(Code, "TDS Group");
        IF TDSSetup2.FINDFIRST THEN
            EXIT(TDSSetup2.Type);
    end;

    procedure NotAllowTDSAccountSelectInJournalLines()
    var
        TDSPostingGroup: Record "TDS Posting Group";
        UserSetup: Record "User Setup";
    begin
        //TDS1.00 <<
        UserSetup.GET(USERID);
        IF ("Account Type" = "Account Type"::"G/L Account") AND (NOT UserSetup."Allow TDS A/C Direct Posting") THEN BEGIN
            TDSPostingGroup.RESET;
            TDSPostingGroup.SETRANGE("GL Account No.", "Account No.");
            IF TDSPostingGroup.FINDFIRST THEN
                ERROR('You cannot select TDS Account No. %1 in journal lines', "Account No.");
        END;
        //TDS1.00 <<
    end;

    var
        Text095: Label 'Party No. does not match';

    var
        SalesPersonPosting: Record "Product&Salesperson Posting Gr";
        Vendor: Record "Vendor";
        Customer: Record "Customer";
        VendorRec: Record "Vendor";
        "--KMT2016CU5": Integer;
        GLAcc1: Record "G/L Account";
        GenJnlTemp1: Record "Gen. Journal Template";
        GenJnlBatch1: Record "Gen. Journal Batch";
        genjnlline1: Record "Gen. Journal Line";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        ICPartner: Record "IC Partner";
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlTemplate: Record "Gen. Journal Template";
        KtmMarketingMgt: Codeunit "KtmMarketing.Mgt";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        SourceCodeSetup: Record "Source Code Setup";
        CustCheckCreditLimit: codeunit "Cust-Check Cr. Limit";
        Text014: Label 'The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?', Comment = '%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no.';
}

