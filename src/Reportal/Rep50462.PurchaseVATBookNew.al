report 50462 "Purchase VAT Book (New)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseVATBookNew.rdlc';

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = WHERE(Type = CONST(Purchase));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Posting Date", "Document No.", "External Document No.", PragyapanPatra;
            column(DoNotShowHeader; DoNotShowHeader)
            {
            }
            column(VATRegistrationNo_VATEntry; "VAT Entry"."VAT Registration No.")
            {
            }
            column(PurchType; PurchType)
            {
            }
            column(EntryNo_VATEntry; "VAT Entry"."Entry No.")
            {
            }
            column(GenBusPostingGroup_VATEntry; "VAT Entry"."Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup_VATEntry; "VAT Entry"."Gen. Prod. Posting Group")
            {
            }
            column(PostingDate_VATEntry; "VAT Entry"."Posting Date")
            {
            }
            column(DocumentNo_VATEntry; "VAT Entry"."Document No.")
            {
            }
            column(DocumentType_VATEntry; "VAT Entry"."Document Type")
            {
            }
            column(Type_VATEntry; "VAT Entry".Type)
            {
            }
            column(Base_VATEntry; "VAT Entry".Base)
            {
            }
            column(Amount_VATEntry; "VAT Entry".Amount)
            {
            }
            column(vAT; "VAT Entry"."VAT Calculation Type")
            {
            }
            column(BilltoPaytoNo_VATEntry; "VAT Entry"."Bill-to/Pay-to No.")
            {
            }
            column(EU3PartyTrade_VATEntry; "VAT Entry"."EU 3-Party Trade")
            {
            }
            column(UserID_VATEntry; "VAT Entry"."User ID")
            {
            }
            column(SourceCode_VATEntry; "VAT Entry"."Source Code")
            {
            }
            column(ReasonCode_VATEntry; "VAT Entry"."Reason Code")
            {
            }
            column(ClosedbyEntryNo_VATEntry; "VAT Entry"."Closed by Entry No.")
            {
            }
            column(ExternalDocumentNo_VATEntry; "VAT Entry"."External Document No.")
            {
            }
            column(NoSeries_VATEntry; "VAT Entry"."No. Series")
            {
            }
            column(VATBusPostingGroup_VATEntry; "VAT Entry"."VAT Bus. Posting Group")
            {
            }
            column(VATProdPostingGroup_VATEntry; "VAT Entry"."VAT Prod. Posting Group")
            {
            }
            column(NepaliDate_VATEntry; NepaliDate)
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(SupplierName; SupplierName)
            {
            }
            column(ImportPurchAmount; ImportPurchAmount)
            {
            }
            column(ImportPurchVATAmount; ImportPurchVATAmount)
            {
            }
            column(CAPEXPurchAmount; CAPEXPurchAmount)
            {
            }
            column(CAPEXPurchVATAmount; CAPEXPurchVATAmount)
            {
            }
            column(LocalPurchAmount; LocalPurchAmount)
            {
            }
            column(PragyapanPatraNo_VATEntry; "VAT Entry".PragyapanPatra)
            {
            }
            column(LocalPurchVATAmount; LocalPurchVATAmount)
            {
            }
            column(ExemptPurchAmount; ExemptPurchAmount)
            {
            }
            column(ExemptPurchVATAmount; ExemptPurchVATAmount)
            {
            }
            column(CompanyInfo_VAT_Registration_No; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(TotalPurchaseAmount; TotalPurchaseAmount)
            {
            }
            column(ResponsibilityCenterName; ResponsibilityCenterName)
            {
            }
            column(NepaliYear; EnglishNepaliDate."Nepali Year")
            {
            }
            column(NepaliMonth; EnglishNepaliDate."Nepali Month")
            {
            }
            column(DescriptionVar; DescriptionVar)
            {
            }
            column(Qty; Qty)
            {
            }
            column(TaxableLocalPurchaseAmt; TaxableLocalPurchaseAmt)
            {
            }
            column(VatAmount; VatAmount)
            {
            }
            column(DocumentNo; DocumentNo)
            {
            }
            column(NoVar; NoVar)
            {
            }
            column(UOM; UOM)
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                column(DocumentNo2; DocumentNo)
                {
                }
                column(DocNo2; DocNo)
                {
                }
                column(SupplierName2; SupplierName)
                {
                }
                column(ImportPurchAmount2; ImportPurchAmount)
                {
                }
                column(ImportPurchVATAmount2; ImportPurchVATAmount)
                {
                }
                column(CAPEXPurchAmount2; CAPEXPurchAmount)
                {
                }
                column(CAPEXPurchVATAmount2; CAPEXPurchVATAmount)
                {
                }
                column(LocalPurchAmount2; LocalPurchAmount)
                {
                }
                column(LocalPurchVATAmount2; LocalPurchVATAmount)
                {
                }
                column(ExemptPurchAmount2; ExemptPurchAmount)
                {
                }
                column(ExemptPurchVATAmount2; ExemptPurchVATAmount)
                {
                }
                column(PostingDate2; PostingDate)
                {
                }
                column(TotalPurchaseAmount2; TotalPurchaseAmount)
                {
                }
                column(NoVar2; NoVar)
                {
                }
                column(DescriptionVar2; DescriptionVar)
                {
                }
                column(Qty2; Qty)
                {
                }
                column(TaxableLocalPurchaseAmt2; TaxableLocalPurchaseAmt)
                {
                }
                column(VatAmount2; VatAmount)
                {
                }
                column(UOM1; UOM)
                {
                }

                trigger OnAfterGetRecord()
                var
                    PurchInvLine: Record "Purch. Inv. Line";
                begin
                    ClearVar;

                    IF Type = Type::"G/L Account" THEN
                        IF STRPOS(SkipGL, "No.") > 0 THEN
                            CurrReport.SKIP;

                    HasInvoice := TRUE;
                    HasDocument := TRUE;
                    pp := "VAT Entry".PragyapanPatra;
                    IF Type = Type::"Charge (Item)" THEN
                        IF IncludeItemCharge("No.") THEN
                            DocNo := "VAT Entry"."External Document No."
                        ELSE
                            DocNo := "VAT Entry".PragyapanPatra;
                    DocumentNo := "Document No.";
                    LineNo := LineNo;
                    LineType := Type;
                    NoVar := "No.";
                    Qty := Quantity;

                    IF Type = Type::"Charge (Item)" THEN
                        IF ItemCharge.GET("No.") THEN
                            IF NOT ItemCharge."Show in VAT Book" THEN
                                CurrReport.SKIP;

                    UOM := "Purch. Inv. Line"."Unit of Measure Code";
                    IF NoVar <> '' THEN
                        DescriptionVar := GetDescription(LineType, NoVar);
                    TotalPurchaseAmount := "VAT Base Amount";

                    PurchInvHeader.GET("Document No.");
                    IF PurchInvHeader."Currency Factor" <> 0 THEN BEGIN
                        IF PurchInvHeader."Currency Factor" < 1 THEN
                            TotalPurchaseAmount := "VAT Base Amount" / PurchInvHeader."Currency Factor"
                        ELSE
                            TotalPurchaseAmount := "VAT Base Amount" * PurchInvHeader."Currency Factor";
                    END;

                    CLEAR(VatPostingSetup);
                    IF VatPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN;

                    // IF ("VAT Entry"."Capital Expenditure") and
                    //      ("Gen. Prod. Posting Group" = 'VEHCAP') THEN
                    IF VatPostingSetup."Localized VAT Identifier2" > 0 THEN
                        IF Type = Type::"Fixed Asset" THEN
                            VatPostingSetup."Localized VAT Identifier2" := VatPostingSetup."Localized VAT Identifier2"::"Taxable Capex Purchase";

                    CASE "Localized VAT Identifier" OF

                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Import Purchase":
                            BEGIN
                                PurchInvHeader.CALCFIELDS(Amount);
                                PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                                PurchInvLine.SETRANGE("Localized VAT Identifier", PurchInvLine."Localized VAT Identifier"::"Taxable Import Purchase");
                                PurchInvLine.CALCSUMS(Quantity);


                                ImportPurchAmount := TotalPurchaseAmount;
                                ImportPurchVATAmount := TotalPurchaseAmount * "Purch. Inv. Line"."VAT %" / 100;
                                IF (PPTotalPurchaseAmount <> 0) AND (Type = Type::Item) THEN BEGIN
                                    ImportPurchAmount := Quantity / PurchInvLine.Quantity * PPTotalPurchaseAmount;
                                    ImportPurchVATAmount := ROUND(ImportPurchAmount / PPTotalPurchaseAmount * PPImportVatValue, 0.00000000001, '=');

                                END;


                                IF ImportPurchaseVATBase THEN BEGIN
                                    TotalPurchaseAmount -= ImportPurchAmount;
                                    ImportPurchAmount := ImportPurchVATAmount * 100 / 13;
                                    TotalPurchaseAmount += ImportPurchAmount;
                                END;

                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Local Purchase":
                            BEGIN
                                TaxableLocalPurchaseAmt := TotalPurchaseAmount;
                                VatAmount := "Amount Including VAT" - Amount;

                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Exempt Purchase":
                            BEGIN
                                IF "VAT Entry".PragyapanPatra = '' THEN
                                    ExemptPurchAmount := TotalPurchaseAmount;
                                IF ExemptPurchAmount = 0 THEN BEGIN
                                    PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                                    PurchInvLine.SETRANGE("Localized VAT Identifier", PurchInvLine."Localized VAT Identifier"::"Exempt Purchase");
                                    PurchInvLine.CALCSUMS(Quantity);
                                    IF PurchInvLine.Quantity <> 0 THEN
                                        ExemptPurchAmount := Quantity / PurchInvLine.Quantity * PPExcemptTotal;
                                END;

                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Capex Purchase":
                            BEGIN
                                CAPEXPurchAmount := TotalPurchaseAmount;
                                CAPEXPurchVATAmount := "Amount Including VAT" - Amount;
                                IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                                    CAPEXPurchVATAmount := "Amount Including VAT";
                                    CAPEXPurchAmount := CAPEXPurchVATAmount * 100 / 13;
                                END;

                            END;
                        ELSE
                            CurrReport.SKIP;
                    END;

                    TotalPurchaseAmount := ImportPurchAmount + CAPEXPurchAmount + TaxableLocalPurchaseAmt + ExemptPurchAmount;

                    IF TotalPurchaseAmount = 0 THEN //Min
                        CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Document No.", "VAT Entry"."Document No.");

                    ClearVar;
                end;
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                column(DocumentNo3; DocumentNo)
                {
                }
                column(DocNo3; DocNo)
                {
                }
                column(SupplierName3; SupplierName)
                {
                }
                column(ImportPurchAmount3; ImportPurchAmount)
                {
                }
                column(ImportPurchVATAmount3; ImportPurchVATAmount)
                {
                }
                column(CAPEXPurchAmount3; CAPEXPurchAmount)
                {
                }
                column(CAPEXPurchVATAmount3; CAPEXPurchVATAmount)
                {
                }
                column(LocalPurchAmount3; LocalPurchAmount)
                {
                }
                column(LocalPurchVATAmount3; LocalPurchVATAmount)
                {
                }
                column(ExemptPurchAmount3; ExemptPurchAmount)
                {
                }
                column(ExemptPurchVATAmount3; ExemptPurchVATAmount)
                {
                }
                column(PostingDate3; PostingDate)
                {
                }
                column(TotalPurchaseAmount3; TotalPurchaseAmount)
                {
                }
                column(NoVar3; NoVar)
                {
                }
                column(DescriptionVar3; DescriptionVar)
                {
                }
                column(Qty3; Qty)
                {
                }
                column(TaxableLocalPurchaseAmt3; TaxableLocalPurchaseAmt)
                {
                }
                column(VatAmount3; VatAmount)
                {
                }
                column(UOM3; UOM)
                {
                }

                trigger OnAfterGetRecord()
                var
                    PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                    ImportQty: Decimal;
                    ExemptQty: Decimal;
                begin
                    ClearVar;

                    IF Type = Type::"G/L Account" THEN
                        IF STRPOS(SkipGL, "No.") > 0 THEN
                            CurrReport.SKIP;

                    HasDocument := TRUE;
                    DocumentNo := "Document No.";
                    pp := "VAT Entry".PragyapanPatra;
                    IF Type = Type::"Charge (Item)" THEN
                        IF IncludeItemCharge("No.") THEN
                            DocNo := "VAT Entry"."External Document No."
                        ELSE
                            DocNo := "VAT Entry".PragyapanPatra;

                    LineNo := LineNo;
                    LineType := Type;
                    NoVar := "No.";
                    Qty := -Quantity;
                    IF Type = Type::"Charge (Item)" THEN
                        IF ItemCharge.GET("No.") THEN
                            IF NOT ItemCharge."Show in VAT Book" THEN
                                CurrReport.SKIP;
                    UOM := "Unit of Measure Code";

                    DescriptionVar := GetDescription(LineType, NoVar);
                    TotalPurchaseAmount := -"VAT Base Amount";

                    PurchCrMemoHeader.GET("Document No.");
                    IF PurchCrMemoHeader."Currency Factor" <> 0 THEN BEGIN
                        IF PurchCrMemoHeader."Currency Factor" < 1 THEN
                            TotalPurchaseAmount := -"VAT Base Amount" / PurchCrMemoHeader."Currency Factor"
                        ELSE
                            TotalPurchaseAmount := -"VAT Base Amount" * PurchCrMemoHeader."Currency Factor";
                    END;

                    CLEAR(VatPostingSetup);

                    IF VatPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN;

                    IF VatPostingSetup."Localized VAT Identifier2" > 0 THEN
                        IF Type = Type::"Fixed Asset" THEN
                            VatPostingSetup."Localized VAT Identifier2" := VatPostingSetup."Localized VAT Identifier2"::"Taxable Capex Purchase";


                    CASE "Localized VAT Identifier" OF
                        /*
                        VatPostingSetup."Localized VAT Identifier2"::"Purchase Without VAT Invoice":
                        CurrReport.SKIP;
                        */
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Import Purchase":
                            BEGIN
                                PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
                                PurchCrMemoLine.SETRANGE("Localized VAT Identifier", PurchCrMemoLine."Localized VAT Identifier"::"Taxable Import Purchase");
                                PurchCrMemoLine.CALCSUMS(Quantity);
                                ImportPurchAmount := TotalPurchaseAmount;
                                ImportPurchVATAmount := TotalPurchaseAmount * "VAT %" / 100;
                                IF PPTotalPurchaseAmount <> 0 THEN BEGIN
                                    ImportPurchAmount := -Quantity / PurchCrMemoLine.Quantity * PPTotalPurchaseAmount;
                                    ImportPurchVATAmount := ROUND(ImportPurchAmount / PPTotalPurchaseAmount * PPImportVatValue, 0.0000001, '=');

                                END;

                                IF ImportPurchaseVATBase THEN BEGIN
                                    TotalPurchaseAmount -= ImportPurchAmount;
                                    ImportPurchAmount := ImportPurchVATAmount * 100 / 13;
                                    TotalPurchaseAmount += ImportPurchAmount;
                                END;

                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Local Purchase":
                            BEGIN
                                TaxableLocalPurchaseAmt := -"VAT Base Amount";
                                VatAmount := -("Amount Including VAT" - Amount);
                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Exempt Purchase":
                            BEGIN
                                IF "VAT Entry".PragyapanPatra = '' THEN
                                    ExemptPurchAmount := TotalPurchaseAmount;
                                IF ExemptPurchAmount = 0 THEN BEGIN
                                    PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
                                    PurchCrMemoLine.SETRANGE("Localized VAT Identifier", PurchCrMemoLine."Localized VAT Identifier"::"Exempt Purchase");
                                    PurchCrMemoLine.CALCSUMS(Quantity);
                                    IF PurchCrMemoLine.Quantity <> 0 THEN
                                        ExemptPurchAmount := -Quantity / PurchCrMemoLine.Quantity * PPExcemptTotal;

                                END;
                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Capex Purchase":
                            BEGIN
                                CAPEXPurchAmount := -"VAT Base Amount";
                                CAPEXPurchVATAmount := -("Amount Including VAT" - Amount);
                                IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                                    CAPEXPurchVATAmount := -"Amount Including VAT";
                                    CAPEXPurchAmount := CAPEXPurchVATAmount * 100 / 13;
                                END;

                            END;
                        ELSE
                            CurrReport.SKIP;
                    END;
                    TotalPurchaseAmount := ImportPurchAmount + CAPEXPurchAmount + TaxableLocalPurchaseAmt + ExemptPurchAmount;

                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Document No.", "VAT Entry"."Document No.");
                    ClearVar;
                end;
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                column(DocumentNo4; DocumentNo)
                {
                }
                column(DocNo4; DocNo)
                {
                }
                column(SupplierName4; SupplierName)
                {
                }
                column(ImportPurchAmount4; ImportPurchAmount)
                {
                }
                column(ImportPurchVATAmount4; ImportPurchVATAmount)
                {
                }
                column(CAPEXPurchAmount4; CAPEXPurchAmount)
                {
                }
                column(CAPEXPurchVATAmount4; CAPEXPurchVATAmount)
                {
                }
                column(LocalPurchAmount4; LocalPurchAmount)
                {
                }
                column(LocalPurchVATAmount4; LocalPurchVATAmount)
                {
                }
                column(ExemptPurchAmount4; ExemptPurchAmount)
                {
                }
                column(ExemptPurchVATAmount4; ExemptPurchVATAmount)
                {
                }
                column(PostingDate4; PostingDate)
                {
                }
                column(TotalPurchaseAmount4; TotalPurchaseAmount)
                {
                }
                column(ResponsibilityCenterName4; ResponsibilityCenterName)
                {
                }
                column(DescriptionVar4; DescriptionVar)
                {
                }
                column(Qty4; Qty)
                {
                }
                column(TaxableLocalPurchaseAmt4; TaxableLocalPurchaseAmt)
                {
                }
                column(VatAmount4; VatAmount)
                {
                }
                column(NoVar4; NoVar)
                {
                }
                column(UOM4; UOM)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClearVar;
                    IF STRPOS(SkipGL, "G/L Entry"."G/L Account No.") > 0 THEN
                        CurrReport.SKIP;
                    pp := "VAT Entry".PragyapanPatra;
                    DocumentNo := "Document No.";
                    LineNo := "Entry No.";
                    LineType := LineType::"G/L Account";
                    NoVar := "G/L Account No.";

                    Qty := 1;

                    DescriptionVar := GetDescription(LineType, NoVar);
                    TotalPurchaseAmount := Amount;
                    CLEAR(VatPostingSetup);
                    IF VatPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN;

                    /*
                    IF VatPostingSetup."Localized VAT Identifier2" > 0 THEN
                      IF "account type" = "account Type"::"Fixed Asset" THEN
                         VatPostingSetup."Localized VAT Identifier2" := VatPostingSetup."Localized VAT Identifier2"::"Taxable Capex Purchase"   ;
                     */

                    CASE VatPostingSetup."Localized VAT Identifier2" OF
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Import Purchase":
                            BEGIN
                                IF ImportPurchaseVATBase THEN BEGIN
                                    ImportPurchAmount := TotalPurchaseAmount * 100 / 13;
                                    ImportPurchVATAmount := TotalPurchaseAmount * 0.13;
                                END ELSE BEGIN
                                    ImportPurchAmount := TotalPurchaseAmount;
                                    ImportPurchVATAmount := VatAmount;
                                END;
                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Local Purchase":
                            BEGIN
                                TaxableLocalPurchaseAmt := Amount;
                                VatAmount := "VAT Amount";
                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Exempt Purchase":
                            BEGIN

                                ExemptPurchAmount := Amount;
                            END;
                        VatPostingSetup."Localized VAT Identifier2"::"Taxable Capex Purchase":
                            BEGIN
                                CAPEXPurchAmount := Amount;
                                CAPEXPurchVATAmount := ("VAT Amount");

                            END
                        ELSE
                            CurrReport.SKIP;
                    END;

                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Document No.", "VAT Entry"."Document No.");
                    IF HasDocument THEN
                        SETFILTER("Entry No.", '<0');
                    ClearVar;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*IF "Localized VAT Identifier2" = "Localized VAT Identifier2"::"Purchase Without VAT Invoice"  THEN
                  CurrReport.SKIP;*/
                //for import vat case
                IF PurchType = PurchType::Purchase THEN
                    IF Amount < 0 THEN
                        CurrReport.SKIP;
                IF PurchType = PurchType::"Purchase Return" THEN
                    IF Amount > 0 THEN
                        CurrReport.SKIP;

                IF ("Document Type" = "Document Type"::"Credit Memo") THEN
                    "External Document No." := "Document No.";


                CLEAR(PPDocuments);
                CLEAR(PPImportVatValue);
                CLEAR(PPTotalPurchaseAmount);
                CLEAR(PPExcemptTotal);

                IF VatPostingSetup.GET("VAT Entry"."VAT Bus. Posting Group", "VAT Entry"."VAT Prod. Posting Group") THEN
                    IF VatPostingSetup."Localized VAT Identifier2" = 0 THEN
                        CurrReport.SKIP;

                IF PragyapanPatra <> '' THEN BEGIN
                    VATEntry.RESET;
                    VATEntry.SETRANGE(PragyapanPatra, PragyapanPatra);
                    VATEntry.SETFILTER("Posting Date", "VAT Entry".GETFILTER("Posting Date"));
                    IF VATEntry.FINDSET THEN
                        REPEAT
                            IF VatPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group") THEN BEGIN
                                IF (VatPostingSetup."Localized VAT Identifier2" = VatPostingSetup."Localized VAT Identifier2"::"Taxable Import Purchase") AND
                                   (VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Full VAT") THEN
                                    PPImportVatValue += VATEntry.Amount;

                                IF VatPostingSetup."Localized VAT Identifier2" = VatPostingSetup."Localized VAT Identifier2"::"Taxable Import Purchase" THEN
                                    PPTotalPurchaseAmount += VATEntry."VAT Base 1";
                                IF VatPostingSetup."Localized VAT Identifier2" = VatPostingSetup."Localized VAT Identifier2"::"Exempt Purchase" THEN
                                    PPExcemptTotal += VATEntry."Exempt Amount";

                            END;
                        UNTIL VATEntry.NEXT = 0;

                    //PPTotalPurchaseAmount := GetImportPurchaseValueForItem('', "VAT Entry".PragyapanPatra);
                END;





                //MESSAGE('%1, %2', PPTotalPurchaseAmount, PPImportVatValue);
                ClearVar();

                IF LastDocNo = "Document No." THEN
                    CurrReport.SKIP;
                LastDocNo := "Document No.";

                CLEAR(DocNo);
                IF (PragyapanPatra <> '') THEN
                    DocNo := PragyapanPatra
                ELSE
                    DocNo := "External Document No.";

                IF Vendor.GET("Bill-to/Pay-to No.") THEN BEGIN
                    SupplierName := Vendor.Name;
                    "VAT Registration No." := Vendor."VAT Registration No.";
                END;


                CLEAR(NepaliDate);
                NepaliDateRec := SysMgt.getNepaliDate("Posting Date"); //pram
                NepaliDate := CONVERTSTR(NepaliDateRec, '/', '.');
                IF STRLEN(NepaliDate) = 9 THEN   //Amsa
                    NepaliDate := INSSTR(NepaliDate, '0', 9);
                //ResponsibilityCenterName := "Shortcut Dimension 1 Code";

                HasDocument := FALSE;

            end;

            trigger OnPreDataItem()
            begin
                IF PurchType = PurchType::Purchase THEN
                    "VAT Entry".SETRANGE("Document Type", "VAT Entry"."Document Type"::Invoice)
                ELSE
                    IF PurchType = PurchType::"Purchase Return" THEN
                        "VAT Entry".SETRANGE("Document Type", "VAT Entry"."Document Type"::"Credit Memo");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Import Purchase VAT Base"; ImportPurchaseVATBase)
                    {
                        Caption = 'Import Purchase VAT Base (13%)';
                    }
                    field(DoNotShowHeader; DoNotShowHeader)
                    {
                        Caption = 'Do Not Show Header';
                    }
                    field(PurchType; PurchType)
                    {
                        Caption = 'Purchase Type';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        GetSkipGL();
        IF "VAT Entry".GETRANGEMIN("Posting Date") <> 0D THEN
            GetNepaliMonthYear("VAT Entry".GETRANGEMIN("Posting Date"));
        PurchasesPayablesSetup.GET;
    end;

    var
        DocNo: Code[100];
        Vendor: Record Vendor;
        SupplierName: Text[100];
        ImportPurchAmount: Decimal;
        ImportPurchVATAmount: Decimal;
        CAPEXPurchAmount: Decimal;
        CAPEXPurchVATAmount: Decimal;
        LocalPurchAmount: Decimal;
        LocalPurchVATAmount: Decimal;
        ExemptPurchAmount: Decimal;
        ExemptPurchVATAmount: Decimal;
        CompanyInfo: Record "Company Information";
        PostingDate: Text[100];
        ImportPurchaseVATBase: Boolean;
        TotalPurchaseAmount: Decimal;
        NepaliDate: Text;
        ResponsibilityCenter: Record "Responsibility Center";
        ResponsibilityCenterName: Text[50];
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        GLEntry: Record "G/L Entry";
        ValueEntry: Record "Value Entry";
        VATEntry: Record "VAT Entry";
        PreviousItemNo: Code[20];
        ValueEntry1: Record "Value Entry";
        TotalCostAmtActual: Decimal;
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        EnglishNepaliDate: Record "English-Nepali Date";
        EnglishDateVar: Date;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PurchType: Option All,Purchase,"Purchase Return";
        VatBaseAmount: Decimal;
        VatAmount: Decimal;
        LineNo: Integer;
        VatPostingSetup: Record "VAT Posting Setup";
        LineType: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)",,"External Service";
        NoVar: Text;
        DescriptionVar: Text;
        Qty: Decimal;
        pp: Text;
        DocumentNo: Text;
        TaxableLocalPurchaseAmt: Decimal;
        HasDocument: Boolean;
        SysMgt: Codeunit "IRD Mgt.";
        LastDocNo: Text;
        HasInvoice: Boolean;
        HasCredit: Boolean;
        SkipGL: Text;
        PPDocuments: Text;
        PPImportVatValue: Decimal;
        PPTotalPurchaseAmount: Decimal;
        SkipItemCharge: Text;
        ItemCharge: Record "Item Charge";
        UOM: Text;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        NepaliDateRec: Text;
        DoNotShowHeader: Boolean;
        ILE: Record "Item Ledger Entry";
        ItemChargeSetup: Record "Item Charge";
        PPExcemptTotal: Decimal;

    local procedure CalculateImportVATAmt(TotalCostAmtActual: Decimal; ItemCostAmtActual: Decimal; TotalVatAmt: Decimal): Decimal
    begin
        IF (TotalVatAmt <> 0) AND (TotalCostAmtActual <> 0) THEN
            EXIT(ROUND((ItemCostAmtActual / TotalCostAmtActual * TotalVatAmt), 0.01, '='))
        ELSE
            EXIT(0);
    end;

    local procedure GetNepaliMonthYear(EnglishDate: Date)
    begin
        EnglishNepaliDate.RESET;
        EnglishNepaliDate.SETRANGE("English Date", EnglishDate);
        IF EnglishNepaliDate.FINDFIRST THEN;
    end;

    local procedure GetDescription(LineType: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)",,"External Service"; LineItemNo: Code[20]): Text
    var
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        Resource: Record Resource;
        GLAccount: Record "G/L Account";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        FAPostingGroup: Record "FA Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        CASE PurchasesPayablesSetup."Show Description From" OF
            PurchasesPayablesSetup."Show Description From"::Default:
                BEGIN
                    CASE LineType OF
                        LineType::Item:
                            BEGIN
                                Item.GET(LineItemNo);
                                EXIT(Item.Description);
                            END;
                        LineType::"Fixed Asset":
                            BEGIN
                                FixedAsset.GET(LineItemNo);
                                EXIT(FixedAsset.Description);
                            END;
                        LineType::"G/L Account":
                            BEGIN
                                GLAccount.GET(LineItemNo);
                                EXIT(GLAccount.Name);
                            END;
                        LineType::"Charge (Item)":
                            BEGIN
                                ItemChargeSetup.GET(LineItemNo);
                                EXIT('ITEM CHARGE');
                            END;
                    /*
                    LineType::"External Service" :
                      BEGIN
                        PurchasesPayablesSetup.GET;
                        EXIT(PurchasesPayablesSetup."External Service VAT Book");
                      END;
                    ELSE
                        EXIT(FORMAT(PurchasesPayablesSetup."External Service VAT Book"));*/
                    END;
                END;

            PurchasesPayablesSetup."Show Description From"::"Posting Groups":
                BEGIN
                    CASE LineType OF
                        LineType::Item:
                            BEGIN
                                Item.GET(LineItemNo);
                                InventoryPostingGroup.GET(Item."Inventory Posting Group");
                                EXIT(InventoryPostingGroup."Description for VAT Book");
                            END;
                        LineType::"Fixed Asset":
                            BEGIN
                                FixedAsset.GET(LineItemNo);
                                FAPostingGroup.GET(FixedAsset."FA Posting Group");
                                EXIT(FixedAsset.Description);
                            END;
                        LineType::"G/L Account":
                            BEGIN
                                GLAccount.GET(LineItemNo);
                                EXIT(GLAccount.Name);
                            END;
                    /*LineType::"Charge (Item)":
                      BEGIN
                        ItemChargeSetup.GET(LineItemNo);
                        EXIT(ItemChargeSetup."Description for VAT Book");
                      END;
                    LineType::"External Service" :
                      BEGIN
                        PurchasesPayablesSetup.GET;
                        EXIT(PurchasesPayablesSetup."External Service VAT Book");
                      END;
                    ELSE
                        EXIT(FORMAT(PurchasesPayablesSetup."External Service VAT Book"));*/
                    END;
                END;
        END;

    end;

    local procedure ClearVar()
    begin
        CLEAR(pp);
        CLEAR(LineNo);
        CLEAR(DocumentNo);
        CLEAR(LineType);
        CLEAR(NoVar);
        CLEAR(Qty);
        CLEAR(DescriptionVar);
        CLEAR(VatBaseAmount);
        CLEAR(VatPostingSetup);
        CLEAR(VatAmount);
        CLEAR(ExemptPurchAmount);
        CLEAR(ImportPurchAmount);
        CLEAR(ImportPurchVATAmount);
        CLEAR(CAPEXPurchAmount);
        CLEAR(CAPEXPurchVATAmount);
        CLEAR(CAPEXPurchAmount);
        CLEAR(TaxableLocalPurchaseAmt);
        CLEAR(TotalPurchaseAmount);
        CLEAR(UOM);
    end;

    local procedure GetSkipGL()
    begin
        VatPostingSetup.RESET;
        VatPostingSetup.SETFILTER("Purchase VAT Account", '<>%1', '');
        IF VatPostingSetup.FINDSET THEN
            REPEAT
                SkipGL += VatPostingSetup."Purchase VAT Account" + ', ';
            UNTIL VatPostingSetup.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure GetImportPurchaseValueForItem(ItemNo: Code[20]; PPno: Code[35]): Decimal
    var
        ValueEntry: Record "Value Entry";
        Amt: Decimal;
    begin
        IF PPno = '' THEN   //aakrista
            EXIT(0);

        ValueEntry.RESET;
        IF ItemNo <> '' THEN
            ValueEntry.SETRANGE("Item No.", ItemNo);// ''''+ItemNo+''''); //Min


        ValueEntry.SETFILTER("Posting Date", "VAT Entry".GETFILTER("Posting Date"));
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Purchase);
        ValueEntry.SETRANGE("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
        ValueEntry.SETRANGE(PragyapanPatra, PPno);
        IF ValueEntry.FINDSET() THEN
            REPEAT
                IF (NOT IncludeItemCharge(ValueEntry."Item Charge No.")) OR (ValueEntry."Item Charge No." = '') THEN
                    Amt += ValueEntry."Cost Amount (Actual)";
            UNTIL ValueEntry.NEXT = 0;

        EXIT(Amt);
    end;

    [Scope('OnPrem')]
    procedure IncludeItemCharge(ItemChargeCode: Text): Boolean
    begin
        IF ItemCharge.GET(ItemChargeCode) THEN
            EXIT(ItemCharge."Show in VAT Book");
        EXIT(FALSE);
    end;
}

