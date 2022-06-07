report 50094 "Uniform Sales VAT Book (New)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './UniformSalesVATBookNew.rdlc';

    dataset
    {
        dataitem(DataItem1000000003; Table50001)
        {
            DataItemTableView = SORTING (Table ID, Document Type, Bill No, Fiscal Year)
                                ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Bill Date", "Bill No";
            column(VAT_No_______comInfo__VAT_Registration_No__; comInfo."VAT Registration No.")
            {
            }
            column(comInfo_Name; comInfo.Name)
            {
            }
            column(NepaliYear; EnglishNepaliDate."Nepali Year")
            {
            }
            column(NepaliMonth; EnglishNepaliDate."Nepali Month")
            {
            }
            column(PERIOD_OF_SALES_______Sales_Invoice_Header__GETFILTER__Posting_Date__; 'PERIOD OF SALES :  ' + "Invoice Materialize View".GETFILTER("Bill Date"))
            {
            }
            column(TableID_InvoiceMaterializeView; "Invoice Materialize View"."Table ID")
            {
            }
            column(DocumentType; "Invoice Materialize View"."Document Type")
            {
            }
            column(DocumentNo; "Invoice Materialize View"."Bill No")
            {
            }
            column(FiscalYear; "Invoice Materialize View"."Fiscal Year")
            {
            }
            column(PostingDate; "Invoice Materialize View"."Bill Date")
            {
            }
            column(PostingTime_InvoiceMaterializeView; "Invoice Materialize View"."Posting Time")
            {
            }
            column(SourceType_InvoiceMaterializeView; "Invoice Materialize View"."Source Type")
            {
            }
            column(CustomerCode_InvoiceMaterializeView; "Invoice Materialize View"."Customer Code")
            {
            }
            column(SourceCode_InvoiceMaterializeView; "Invoice Materialize View"."Source Code")
            {
            }
            column(CustomerName; "Invoice Materialize View"."Customer Name")
            {
            }
            column(VATPANNo; "Invoice Materialize View"."VAT Registration No.")
            {
            }
            column(Amount; "Invoice Materialize View".Amount)
            {
            }
            column(DiscountAmount; "Invoice Materialize View".Discount)
            {
            }
            column(TaxableAmount; "Invoice Materialize View"."Taxable Amount")
            {
            }
            column(VATAmount; "Invoice Materialize View"."TAX Amount")
            {
            }
            column(TotalAmount; "Invoice Materialize View"."Total Amount")
            {
            }
            column(BranchName; branchname)
            {
            }
            column(NonTaxableAmount_InvoiceMaterializeView; NonTaxSales)
            {
            }
            column(VATEntryValue; VATEntryValue)
            {
            }
            column(ShowReconcileData; ShowReconcileData)
            {
            }
            column(GLVATValue; GLVATValue)
            {
            }
            column(RecSalesLine_Quantity; "Invoice Materialize View".Amount)
            {
            }
            column(TotalAmount_InvoiceMaterializeView; TotalSale)
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(ItemType; TypeVar)
            {
            }
            column(ItemNo; NoVar)
            {
            }
            column(Description; DescriptionVar)
            {
            }
            column(Quantity; Qty)
            {
            }
            column(Amt; Amt)
            {
            }
            column(AmtIncVAT; AmountInclVat)
            {
            }
            column(VATBaseAmt; VatBaseAmount)
            {
            }
            column(VATAmt; VatAmount)
            {
            }
            column(PostingGroupCode; ProductGroup)
            {
            }
            column(LineNo; LineNo)
            {
            }
            column(GroupBy; GroupBy)
            {
            }
            column(UOM; UOM)
            {
            }
            column(NonTaxSale; NonTaxSale)
            {
            }
            column(PostingDateNepali; PostingDateNepali)
            {
            }
            dataitem(DataItem1000000053; Table113)
            {
                DataItemTableView = SORTING (Document No., Line No.);
                column(DocNo1; DocNo)
                {
                }
                column(ItemType1; TypeVar)
                {
                }
                column(UOM1; UOM)
                {
                }
                column(ItemNo1; NoVar)
                {
                }
                column(Description1; DescriptionVar)
                {
                }
                column(Quantity1; Qty)
                {
                }
                column(Amt1; Amt)
                {
                }
                column(AmtIncVAT1; AmountInclVat)
                {
                }
                column(VATBaseAmt1; VatBaseAmount)
                {
                }
                column(VATAmt1; VatAmount)
                {
                }
                column(PostingGroupCode1; ProductGroup)
                {
                }
                column(LineNo1; LineNo)
                {
                }
                column(GroupBy1; GroupBy)
                {
                }
                column(NonTaxSale1; NonTaxSale)
                {
                }
                column(NonTaxableAmount_InvoiceMaterializeView1; NonTaxSales)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DocNo := "Sales Invoice Line"."Document No.";
                    LineNo := "Sales Invoice Line"."Line No.";
                    NoVar := "No.";
                    DescriptionVar := GetDescription("Sales Invoice Line".Type, "Sales Invoice Line"."No.");
                    ProductGroup := GetPostingGroup("Sales Invoice Line".Type, "Sales Invoice Line"."No.");
                    VatAmount := "Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount;
                    VatBaseAmount := 0;
                    IF VatAmount > 0 THEN
                        VatBaseAmount := "Sales Invoice Line"."VAT Base Amount";
                    CLEAR(NonTaxSales);
                    IF VatAmount = 0 THEN
                        NonTaxSales := "VAT Base Amount";
                    Qty := "Sales Invoice Line".Quantity;
                    TypeVar := "Sales Invoice Line".Type;
                    NonTaxSale := "Sales Invoice Line"."VAT Base Amount";
                    IF SalesReceivablesSetup."Show Description From" = SalesReceivablesSetup."Show Description From"::Default THEN
                        GroupBy := FORMAT(LineNo)
                    ELSE
                        GroupBy := ProductGroup;

                    HasDocument := TRUE;
                    UOM := "Sales Invoice Line"."Unit of Measure Code";
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Document No.", "Invoice Materialize View"."Bill No");
                    SETRANGE("Posting Date", "Invoice Materialize View"."Bill Date");
                    LoopCounter := COUNT;
                end;
            }
            dataitem("<Sales Cr.Memo Line>"; Table115)
            {
                DataItemTableView = SORTING (Document No., Line No.);
                column(DocNo2; DocNo)
                {
                }
                column(ItemType2; TypeVar)
                {
                }
                column(UOM2; UOM)
                {
                }
                column(ItemNo2; NoVar)
                {
                }
                column(Description2; DescriptionVar)
                {
                }
                column(Quantity2; Qty)
                {
                }
                column(Amt2; Amt)
                {
                }
                column(AmtIncVAT2; AmountInclVat)
                {
                }
                column(VATBaseAmt2; VatBaseAmount)
                {
                }
                column(VATAmt2; VatAmount)
                {
                }
                column(PostingGroupCode2; ProductGroup)
                {
                }
                column(LineNo2; LineNo)
                {
                }
                column(NonTaxSale2; NonTaxSale)
                {
                }
                column(GroupBy2; GroupBy)
                {
                }
                column(NonTaxableAmount_InvoiceMaterializeView2; NonTaxSales)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF "No." = '' THEN  //Min for skip no. blank lines
                        CurrReport.SKIP;
                    DocNo := "Document No.";
                    LineNo := "Line No.";
                    NoVar := "No.";
                    DescriptionVar := GetDescription(Type, "No.");
                    ProductGroup := GetPostingGroup(Type, "No.");
                    VatAmount := -("Amount Including VAT" - Amount); //Min Added - sign
                    VatBaseAmount := 0;
                    IF VatAmount <> 0 THEN
                        VatBaseAmount := -"VAT Base Amount";
                    CLEAR(NonTaxSales);
                    IF VatAmount = 0 THEN
                        NonTaxSales := -"VAT Base Amount";

                    Qty := Quantity;
                    TypeVar := Type;
                    NonTaxSale := -"VAT Base Amount";
                    IF SalesReceivablesSetup."Show Description From" = SalesReceivablesSetup."Show Description From"::Default THEN
                        GroupBy := FORMAT(LineNo)
                    ELSE
                        GroupBy := ProductGroup;

                    HasDocument := TRUE;
                    //"<Sales Cr.Memo Line>"
                    UOM := "<Sales Cr.Memo Line>"."Unit of Measure Code";
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Document No.", "Invoice Materialize View"."Bill No");
                    SETRANGE("Posting Date", "Invoice Materialize View"."Bill Date");
                    LoopCounter := COUNT;
                end;
            }
            dataitem(DataItem1000000051; Table17)
            {
                DataItemTableView = SORTING (Entry No.);
                column(DocNo3; DocNo)
                {
                }
                column(ItemType3; TypeVar)
                {
                }
                column(ItemNo3; NoVar)
                {
                }
                column(Description3; DescriptionVar)
                {
                }
                column(Quantity3; Qty)
                {
                }
                column(Amt3; Amt)
                {
                }
                column(AmtIncVAT3; AmountInclVat)
                {
                }
                column(VATBaseAmt3; VatBaseAmount)
                {
                }
                column(VATAmt3; VatAmount)
                {
                }
                column(PostingGroupCode3; ProductGroup)
                {
                }
                column(UOM3; UOM)
                {
                }
                column(LineNo3; LineNo)
                {
                }
                column(GroupBy3; GroupBy)
                {
                }
                column(NonTaxSale3; NonTaxSale)
                {
                }
                column(NonTaxableAmount_InvoiceMaterializeView3; NonTaxSales)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF HasDocument OR ("G/L Entry"."G/L Account No." = SkipGLAccounts) THEN //Min
                        CurrReport.SKIP;
                    DocNo := "Document No.";
                    LineNo := "Entry No.";
                    CALCFIELDS("G/L Account Name");
                    NoVar := "G/L Account No.";
                    DescriptionVar := "G/L Entry"."G/L Account Name";
                    ProductGroup := "G/L Entry"."Gen. Prod. Posting Group";
                    VatAmount := "G/L Entry"."VAT Amount";
                    NonTaxSale := "G/L Entry".Amount;
                    Qty := Quantity;
                    IF VatAmount > 0 THEN
                        VatBaseAmount := "G/L Entry".Amount;
                    CLEAR(NonTaxSales);
                    IF VatAmount = 0 THEN
                        NonTaxSales := "G/L Entry".Amount;
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN //Min
                        VatAmount := -"G/L Entry"."VAT Amount";
                        VatBaseAmount := -"G/L Entry".Amount;
                        NonTaxSale := -"G/L Entry".Amount;
                        Qty := 1;
                    END;
                    TypeVar := TypeVar::"G/L Account";
                    IF SalesReceivablesSetup."Show Description From" = SalesReceivablesSetup."Show Description From"::Default THEN
                        GroupBy := FORMAT(LineNo)
                    ELSE
                        GroupBy := ProductGroup;
                end;

                trigger OnPreDataItem()
                begin
                    IF HasDocument THEN
                        SETRANGE("Document No.", '')
                    ELSE
                        SETRANGE("Document No.", "Invoice Materialize View"."Bill No");
                    SETRANGE("Posting Date", "Invoice Materialize View"."Bill Date");
                    SETFILTER("G/L Entry"."Localized VAT Identifier", '<>%1', "G/L Entry"."Localized VAT Identifier"::" "); //Min
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*IF SalesType = SalesType::Sales THEN
                  IF Amount < 0 THEN
                    CurrReport.SKIP;
                IF SalesType = SalesType::"Sales Return" THEN
                  IF Amount > 0 THEN
                    CurrReport.SKIP;*/
                IF SalesType = SalesType::Sales THEN //Min
                    SETRANGE("Document Type", "Document Type"::"Sales Invoice");
                IF SalesType = SalesType::"Sales Return" THEN //Min
                    SETRANGE("Document Type", "Document Type"::"Sales Credit Memo");

                IF "Invoice Materialize View"."Document Type" = "Invoice Materialize View"."Document Type"::"Sales Invoice" THEN BEGIN
                    IF SalesInvHdr.GET("Invoice Materialize View"."Bill No") THEN BEGIN
                        IF DimValue.GET('Branch', SalesInvHdr."Shortcut Dimension 1 Code") THEN
                            branchname := DimValue.Name;

                        //      FindDocumentLines("Invoice Materialize View"."Document No.");
                    END;
                    //TotalSale := "Invoice Materialize View"."Non Taxable Amount" + "Invoice Materialize View"."Taxable Amount";
                END ELSE
                    IF "Invoice Materialize View"."Document Type" = "Invoice Materialize View"."Document Type"::"Sales Credit Memo" THEN BEGIN
                        IF Crmemohr.GET("Invoice Materialize View"."Bill No") THEN BEGIN
                            IF DimValue.GET('Branch', Crmemohr."Shortcut Dimension 1 Code") THEN
                                branchname := DimValue.Name;
                            // FindDocumentLines("Invoice Materialize View"."Document No.");
                        END;
                        //  TotalSale := "Invoice Materialize View"."Non Taxable Amount" + "Invoice Materialize View"."Taxable Amount";
                    END;
                CLEAR(DocNo);
                CLEAR(LineNo);
                CLEAR(NoVar);
                CLEAR(DescriptionVar);
                CLEAR(ProductGroup);
                CLEAR(VatAmount);
                CLEAR(VatBaseAmount);
                CLEAR(Qty);
                CLEAR(TypeVar);
                CLEAR(NonTaxSale);
                CLEAR(NepaliDate);
                CLEAR(UOM);
                HasDocument := FALSE;
                NepaliDate := STPLSysMgmt.getNepaliDate("Invoice Materialize View"."Bill Date"); //Min For Nepali date
                PostingDateNepali := CONVERTSTR(NepaliDate, '/', '.');
                IF STRLEN(PostingDateNepali) = 9 THEN   //Amsa
                    PostingDateNepali := INSSTR(PostingDateNepali, '0', 9);

            end;

            trigger OnPreDataItem()
            begin
                IF SalesType = SalesType::Sales THEN
                    SETRANGE("Invoice Materialize View"."Document Type", "Invoice Materialize View"."Document Type"::"Sales Invoice")
                ELSE
                    IF SalesType = SalesType::"Sales Return" THEN
                        SETRANGE("Invoice Materialize View"."Document Type", "Invoice Materialize View"."Document Type"::"Sales Credit Memo");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Reconciliation)
                {
                    Caption = 'Reconciliation';
                    field(ShowReconcileData; ShowReconcileData)
                    {
                        Caption = 'Show Reconcile Data';
                    }
                    field(PostingGrpwiseSum; PostingGrpwiseSum)
                    {
                        Caption = 'Sum Amount Posting Groupwise';
                    }
                    field("Sales Type"; SalesType)
                    {
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
        comInfo.GET;
        CLEAR(PostingDateFilter);
        PostingDateFilter := "Invoice Materialize View".GETFILTER("Bill Date");
        IF PostingDateFilter <> '' THEN
            EnglishDateVar := "Invoice Materialize View".GETRANGEMIN("Bill Date");
        GetNepaliMonthYear(EnglishDateVar);
        SalesReceivablesSetup.GET;
        SkipGL();
    end;

    var
        recVatEntry: Record "254";
        Crmemohr: Record "114";
        Crmemohrline: Record "115";
        SalesInvHdr: Record "112";
        TotalSalesAmount: Decimal;
        DimValue: Record "349";
        comInfo: Record "79";
        VATEntryValue: Decimal;
        GLVATValue: Decimal;
        GLEntry: Record "17";
        ShowReconcileData: Boolean;
        Customer: Record "18";
        GeneralLedgSetup: Record "98";
        branchname: Text;
        TotalSale: Decimal;
        SalesInvoiceLine: Record "113";
        SalesCrMemoLine: Record "115";
        ServiceInvoiceLine: Record "5993";
        ServiceCrMemoLine: Record "5995";
        VATAmt: Decimal;
        EnglishNepaliDate: Record "50000";
        EnglishDateVar: Date;
        SalesReceivablesSetup: Record "311";
        TempSalesInvoiceLine: Record "113" temporary;
        NonTaxSale: Decimal;
        PostingDateFilter: Text;
        PostingGrpwiseSum: Boolean;
        DocNo: Text;
        LineNo: Integer;
        LineType: Integer;
        NoVar: Text;
        DescriptionVar: Text;
        VatBaseAmount: Decimal;
        VatAmount: Decimal;
        Qty: Decimal;
        Amt: Decimal;
        AmountInclVat: Decimal;
        ProductGroup: Text;
        TypeVar: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        LoopCounter: Integer;
        HasDocument: Boolean;
        GroupBy: Text;
        NonTaxSales: Decimal;
        STPLSysMgmt: Codeunit "50000";
        PostingDateNepali: Text;
        SkipGLAccounts: Text;
        NepaliDate: Code[10];
        SalesType: Option All,Sales,"Sales Return";
        UOM: Text;

    local procedure GetNepaliMonthYear(EnglishDate: Date)
    begin
        EnglishNepaliDate.RESET;
        EnglishNepaliDate.SETRANGE("English Date", EnglishDate);
        IF EnglishNepaliDate.FINDFIRST THEN;
    end;

    local procedure GetDescription(LineType: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; LineItemNo: Code[20]): Text
    var
        Item: Record "27";
        FixedAsset: Record "5600";
        Resource: Record "156";
        GLAccount: Record "15";
        GenProductPostingGroup: Record "251";
        FAPostingGroup: Record "5606";
        InventoryPostingGroup: Record "94";
        WorkType: Record "200";
    begin
        CASE SalesReceivablesSetup."Show Description From" OF
            SalesReceivablesSetup."Show Description From"::Default:
                BEGIN
                    CASE LineType OF
                        LineType::Item:
                            BEGIN
                                IF Item.GET(LineItemNo) THEN
                                    EXIT(Item.Description);
                            END;
                        LineType::"Fixed Asset":
                            BEGIN
                                FixedAsset.GET(LineItemNo);
                                EXIT(FixedAsset.Description);
                            END;
                        LineType::Resource:
                            BEGIN
                                Resource.GET(LineItemNo);
                                EXIT(Resource.Name);
                            END;
                        LineType::"G/L Account":
                            BEGIN
                                GLAccount.GET(LineItemNo);
                                EXIT(GLAccount.Name);
                            END;
                    END;
                END;

            SalesReceivablesSetup."Show Description From"::"Posting Groups":
                BEGIN
                    CASE LineType OF
                        LineType::Item:
                            BEGIN
                                IF Item.GET(LineItemNo) THEN
                                    InventoryPostingGroup.GET(Item."Inventory Posting Group");
                                EXIT(InventoryPostingGroup."Description for VAT Book");
                            END;
                        LineType::"Fixed Asset":
                            BEGIN
                                FixedAsset.GET(LineItemNo);
                                FAPostingGroup.GET(FixedAsset."FA Posting Group");
                                EXIT(FAPostingGroup."Description for VAT Book");
                            END;
                        LineType::Resource:
                            BEGIN
                                Resource.GET(LineItemNo);
                                GenProductPostingGroup.GET(Resource."Gen. Prod. Posting Group");
                                EXIT(GenProductPostingGroup."Description for VAT Book");
                            END;
                        LineType::"G/L Account":
                            BEGIN
                                GLAccount.GET(LineItemNo);
                                EXIT(GLAccount."Description VAT Book");
                            END;
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetPostingGroup(LineType: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; LineItemNo: Code[20]): Code[20]
    var
        Item: Record "27";
        FixedAsset: Record "5600";
        Resource: Record "156";
        GLAccount: Record "15";
        GenProductPostingGroup: Record "251";
        FAPostingGroup: Record "5606";
        InventoryPostingGroup: Record "94";
        WorkType: Record "200";
    begin
        CASE LineType OF
            LineType::Item:
                BEGIN
                    IF Item.GET(LineItemNo) THEN
                        EXIT(Item."Inventory Posting Group");
                END;
            LineType::"Fixed Asset":
                BEGIN
                    FixedAsset.GET(LineItemNo);
                    EXIT(FixedAsset."FA Posting Group");
                END;
            LineType::Resource:
                BEGIN
                    Resource.GET(LineItemNo);
                    EXIT(Resource."Gen. Prod. Posting Group");
                END;
            LineType::"G/L Account":
                BEGIN
                    GLAccount.GET(LineItemNo);
                    EXIT(GLAccount."Description VAT Book");
                END;
        END;
    end;

    local procedure SkipGL()
    var
        VatPostingSetup: Record "325";
    begin
        VatPostingSetup.SETFILTER("Sales VAT Account", '<>%1', '');
        IF VatPostingSetup.FINDFIRST THEN
            SkipGLAccounts := VatPostingSetup."Sales VAT Account";
    end;
}

