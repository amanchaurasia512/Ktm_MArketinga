codeunit 50005 "TempCode SRT"
{
    Permissions = TableData 17 = rm,
                  TableData 21 = rm,
                  TableData 25 = rm,
                  TableData 32 = rm,
                  TableData 110 = rm,
                  TableData 111 = rm,
                  TableData 112 = rm,
                  TableData 113 = rm,
                  TableData 114 = rm,
                  TableData 115 = rm,
                  TableData 120 = rm,
                  TableData 121 = rm,
                  TableData 122 = rm,
                  TableData 123 = rm,
                  TableData 124 = rm,
                  TableData 125 = rm,
                  TableData 254 = rm,
                  TableData 379 = rm,
                  TableData 380 = rm,
                  TableData 5802 = rm,
                  TableData 50001 = rm;

    trigger OnRun()
    var
        InvMat: Record "Invoice Materialize View";
    begin
        //AssignPragyapanPatra1;
        //UpdateMainGLAccTDSEntry;
        //UpdateGLAcc;
        //CorrectLoclizedVATIdentifier;
        //UpdateSalesLCY;
        //UpdateSalesPersonTemp;
        //UpdateVATBase;
        //UpdateGLEntryNo;
        //VATcorrection;
        //MESSAGE('Success..');
        //ProductSegmentCodeCorrection;
        //UpdateGLPartyNo;
        //ProductSegCorrCustLedEntry;
        //UpdateVendorNo;
        //UpdateVatEntryVATZeroPercent;
        //UpdateLocalizedVATIdentifier;
        //UpdateVatEntryBaseWise;
        //UpdateINVatentry;
        //UpdateVatEntryAmtWise;
        //UpdateINVatentryData;
        //UpdateINVatentry13Percent;
        //UpdateDocumentVatEntry;
        //UpdateVatEntryVATZeroPercentUpdate; // (1) Data corr. for old purch vat book
        //UpdateINVatentryData; // (2)
        UpdateINVatentryLocalPurchase; // (3)
        //UpdateSalesCrMemoMaterializeView;
        MESSAGE('Success');
    end;

    var
        item: Record Item;
        "count": Integer;
        customer: Record Customer;
        itemUOM: Record "Item Unit of Measure";
        defaultdimension: Record "Default Dimension";
        glsetup: Record "General Ledger Setup";
        itemjournalline: Record "Item Journal Line";
        productwisesalesperson: Record "Product&Salesperson Posting Gr";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Text000: Label 'Total Count #1########### \Processing #2##########\Modifying #3###########';
        DetailedCustLedger: Record "Detailed Cust. Ledg. Entry";
        InvoiceMatView: Record "Invoice Materialize View";
        Window: Dialog;
        TotalCount: Integer;
        VatEntry: Record "VAT Entry";
        ILE: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        GLEntry: Record "G/L Entry";
        ProgressWindow: Dialog;
        ProcessingCount: Integer;
        ModifyCount: Integer;
        TDSEntry: Record "TDS Entry";
        PurchInvLine: Record "Purch. Inv. Line";
        counttotal: Integer;
        PurchaseHdr: Record "Purchase Header";
        Vendor: Record Vendor;

    [Scope('OnPrem')]
    procedure DefaultDimensionPopulate()
    begin
        defaultdimension.RESET;
        defaultdimension.SETRANGE("Table ID", 27);
        defaultdimension.SETFILTER("Dimension Value Code", '%1|%2|%3|%4', 'ALISHAAN', 'BIKANO', 'TIFFANY');
        IF defaultdimension.FINDFIRST THEN
            REPEAT
                defaultdimension.VALIDATE("Dimension Value Code", 'FOODS');
                defaultdimension.MODIFY;
                item.RESET;
                item.SETRANGE("No.", defaultdimension."No.");
                IF item.FINDFIRST THEN BEGIN
                    item.VALIDATE("Global Dimension 1 Code", defaultdimension."Dimension Value Code");
                    item.MODIFY;
                END;
            UNTIL defaultdimension.NEXT = 0;
    end;

    local procedure AssignPurchandSalesUOMinItem()
    begin
        count := 0;
        item.RESET;
        IF item.FINDFIRST THEN
            REPEAT
                item."Purch. Unit of Measure" := item."Base Unit of Measure";
                item."Sales Unit of Measure" := item."Base Unit of Measure";
                item.MODIFY;
                count += 1;
            UNTIL item.NEXT = 0;
        MESSAGE('%1 records modified successfully', count);
    end;

    local procedure AssignPragyapanPatra()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchInvHeader.RESET;
        PurchInvHeader.SETRANGE("No.", 'PPCM74/75-00003');
        IF PurchInvHeader.FINDFIRST THEN BEGIN
            PurchInvHeader."Letter of Credit/Telex Trans." := 'L /C # EB0011FOU00818';
            PurchInvHeader.MODIFY;
            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
            IF PurchInvLine.FINDFIRST THEN
                REPEAT
                    IF PurchInvLine.Type = PurchInvLine.Type::"G/L Account" THEN
                        PurchInvLine."Letter of Credit/Telex Trans." := PurchInvHeader."Letter of Credit/Telex Trans.";
                    PurchInvLine.MODIFY;
                UNTIL PurchInvLine.NEXT = 0;
            /*ItemLedgEntry.RESET;
            ItemLedgEntry.SETRANGE("Document No.",PurchRcptHdr."No.");
            IF ItemLedgEntry.FINDFIRST THEN REPEAT
              ItemLedgEntry."Posting Date" := PurchInvHeader."Posting Date";
              ItemLedgEntry.MODIFY;
            UNTIL ItemLedgEntry.NEXT = 0;*/
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
            GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
            IF GLEntry.FINDFIRST THEN
                REPEAT
                    GLEntry."Letter of Credit/Telex Trans." := PurchInvHeader."Letter of Credit/Telex Trans.";
                    GLEntry.MODIFY;
                UNTIL GLEntry.NEXT = 0;

            VendLedgEntry.RESET;
            VendLedgEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                VendLedgEntry."Letter of Credit/Telex Trans." := GLEntry."Letter of Credit/Telex Trans.";
                VendLedgEntry.MODIFY;
            END;

            DetailedVendLedgEntry.RESET;
            DetailedVendLedgEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF DetailedVendLedgEntry.FINDFIRST THEN BEGIN
                DetailedVendLedgEntry."Letter of Credit/Telex Trans." := PurchInvHeader."Letter of Credit/Telex Trans.";
                DetailedVendLedgEntry.MODIFY;
            END;

            ValueEntry.RESET;
            ValueEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF ValueEntry.FINDFIRST THEN
                REPEAT
                    ValueEntry."Letter of Credit/Telex Trans." := PurchInvHeader."Letter of Credit/Telex Trans.";
                    ValueEntry.MODIFY;
                UNTIL ValueEntry.NEXT = 0;

            VATEntry.RESET;
            VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VATEntry.FINDFIRST THEN
                REPEAT
                    VATEntry."Letter of Credit/Telex Trans." := PurchInvHeader."Letter of Credit/Telex Trans.";
                    VATEntry.MODIFY;
                UNTIL VATEntry.NEXT = 0;
            MESSAGE('Executed Successfully');
        END;

    end;

    local procedure DimensionCorrection()
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        VATEntry: Record "VAT Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ValueEntry: Record "Value Entry";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesInvHdr.RESET;
        SalesInvHdr.SETRANGE("No.", 'SPI75/76-01940');
        IF SalesInvHdr.FINDFIRST THEN BEGIN
            MESSAGE(FORMAT(SalesInvHdr."Dimension Set ID"));
            SalesCrMemoHdr.RESET;
            SalesCrMemoHdr.SETRANGE("No.", 'SPCM75/76-00069');
            IF SalesCrMemoHdr.FINDFIRST THEN BEGIN
                SalesCrMemoHdr."Inventory Posting Group" := SalesInvHdr."Inventory Posting Group";
                SalesCrMemoHdr."Dimension Set ID" := SalesInvHdr."Dimension Set ID";
                SalesCrMemoHdr."Shortcut Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                SalesCrMemoHdr."Shortcut Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                SalesCrMemoHdr.MODIFY;
                SalesCrMemoLine.RESET;
                SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdr."No.");
                SalesCrMemoLine.SETFILTER(Quantity, '>%1', 0);
                IF SalesCrMemoLine.FINDFIRST THEN
                    REPEAT
                        SalesCrMemoLine."Dimension Set ID" := SalesCrMemoHdr."Dimension Set ID";
                        SalesCrMemoLine."Shortcut Dimension 1 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                        SalesCrMemoLine."Shortcut Dimension 2 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                        SalesCrMemoLine.MODIFY;
                    UNTIL SalesCrMemoLine.NEXT = 0;
            END;
            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE("Document No.", SalesCrMemoHdr."No.");
            IF CustLedgEntry.FINDFIRST THEN BEGIN
                CustLedgEntry."Dimension Set ID" := SalesCrMemoHdr."Dimension Set ID";
                CustLedgEntry."Global Dimension 1 Code" := SalesCrMemoHdr."Shortcut Dimension 1 Code";
                CustLedgEntry."Global Dimension 2 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                CustLedgEntry.MODIFY;
            END;
            DetailedCustLedgEntry.RESET;
            DetailedCustLedgEntry.SETRANGE("Document No.", SalesCrMemoHdr."No.");
            IF DetailedCustLedgEntry.FINDFIRST THEN
                REPEAT
                    DetailedCustLedgEntry."Initial Entry Global Dim. 1" := SalesCrMemoHdr."Shortcut Dimension 1 Code";
                    DetailedCustLedgEntry."Initial Entry Global Dim. 2" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                    DetailedCustLedgEntry.MODIFY;
                UNTIL DetailedCustLedgEntry.NEXT = 0;
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", SalesCrMemoHdr."No.");
            IF GLEntry.FINDFIRST THEN
                REPEAT
                    GLEntry."Dimension Set ID" := SalesCrMemoHdr."Dimension Set ID";
                    GLEntry."Global Dimension 1 Code" := SalesCrMemoHdr."Shortcut Dimension 1 Code";
                    GLEntry."Global Dimension 2 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                    GLEntry.MODIFY;
                UNTIL GLEntry.NEXT = 0;
            ValueEntry.RESET;
            ValueEntry.SETRANGE("Document No.", SalesCrMemoHdr."No.");
            IF ValueEntry.FINDFIRST THEN
                REPEAT
                    ValueEntry."Dimension Set ID" := SalesCrMemoHdr."Dimension Set ID";
                    ValueEntry."Global Dimension 1 Code" := SalesCrMemoHdr."Shortcut Dimension 1 Code";
                    ValueEntry."Global Dimension 2 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                    ValueEntry.MODIFY;
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                    IF ItemLedgEntry.FINDFIRST THEN
                        REPEAT
                            ItemLedgEntry."Dimension Set ID" := SalesCrMemoHdr."Dimension Set ID";
                            ItemLedgEntry."Global Dimension 1 Code" := SalesCrMemoHdr."Shortcut Dimension 1 Code";
                            ItemLedgEntry."Global Dimension 2 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                            ItemLedgEntry.MODIFY;
                        UNTIL ItemLedgEntry.NEXT = 0;
                UNTIL ValueEntry.NEXT = 0;
        END;
    end;

    local procedure PostingDateCorrection()
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        VATEntry: Record "VAT Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ValueEntry: Record "Value Entry";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesInvHdr.RESET;
        SalesInvHdr.SETFILTER("No.", 'SPI75/76-01690');
        IF SalesInvHdr.FINDFIRST THEN
            REPEAT
                SalesInvHdr."Inventory Posting Group" := 'BIKANO';
                SalesInvHdr."Dimension Set ID" := 1170;
                SalesInvHdr."Shortcut Dimension 1 Code" := 'FOODS';
                SalesInvHdr."Shortcut Dimension 2 Code" := 'SANGITA';
                SalesInvHdr.MODIFY;
                SalesInvLine.RESET;
                SalesInvLine.SETRANGE("Document No.", SalesInvHdr."No.");
                IF SalesInvLine.FINDFIRST THEN
                    REPEAT
                        SalesInvLine."Dimension Set ID" := SalesInvHdr."Dimension Set ID";
                        SalesInvLine."Shortcut Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                        SalesInvLine."Shortcut Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                        SalesInvLine.MODIFY;
                    UNTIL SalesInvLine.NEXT = 0;
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", SalesInvHdr."No.");
                IF ValueEntry.FINDFIRST THEN
                    REPEAT
                        ValueEntry."Dimension Set ID" := SalesInvHdr."Dimension Set ID";
                        ValueEntry."Global Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                        ValueEntry."Global Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                        ValueEntry.MODIFY;
                        ItemLedgEntry.RESET;
                        ItemLedgEntry.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                        IF ItemLedgEntry.FINDFIRST THEN
                            REPEAT
                                ItemLedgEntry."Dimension Set ID" := SalesInvHdr."Dimension Set ID";
                                ItemLedgEntry."Global Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                                ItemLedgEntry."Global Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                                ItemLedgEntry.MODIFY;
                            UNTIL ItemLedgEntry.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", SalesInvHdr."No.");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        GLEntry."Dimension Set ID" := SalesInvHdr."Dimension Set ID";
                        GLEntry."Global Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                        GLEntry."Global Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                CustLedgEntry.RESET;
                CustLedgEntry.SETRANGE("Document No.", SalesInvHdr."No.");
                IF CustLedgEntry.FINDFIRST THEN BEGIN
                    CustLedgEntry."Dimension Set ID" := SalesInvHdr."Dimension Set ID";
                    CustLedgEntry."Global Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                    CustLedgEntry."Global Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                    CustLedgEntry.MODIFY;
                END;
                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", SalesInvHdr."No.");
                IF DetailedCustLedgEntry.FINDFIRST THEN BEGIN
                    DetailedCustLedgEntry."Initial Entry Global Dim. 1" := SalesInvHdr."Shortcut Dimension 1 Code";
                    DetailedCustLedgEntry."Initial Entry Global Dim. 2" := SalesInvHdr."Shortcut Dimension 2 Code";
                    DetailedCustLedgEntry.MODIFY;
                END;
            UNTIL SalesInvHdr.NEXT = 0;
    end;

    local procedure DocumentNoCorrection()
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLEntry: Record "G/L Entry";
        DocNo: Code[30];
        NextDocNo: Code[30];
        DocNo1: Code[30];
        DocNo2: Code[30];
        DocNo3: Code[30];
    begin
        DocNo := 'BANKTR73/74-BOK-0050';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '225877|225879|225881|225883|225885|225887|225889|225891|225893|225895|225897|225899|225901|225903|225905|225907|225909|225911|225913|225915|225917|225919|225921|225923|225925|225927|225929|225931|225933|225935|225937'
        );
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-BOK-0081';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '225939|228610|228612');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-BOK-0050';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '225876|225878|225880|225882|225884|225886|225888|225890|225892|225894|225896|225898|225900|225902|225904|225906|225908|225910|225912|225914|225916|225918|225920|225922|225924|225926|225928|225930|225932|225934|225936'
        );
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-BOK-0081';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '225938|228609|228611');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-NIB-0015';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '226497|226499|226501|226503|226505|226507|226509|226511|226513|226515|226517|226519|226521|226523|226525|226527|226529');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-NIB-0015';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '226496|226498|226500|226502|226504|226506|226508|226510|226512|226514|226516|226518|226520|226522|226524|226526|226528');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-SBI-0016';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '226785|226787|226789|226791|226793|226795|226797|226799|226801|226803|226805|226807|226809|226811|226813|226815|226817|226819|226821|226823|226825|230117');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';

        DocNo := 'BANKTR73/74-SBI-0016';
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '226784|226786|226788|226790|226792|226794|226796|226798|226800|226802|226804|226806|226808|226810|226812|226814|226816|226818|226820|226822|226824|230116');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                NextDocNo := INCSTR(DocNo);
                GLEntry."Document No." := INCSTR(DocNo);
                GLEntry.MODIFY;
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Entry No.", GLEntry."Entry No.");
                IF BankAccLedgEntry.FINDFIRST THEN BEGIN
                    BankAccLedgEntry."Document No." := GLEntry."Document No.";
                    BankAccLedgEntry.MODIFY;
                END;
                DocNo := NextDocNo;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Next Document No. : %1', NextDocNo);
        DocNo := '';
        NextDocNo := '';
    end;

    [Scope('OnPrem')]
    procedure PopulateEmployeeCode()
    var
        GLEntry: Record "G/L Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        GLEntry.RESET;
        IF GLEntry.FINDFIRST THEN
            REPEAT
                DimensionSetEntry.RESET;
                DimensionSetEntry.SETRANGE("Dimension Set ID", GLEntry."Dimension Set ID");
                IF DimensionSetEntry.FINDFIRST THEN
                    REPEAT
                        IF DimensionSetEntry."Dimension Code" = 'EMPLOYEE' THEN BEGIN
                            GLEntry."Employee Code" := DimensionSetEntry."Dimension Value Code";
                            GLEntry.MODIFY;
                        END;
                    UNTIL DimensionSetEntry.NEXT = 0;
            UNTIL GLEntry.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure InsertRecIntoSalesPersonFromDimVal()
    var
        DimVal: Record "Dimension Value";
        SalespersonCode: Record "Salesperson/Purchaser";
        GLSetup: Record "General Ledger Setup";
        ProductWiseSalesPerson: Record "Product&Salesperson Posting Gr";
    begin
        GLSetup.GET;
        DimVal.SETRANGE("Dimension Code", GLSetup."Global Dimension 2 Code");
        IF DimVal.FINDFIRST THEN
            REPEAT
                SalespersonCode.RESET;
                SalespersonCode.SETRANGE(Code, DimVal.Code);
                IF NOT SalespersonCode.FINDFIRST THEN BEGIN
                    SalespersonCode.INIT;
                    SalespersonCode.Code := DimVal.Code;
                    SalespersonCode.Name := DimVal.Name;
                    SalespersonCode.INSERT;
                END;
            UNTIL DimVal.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure UnapplyAllVendLedgEntries()
    var
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DocNo: Code[30];
        PostingDate: Date;
        Window: Dialog;
        TotalCount: Integer;
    begin
        Window.OPEN(Text000);
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Entry No.");
        VendLedgEntry.SETASCENDING("Entry No.", FALSE);
        VendLedgEntry.SETRANGE(Reversed, FALSE);
        VendLedgEntry.SETFILTER("Entry No.", '<>%1|<>%2', 543634, 543649);
        Window.UPDATE(2, VendLedgEntry.COUNT);
        IF VendLedgEntry.FINDFIRST THEN
            REPEAT
                TotalCount += 1;
                Window.UPDATE(1, TotalCount);
                //VendEntryApplyPostedEntries.UnApplyVendLedgEntry(VendLedgEntry."Entry No.");
                DtldVendLedgEntry.RESET;
                DtldVendLedgEntry.SETCURRENTKEY("Entry No.");
                DtldVendLedgEntry.SETASCENDING("Entry No.", FALSE);
                DtldVendLedgEntry.SETRANGE("Document No.", VendLedgEntry."Document No.");
                DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
                DtldVendLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
                DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);
                IF DtldVendLedgEntry.FINDSET THEN BEGIN
                    VendEntryApplyPostedEntries.PostUnApplyVendor(DtldVendLedgEntry, DtldVendLedgEntry."Document No.", DtldVendLedgEntry."Posting Date");
                END;
            UNTIL VendLedgEntry.NEXT = 0;
        Window.CLOSE;
    end;

    [Scope('OnPrem')]
    procedure UpdateDimensionsonInvMatView()
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        InvMatView: Record "Invoice Materialize View";
    begin
        InvMatView.RESET;
        InvMatView.SETRANGE("Document Type", InvMatView."Document Type"::"Sales Invoice");
        IF InvMatView.FINDFIRST THEN
            REPEAT
                IF SalesInvHdr.GET(InvMatView."Bill No") THEN BEGIN
                    InvMatView."Shortcut Dimension 1 Code" := SalesInvHdr."Shortcut Dimension 1 Code";
                    InvMatView."Shortcut Dimension 2 Code" := SalesInvHdr."Shortcut Dimension 2 Code";
                    InvMatView.MODIFY;
                END;
            UNTIL InvMatView.NEXT = 0;
        MESSAGE('Dimension Updated in Invoice');

        InvMatView.RESET;
        InvMatView.SETRANGE("Document Type", InvMatView."Document Type"::"Sales Credit Memo");
        IF InvMatView.FINDFIRST THEN
            REPEAT
                IF SalesCrMemoHdr.GET(InvMatView."Bill No") THEN BEGIN
                    InvMatView."Shortcut Dimension 1 Code" := SalesCrMemoHdr."Shortcut Dimension 1 Code";
                    InvMatView."Shortcut Dimension 2 Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
                    InvMatView.MODIFY;
                END;
            UNTIL InvMatView.NEXT = 0;
        MESSAGE('Dimension Updated in returns');
    end;

    local procedure AssignPragyapanPatra1()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        AlLCustVendLedger: Record "Cust-Vend Ledger";
        Correctvendor: Record Vendor;
    begin
        /*PPI76/77-02277|PPI76/77-02286
         - v00239 - cash on hand
        replace with
         - v00216 - adhikari clearing and forwardding*/

        PurchInvHeader.RESET;
        PurchInvHeader.SETRANGE("No.", 'PPI76/77-02286');
        IF PurchInvHeader.FINDFIRST THEN BEGIN
            Correctvendor.GET('V00216');
            PurchInvHeader."Buy-from Vendor No." := Correctvendor."No.";
            PurchInvHeader."Buy-from Vendor Name" := Correctvendor.Name;
            PurchInvHeader."Buy-from Vendor Name 2" := Correctvendor."Name 2";
            PurchInvHeader."Buy-from Address" := Correctvendor.Address;
            PurchInvHeader."Buy-from Address 2" := Correctvendor."Address 2";
            PurchInvHeader."Pay-to Vendor No." := Correctvendor."No.";
            PurchInvHeader."Pay-to Name" := Correctvendor.Name;
            PurchInvHeader."Pay-to Name 2" := Correctvendor."Name 2";
            PurchInvHeader."Pay-to Address" := Correctvendor.Address;
            PurchInvHeader."Pay-to Address 2" := Correctvendor."Address 2";
            PurchInvHeader."Gen. Bus. Posting Group" := Correctvendor."Gen. Bus. Posting Group";
            PurchInvHeader."VAT Bus. Posting Group" := Correctvendor."VAT Bus. Posting Group";
            PurchInvHeader."VAT Registration No." := Correctvendor."VAT Registration No.";
            PurchInvHeader.MODIFY;

            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
            IF PurchInvLine.FINDFIRST THEN
                REPEAT
                    PurchInvLine."Buy-from Vendor No." := Correctvendor."No.";
                    PurchInvLine."Pay-to Vendor No." := Correctvendor."No.";
                    PurchInvLine.MODIFY;
                UNTIL PurchInvLine.NEXT = 0;
            PurchRcptHdr.RESET;
            PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
            IF PurchRcptHdr.FINDFIRST THEN BEGIN
                PurchRcptHdr."Buy-from Vendor No." := Correctvendor."No.";
                PurchRcptHdr."Buy-from Vendor Name" := Correctvendor.Name;
                PurchRcptHdr."Buy-from Vendor Name 2" := Correctvendor."Name 2";
                PurchRcptHdr."Buy-from Address" := Correctvendor.Address;
                PurchRcptHdr."Buy-from Address 2" := Correctvendor."Address 2";
                PurchRcptHdr."Pay-to Vendor No." := Correctvendor."No.";
                PurchRcptHdr."Pay-to Name" := Correctvendor.Name;
                PurchRcptHdr."Pay-to Name 2" := Correctvendor."Name 2";
                PurchRcptHdr."Pay-to Address" := Correctvendor.Address;
                PurchRcptHdr."Pay-to Address 2" := Correctvendor."Address 2";
                PurchRcptHdr."Gen. Bus. Posting Group" := Correctvendor."Gen. Bus. Posting Group";
                PurchRcptHdr."VAT Bus. Posting Group" := Correctvendor."VAT Bus. Posting Group";
                PurchRcptHdr."VAT Registration No." := Correctvendor."VAT Registration No.";
                PurchRcptHdr.MODIFY;

                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                IF PurchRcptLine.FINDFIRST THEN
                    REPEAT
                        PurchRcptLine."Buy-from Vendor No." := Correctvendor."No.";
                        PurchRcptLine."Pay-to Vendor No." := Correctvendor."No.";
                        PurchRcptLine.MODIFY;
                    UNTIL PurchRcptLine.NEXT = 0;
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETRANGE("Document No.", PurchRcptHdr."No.");
                IF ItemLedgEntry.FINDFIRST THEN
                    REPEAT
                        ItemLedgEntry."Source No." := Correctvendor."No.";
                        ItemLedgEntry.MODIFY;
                    UNTIL ItemLedgEntry.NEXT = 0;
            END;

            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
            //GLEntry.SETRANGE("Document Type",GLEntry."Document Type"::Invoice);
            IF GLEntry.FINDFIRST THEN
                REPEAT
                    IF GLEntry."Source Type" = GLEntry."Source Type"::Vendor THEN BEGIN
                        GLEntry."Source No." := Correctvendor."No.";
                        GLEntry.MODIFY;
                    END;
                    IF GLEntry."Entry No." = 2090237 THEN BEGIN
                        GLEntry."G/L Account No." := '3214100';
                        GLEntry.MODIFY;
                    END;
                UNTIL GLEntry.NEXT = 0;

            VendLedgEntry.RESET;
            VendLedgEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                VendLedgEntry."Vendor No." := Correctvendor."No.";
                VendLedgEntry."Vendor Name" := Correctvendor.Name;
                VendLedgEntry."Vendor Posting Group" := Correctvendor."Vendor Posting Group";
                VendLedgEntry."Buy-from Vendor No." := Correctvendor."No.";
                VendLedgEntry.MODIFY;
            END;

            DetailedVendLedgEntry.RESET;
            DetailedVendLedgEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF DetailedVendLedgEntry.FINDFIRST THEN BEGIN
                DetailedVendLedgEntry."Vendor No." := Correctvendor."No.";
                DetailedVendLedgEntry.MODIFY;
            END;

            ValueEntry.RESET;
            ValueEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF ValueEntry.FINDFIRST THEN
                REPEAT
                    IF ValueEntry."Source Type" = ValueEntry."Source Type"::Vendor THEN BEGIN
                        ValueEntry."Source No." := Correctvendor."No.";
                        ValueEntry."Source Posting Group" := Correctvendor."Vendor Posting Group";
                        ValueEntry.MODIFY;
                    END;
                UNTIL ValueEntry.NEXT = 0;

            VATEntry.RESET;
            VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VATEntry.FINDFIRST THEN
                REPEAT
                    VATEntry."Bill-to/Pay-to No." := Correctvendor."No.";
                    VATEntry.MODIFY;
                UNTIL VATEntry.NEXT = 0;

            AlLCustVendLedger.RESET;
            AlLCustVendLedger.SETRANGE("Document No.", PurchInvHeader."No.");
            IF AlLCustVendLedger.FINDFIRST THEN BEGIN
                AlLCustVendLedger."Party No." := Correctvendor."No.";
                AlLCustVendLedger."Party Name" := Correctvendor.Name;
                AlLCustVendLedger.MODIFY;
            END;
            MESSAGE('Executed Successfully');
        END;

    end;

    [Scope('OnPrem')]
    procedure UpdateGLEntryGLAccNo()
    var
        GLEntry: Record "G/L Entry";
        TempUpdateTable: Record "TDS Posting Group";
    begin
        Window.OPEN(Text000);
        TempUpdateTable.RESET;
        Window.UPDATE(2, TempUpdateTable.COUNT);
        TempUpdateTable.SETFILTER("GL Account No.", '<>%1', '');
        IF TempUpdateTable.FINDFIRST THEN
            REPEAT
                IF GLEntry.GET(TempUpdateTable.Code) THEN BEGIN
                    GLEntry."G/L Account No." := TempUpdateTable."GL Account No.";
                    GLEntry.MODIFY;
                    TotalCount += 1;
                    Window.UPDATE(1, TotalCount);
                END;
            UNTIL TempUpdateTable.NEXT = 0;
    end;

    local procedure UpdateVATBaseInPurchaseCreditMemoDoc()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchInvHeader.RESET;
        PurchInvHeader.SETRANGE("No.", 'PPCM76/77-00002');
        IF PurchInvHeader.FINDFIRST THEN BEGIN
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
            GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
            GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
            IF GLEntry.FINDFIRST THEN
                REPEAT
                    GLEntry."VAT Base 1" := PurchInvHeader."VAT Base 1";
                    GLEntry.MODIFY;
                UNTIL GLEntry.NEXT = 0;

            VATEntry.RESET;
            VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VATEntry.FINDFIRST THEN
                REPEAT
                    VATEntry."VAT Base 1" := -PurchInvHeader."VAT Base 1";
                    VATEntry.MODIFY;
                UNTIL VATEntry.NEXT = 0;
            MESSAGE('Executed Successfully');
        END;
    end;

    local procedure UpdateMainGLAccTDSEntry()
    var
        TDSEntry: Record "TDS Entry";
        GLEntry: Record "G/L Entry";
    begin
        ProgressWindow.OPEN(Text000);
        TDSEntry.RESET;
        TDSEntry.SETFILTER("Main G/L Account", '');
        ProgressWindow.UPDATE(1, TDSEntry.COUNT);
        IF TDSEntry.FINDFIRST THEN
            REPEAT
                ProcessingCount += 1;
                GLEntry.RESET;
                GLEntry.SETRANGE("Transaction No.", TDSEntry."Transaction No.");
                GLEntry.SETFILTER("Debit Amount", '<>%1', 0);
                GLEntry.SETFILTER("Gen. Posting Type", '<>%1', GLEntry."Gen. Posting Type"::" ");
                IF GLEntry.FINDFIRST THEN BEGIN
                    TDSEntry."Main G/L Account" := GLEntry."G/L Account No.";
                    TDSEntry.MODIFY;
                    ModifyCount += 1;
                END;
                ProgressWindow.UPDATE(2, ProcessingCount);
                ProgressWindow.UPDATE(3, ModifyCount);
            UNTIL TDSEntry.NEXT = 0;
    end;

    local procedure UpdateGLAcc()
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.", '2128521|2137355|2138296|2140023|2144327|2172344');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                GLEntry."G/L Account No." := '5131100';
                GLEntry.MODIFY;
            UNTIL GLEntry.NEXT = 0;
    end;

    local procedure CorrectLoclizedVATIdentifier()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        AlLCustVendLedger: Record "Cust-Vend Ledger";
        Correctvendor: Record Vendor;
        ChangeLogSetup: Record "Change Log Setup";
    begin
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;

        PurchInvHeader.RESET;
        PurchInvHeader.SETFILTER("No.", 'PPI77/78-01740|PPI77/78-01712|PPI77/78-01673|PPI77/78-01601');
        IF PurchInvHeader.FINDFIRST THEN
            REPEAT
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                IF PurchInvLine.FINDFIRST THEN
                    REPEAT
                        PurchInvLine."Localized VAT Identifier" := PurchInvLine."Localized VAT Identifier"::"Taxable Local Purchase";
                        PurchInvLine.MODIFY;
                    UNTIL PurchInvLine.NEXT = 0;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
                IF PurchRcptHdr.FINDFIRST THEN BEGIN
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            PurchRcptLine."Localized VAT Identifier" := PurchRcptLine."Localized VAT Identifier"::"Taxable Local Purchase";
                            PurchRcptLine.MODIFY;
                        UNTIL PurchRcptLine.NEXT = 0;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
                GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        GLEntry."Localized VAT Identifier" := GLEntry."Localized VAT Identifier"::"Taxable Local Purchase";
                        IF GLEntry."G/L Account No." = '2262200' THEN
                            GLEntry."G/L Account No." := '2262100';
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        VATEntry."Localized VAT Identifier" := VATEntry."Localized VAT Identifier"::"Taxable Local Purchase";
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0;

                MESSAGE('Executed Successfully');
            UNTIL PurchInvHeader.NEXT = 0;

        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
    end;

    local procedure UpdatePurchaseDoc()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        AlLCustVendLedger: Record "Cust-Vend Ledger";
        Correctvendor: Record Vendor;
    begin
        /*PPI76/77-02277|PPI76/77-02286
         - v00239 - cash on hand
        replace with
         - v00216 - adhikari clearing and forwardding*/

        PurchInvHeader.RESET;
        PurchInvHeader.SETRANGE("No.", 'PPI76/77-02286');
        IF PurchInvHeader.FINDFIRST THEN BEGIN
            Correctvendor.GET('V00216');
            PurchInvHeader."Buy-from Vendor No." := Correctvendor."No.";
            PurchInvHeader."Buy-from Vendor Name" := Correctvendor.Name;
            PurchInvHeader."Buy-from Vendor Name 2" := Correctvendor."Name 2";
            PurchInvHeader."Buy-from Address" := Correctvendor.Address;
            PurchInvHeader."Buy-from Address 2" := Correctvendor."Address 2";
            PurchInvHeader."Pay-to Vendor No." := Correctvendor."No.";
            PurchInvHeader."Pay-to Name" := Correctvendor.Name;
            PurchInvHeader."Pay-to Name 2" := Correctvendor."Name 2";
            PurchInvHeader."Pay-to Address" := Correctvendor.Address;
            PurchInvHeader."Pay-to Address 2" := Correctvendor."Address 2";
            PurchInvHeader."Gen. Bus. Posting Group" := Correctvendor."Gen. Bus. Posting Group";
            PurchInvHeader."VAT Bus. Posting Group" := Correctvendor."VAT Bus. Posting Group";
            PurchInvHeader."VAT Registration No." := Correctvendor."VAT Registration No.";
            PurchInvHeader.MODIFY;

            PurchInvLine.RESET;
            PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
            IF PurchInvLine.FINDFIRST THEN
                REPEAT
                    PurchInvLine."Buy-from Vendor No." := Correctvendor."No.";
                    PurchInvLine."Pay-to Vendor No." := Correctvendor."No.";
                    PurchInvLine.MODIFY;
                UNTIL PurchInvLine.NEXT = 0;
            PurchRcptHdr.RESET;
            PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
            IF PurchRcptHdr.FINDFIRST THEN BEGIN
                PurchRcptHdr."Buy-from Vendor No." := Correctvendor."No.";
                PurchRcptHdr."Buy-from Vendor Name" := Correctvendor.Name;
                PurchRcptHdr."Buy-from Vendor Name 2" := Correctvendor."Name 2";
                PurchRcptHdr."Buy-from Address" := Correctvendor.Address;
                PurchRcptHdr."Buy-from Address 2" := Correctvendor."Address 2";
                PurchRcptHdr."Pay-to Vendor No." := Correctvendor."No.";
                PurchRcptHdr."Pay-to Name" := Correctvendor.Name;
                PurchRcptHdr."Pay-to Name 2" := Correctvendor."Name 2";
                PurchRcptHdr."Pay-to Address" := Correctvendor.Address;
                PurchRcptHdr."Pay-to Address 2" := Correctvendor."Address 2";
                PurchRcptHdr."Gen. Bus. Posting Group" := Correctvendor."Gen. Bus. Posting Group";
                PurchRcptHdr."VAT Bus. Posting Group" := Correctvendor."VAT Bus. Posting Group";
                PurchRcptHdr."VAT Registration No." := Correctvendor."VAT Registration No.";
                PurchRcptHdr.MODIFY;

                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                IF PurchRcptLine.FINDFIRST THEN
                    REPEAT
                        PurchRcptLine."Buy-from Vendor No." := Correctvendor."No.";
                        PurchRcptLine."Pay-to Vendor No." := Correctvendor."No.";
                        PurchRcptLine.MODIFY;
                    UNTIL PurchRcptLine.NEXT = 0;
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETRANGE("Document No.", PurchRcptHdr."No.");
                IF ItemLedgEntry.FINDFIRST THEN
                    REPEAT
                        ItemLedgEntry."Source No." := Correctvendor."No.";
                        ItemLedgEntry.MODIFY;
                    UNTIL ItemLedgEntry.NEXT = 0;
            END;

            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
            //GLEntry.SETRANGE("Document Type",GLEntry."Document Type"::Invoice);
            IF GLEntry.FINDFIRST THEN
                REPEAT
                    IF GLEntry."Source Type" = GLEntry."Source Type"::Vendor THEN BEGIN
                        GLEntry."Source No." := Correctvendor."No.";
                        GLEntry.MODIFY;
                    END;
                    IF GLEntry."Entry No." = 2090237 THEN BEGIN
                        GLEntry."G/L Account No." := '3214100';
                        GLEntry.MODIFY;
                    END;
                UNTIL GLEntry.NEXT = 0;

            VendLedgEntry.RESET;
            VendLedgEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VendLedgEntry.FINDFIRST THEN BEGIN
                VendLedgEntry."Vendor No." := Correctvendor."No.";
                VendLedgEntry."Vendor Name" := Correctvendor.Name;
                VendLedgEntry."Vendor Posting Group" := Correctvendor."Vendor Posting Group";
                VendLedgEntry."Buy-from Vendor No." := Correctvendor."No.";
                VendLedgEntry.MODIFY;
            END;

            DetailedVendLedgEntry.RESET;
            DetailedVendLedgEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF DetailedVendLedgEntry.FINDFIRST THEN BEGIN
                DetailedVendLedgEntry."Vendor No." := Correctvendor."No.";
                DetailedVendLedgEntry.MODIFY;
            END;

            ValueEntry.RESET;
            ValueEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF ValueEntry.FINDFIRST THEN
                REPEAT
                    IF ValueEntry."Source Type" = ValueEntry."Source Type"::Vendor THEN BEGIN
                        ValueEntry."Source No." := Correctvendor."No.";
                        ValueEntry."Source Posting Group" := Correctvendor."Vendor Posting Group";
                        ValueEntry.MODIFY;
                    END;
                UNTIL ValueEntry.NEXT = 0;

            VATEntry.RESET;
            VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
            IF VATEntry.FINDFIRST THEN
                REPEAT
                    VATEntry."Bill-to/Pay-to No." := Correctvendor."No.";
                    VATEntry.MODIFY;
                UNTIL VATEntry.NEXT = 0;

            AlLCustVendLedger.RESET;
            AlLCustVendLedger.SETRANGE("Document No.", PurchInvHeader."No.");
            IF AlLCustVendLedger.FINDFIRST THEN BEGIN
                AlLCustVendLedger."Party No." := Correctvendor."No.";
                AlLCustVendLedger."Party Name" := Correctvendor.Name;
                AlLCustVendLedger.MODIFY;
            END;
            MESSAGE('Executed Successfully');
        END;

    end;

    local procedure UpdateSalesLCY()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VATEntry: Record "VAT Entry";
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETFILTER("Document No.", 'CN76/77-0253..CN76/77-0292');
        CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::"Credit Memo");
        CustLedgEntry.SETFILTER("Sales (LCY)", '%1', 0);
        IF CustLedgEntry.FINDFIRST THEN
            REPEAT
                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", CustLedgEntry."Document No.");
                VATEntry.CALCSUMS(Base);
                CustLedgEntry."Sales (LCY)" := -VATEntry.Base;
                CustLedgEntry.MODIFY;
            UNTIL CustLedgEntry.NEXT = 0;
    end;

    local procedure UpdateSalesPersonTemp()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnl: Record "Gen. Journal Line";
        ValueEntry: Record "Value Entry";
        ILE: Record "Item Ledger Entry";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemo: Record "Sales Cr.Memo Header";
    begin
        /*GenJnl.RESET;
        GenJnl.SETFILTER("Shortcut Dimension 2 Code",'<>%1','');
        IF GenJnl.FINDFIRST THEN REPEAT
          GenJnl."Salespers./Purch. Code" := GenJnl."Shortcut Dimension 2 Code";
          GenJnl.MODIFY;
        UNTIL GenJnl.NEXT = 0;
        ProcessingCount := 0;
        ModifyCount := 0;
        ProgressWindow.OPEN(Text000);
        
        CustLedgEntry.RESET;
        CustLedgEntry.SETFILTER("Global Dimension 2 Code",'<>%1','');
        CustLedgEntry.SETFILTER("Salesperson Code",'');
        ProgressWindow.UPDATE(1,CustLedgEntry.COUNT);
        IF CustLedgEntry.FINDFIRST THEN REPEAT
          ProcessingCount += 1;
          CustLedgEntry."Salesperson Code" := CustLedgEntry."Global Dimension 2 Code";
          CustLedgEntry.MODIFY;
          ModifyCount += 1;
          ProgressWindow.UPDATE(2,ProcessingCount);
          ProgressWindow.UPDATE(3,ModifyCount);
        UNTIL CustLedgEntry.NEXT = 0;*/

        ProgressWindow.OPEN(Text000);
        ValueEntry.RESET;
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ProgressWindow.UPDATE(1, ValueEntry.COUNT);
        IF ValueEntry.FINDFIRST THEN
            REPEAT
                ProcessingCount += 1;
                IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" THEN BEGIN
                    SalesInvHdr.GET(ValueEntry."Document No.");
                    SalesInvHdr."Salesperson Code" := 'BRD';
                    SalesInvHdr.MODIFY;
                    ValueEntry."Salespers./Purch. Code" := SalesInvHdr."Salesperson Code";
                    ValueEntry.MODIFY;
                END ELSE
                    IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Credit Memo" THEN BEGIN
                        SalesCrMemo.GET(ValueEntry."Document No.");
                        ValueEntry."Salespers./Purch. Code" := SalesCrMemo."Salesperson Code";
                        ValueEntry.MODIFY;
                    END;
                ILE.GET(ValueEntry."Item Ledger Entry No.");
                ILE."Salespers./Purch. Code" := ValueEntry."Salespers./Purch. Code";
                ILE.MODIFY;
                ModifyCount += 1;
                ProgressWindow.UPDATE(2, ProcessingCount);
                ProgressWindow.UPDATE(3, ModifyCount);
            UNTIL ValueEntry.NEXT = 0;

    end;

    local procedure UpdateVATBase()
    var
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.RESET;
        VATEntry.SETFILTER("Entry No.", '75708..75709');
        IF VATEntry.FINDFIRST THEN
            REPEAT
                VATEntry."VAT Base 1" := 1481079;
                VATEntry.MODIFY;
            UNTIL VATEntry.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure UpdateGLEntryNo()
    var
        TDSEntry: Record "TDS Entry";
        GLEntry: Record "G/L Entry";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        //Total Count #1########### \Processing #2##########\Modifying #3###########
        ProcessingCount := 0;
        ModifyCount := 0;
        SourceCodeSetup.GET;
        TDSEntry.RESET;
        TDSEntry.SETRANGE("G/L Entry No.", 0);
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, TDSEntry.COUNT);
        IF TDSEntry.FINDFIRST THEN
            REPEAT
                ProcessingCount += 1;
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", TDSEntry."Document No.");
                GLEntry.SETFILTER(Description, 'System Created TDS Entry');
                GLEntry.SETRANGE(Amount, TDSEntry."TDS Amount");
                IF GLEntry.FINDFIRST THEN BEGIN
                    TDSEntry."G/L Entry No." := GLEntry."Entry No.";
                    TDSEntry.MODIFY;
                    GLEntry."TDS Entry No." := TDSEntry."Entry No.";
                    GLEntry.MODIFY;
                    ModifyCount += 1;
                END;
                IF SourceCodeSetup.Purchases = TDSEntry."Source Code" THEN BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Document No.", TDSEntry."Document No.");
                    GLEntry.SETFILTER(Description, STRSUBSTNO('TDS for Doc. No.%1', TDSEntry."Document No."));
                    IF GLEntry.FINDFIRST THEN BEGIN
                        TDSEntry."G/L Entry No." := GLEntry."Entry No.";
                        TDSEntry.MODIFY;
                        GLEntry."TDS Entry No." := TDSEntry."Entry No.";
                        GLEntry.MODIFY;
                        ModifyCount += 1;
                    END;
                END;
                ProgressWindow.UPDATE(2, ProcessingCount);
                ProgressWindow.UPDATE(3, ModifyCount);
            UNTIL TDSEntry.NEXT = 0;

        // GLEntry.RESET;
        // GLEntry.SETFILTER(Description,'System Created TDS Entry');
        // GLEntry.SETRANGE("Party Type",GLEntry."Party Type"::Branch);
        // GLEntry.MODIFYALL("Party Type",GLEntry."Party Type"::Vendor);

        // TDSEntry.RESET;
        // ProgressWindow.OPEN(Text000);
        // ProgressWindow.UPDATE(1,TDSEntry.COUNT);
        // IF TDSEntry.FINDFIRST THEN REPEAT
        //  ProcessingCount += 1;
        //  GLEntry.RESET;
        //  GLEntry.SETRANGE("Document No.",TDSEntry."Document No.");
        //  GLEntry.SETFILTER(Description,'System Created TDS Entry');
        //  IF GLEntry.FINDFIRST THEN BEGIN
        //    IF GLEntry."Party No." <> TDSEntry."Bill-to/Pay-to No." THEN BEGIN
        //      CASE TDSEntry."Source Type" OF
        //        TDSEntry."Source Type"::Customer : GLEntry."Party Type" := GLEntry."Party Type"::Customer;
        //        TDSEntry."Source Type"::Employee : GLEntry."Party Type" := GLEntry."Party Type"::Employee;
        //        TDSEntry."Source Type"::Vendor : GLEntry."Party Type" := GLEntry."Party Type"::Vendor;
        //      END;
        //      GLEntry."Party No." := TDSEntry."Bill-to/Pay-to No.";
        //      GLEntry.MODIFY;
        //      ModifyCount += 1;
        //    END;
        //  END;
        //  ProgressWindow.UPDATE(2,ProcessingCount);
        //  ProgressWindow.UPDATE(3,ModifyCount);
        // UNTIL TDSEntry.NEXT = 0;
    end;

    local procedure VATcorrection()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        AlLCustVendLedger: Record "Cust-Vend Ledger";
        Correctvendor: Record Vendor;
        ChangeLogSetup: Record "Change Log Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        VATPostingSetupFirst: Record "VAT Posting Setup";
        VATPostingSetupSecond: Record "VAT Posting Setup";
        VATPostingSetupThird: Record "VAT Posting Setup";
    begin
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;

        PurchInvLine.RESET;
        //PurchInvLine.SETFILTER("Localized VAT Identifier",'<>%1',PurchInvLine."Localized VAT Identifier"::" ");
        PurchInvLine.SETFILTER("Document No.", 'PPI73/74-00007');
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, PurchInvLine.COUNT);
        IF PurchInvLine.FINDFIRST THEN
            REPEAT
                ProgressWindow.UPDATE(3, PurchInvLine.COUNT);
                VATPostingSetup.RESET;
                VATPostingSetup.SETRANGE("VAT Prod. Posting Group", PurchInvLine."VAT Prod. Posting Group");
                VATPostingSetup.SETRANGE("VAT Bus. Posting Group", PurchInvLine."VAT Bus. Posting Group");
                IF VATPostingSetup.FINDFIRST THEN BEGIN
                    PurchInvLine."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
                    PurchInvLine.MODIFY;
                END;
                PurchInvHeader.RESET;
                PurchInvHeader.SETRANGE("No.", PurchInvLine."Document No.");
                IF PurchInvHeader.FINDFIRST THEN BEGIN
                    PurchRcptHdr.RESET;
                    PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
                    IF PurchRcptHdr.FINDFIRST THEN BEGIN
                        PurchRcptLine.RESET;
                        PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                        IF PurchRcptLine.FINDFIRST THEN
                            REPEAT
                                VATPostingSetupSecond.RESET;
                                VATPostingSetupSecond.SETRANGE("VAT Prod. Posting Group", PurchRcptLine."VAT Prod. Posting Group");
                                VATPostingSetupSecond.SETRANGE("VAT Bus. Posting Group", PurchRcptLine."VAT Bus. Posting Group");
                                IF VATPostingSetupSecond.FINDFIRST THEN BEGIN
                                    PurchRcptLine."Localized VAT Identifier" := VATPostingSetupSecond."Localized VAT Identifier";
                                    PurchRcptLine.MODIFY;
                                END;
                            UNTIL PurchRcptLine.NEXT = 0;
                    END;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", PurchInvLine."Document No.");
                GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        VATPostingSetupThird.RESET;
                        VATPostingSetupThird.SETRANGE("VAT Prod. Posting Group", GLEntry."VAT Prod. Posting Group");
                        VATPostingSetupThird.SETRANGE("VAT Bus. Posting Group", GLEntry."VAT Bus. Posting Group");
                        IF VATPostingSetupThird.FINDFIRST THEN
                            GLEntry."Localized VAT Identifier" := VATPostingSetupThird."Localized VAT Identifier";
                        IF GLEntry."G/L Account No." = '2262200' THEN
                            GLEntry."G/L Account No." := '2262100';
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", PurchInvLine."Document No.");
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        VATPostingSetupFirst.RESET;
                        VATPostingSetupFirst.SETRANGE("VAT Prod. Posting Group", VATEntry."VAT Prod. Posting Group");
                        VATPostingSetupFirst.SETRANGE("VAT Bus. Posting Group", VATEntry."VAT Bus. Posting Group");
                        IF VATPostingSetupFirst.FINDFIRST THEN BEGIN
                            VATEntry."Localized VAT Identifier" := VATPostingSetupFirst."Localized VAT Identifier";
                            VATEntry.MODIFY;
                        END;
                    UNTIL VATEntry.NEXT = 0;
                counttotal += 1;
                ProgressWindow.UPDATE(2, counttotal);
            UNTIL PurchInvLine.NEXT = 0;

        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
    end;

    local procedure ProductSegmentCodeCorrection()
    var
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        IF NOT CONFIRM('Do you want update Product Segment Code ?') THEN
            ERROR('Aborted by user');
        SalesInvHdr.RESET;
        SalesInvHdr.SETRANGE("Posting Date", 20160724D, 20160726D);
        SalesInvHdr.SETFILTER("Shortcut Dimension 1 Code", '%1|%2|%3', 'BIKANO', 'ISFAHAN', 'TIFFANY');
        IF SalesInvHdr.FINDSET THEN
            REPEAT
                SalesInvHdr."Shortcut Dimension 1 Code" := 'FOODS';
                SalesInvHdr.MODIFY;
            UNTIL SalesInvHdr.NEXT = 0;
        MESSAGE('Updated Successfully !');
    end;

    local procedure UpdateSourceTypeBillToInTDSEntry()
    var
        TDSEntry: Record "TDS Entry";
        GLEntry: Record "G/L Entry";
    begin
        ProgressWindow.OPEN(Text000);
        TDSEntry.RESET;
        TDSEntry.SETFILTER("Document No.", 'JV76/77-00775');
        ProgressWindow.UPDATE(1, TDSEntry.COUNT);
        IF TDSEntry.FINDFIRST THEN
            REPEAT
                ProcessingCount += 1;
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", TDSEntry."Document No.");
                IF GLEntry.FINDFIRST THEN BEGIN
                    //TDSEntry."Source Type" := GLEntry."G/L Account No.";
                    TDSEntry.MODIFY;
                    ModifyCount += 1;
                END;
                ProgressWindow.UPDATE(2, ProcessingCount);
                ProgressWindow.UPDATE(3, ModifyCount);
            UNTIL TDSEntry.NEXT = 0;
    end;

    local procedure UpdateGLPartyNo()
    var
        GLEntry: Record "G/L Entry";
    begin
        /*GLEntry.RESET;
        GLEntry.SETFILTER("Entry No.",'3131099');
        IF GLEntry.FINDFIRST THEN BEGIN
          GLEntry."Party No." := 'C00200';
          GLEntry."Party Type" := GLEntry."Party Type"::Customer;
          GLEntry.MODIFY;
        END;
        MESSAGE('Updated..');*/

    end;

    local procedure ProductSegCorrCustLedEntry()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        IF NOT CONFIRM('Do you want update Product Segment Code in Cust. Ledger Entry ?') THEN
            ERROR('Aborted by user');
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Posting Date", 20210727D, 20210803D);
        CustLedgerEntry.SETFILTER("Global Dimension 1 Code", 'BIKANO');
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry."Global Dimension 1 Code" := 'FOODS';
                CustLedgerEntry.MODIFY;
            UNTIL CustLedgerEntry.NEXT = 0;
        MESSAGE('Updated Successfully !');
    end;

    local procedure UpdateVendorNo()
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        VATEntry: Record "VAT Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ValueEntry: Record "Value Entry";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        Vendor: Record Vendor;
    begin
        PurchaseHdr.RESET;
        PurchaseHdr.SETFILTER("No.", 'PO77/78-02045');
        IF PurchaseHdr.FINDFIRST THEN
            REPEAT
                PurchaseHdr."Buy-from Vendor No." := 'V00008';
                PurchaseHdr."Pay-to Vendor No." := 'V00008';
                PurchaseHdr."Party No." := 'V00008';
                Vendor.RESET;
                Vendor.SETFILTER("No.", 'V00008');
                IF Vendor.FINDFIRST THEN BEGIN
                    PurchaseHdr."Buy-from Vendor Name" := Vendor.Name;
                    PurchaseHdr."Pay-to Name" := Vendor.Name;
                    PurchaseHdr."Party Name" := Vendor.Name;
                END;
                PurchaseHdr.MODIFY;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETFILTER("Order No.", PurchaseHdr."No.");
                IF PurchRcptHdr.FINDFIRST THEN
                    REPEAT
                        PurchRcptHdr."Buy-from Vendor No." := 'V00008';
                        PurchRcptHdr."Pay-to Vendor No." := 'V00008';
                        Vendor.RESET;
                        Vendor.SETFILTER("No.", 'V00008');
                        IF Vendor.FINDFIRST THEN BEGIN
                            PurchRcptHdr."Buy-from Vendor Name" := Vendor.Name;
                            PurchRcptHdr."Pay-to Name" := Vendor.Name;
                        END;
                        PurchRcptHdr.MODIFY;
                        ValueEntry.RESET;
                        ValueEntry.SETRANGE("Document No.", PurchRcptHdr."No.");
                        IF ValueEntry.FINDFIRST THEN
                            REPEAT
                                ValueEntry."Source No." := 'V00008';
                                ValueEntry.MODIFY;
                                ItemLedgEntry.RESET;
                                ItemLedgEntry.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                                IF ItemLedgEntry.FINDFIRST THEN
                                    REPEAT
                                        ItemLedgEntry."Source No." := 'V00008';
                                        ItemLedgEntry."Party No." := 'V00008';
                                        IF Vendor.GET('V00008') THEN
                                            ItemLedgEntry."Party Name" := Vendor.Name;
                                        ItemLedgEntry.MODIFY;
                                    UNTIL ItemLedgEntry.NEXT = 0;
                            UNTIL ValueEntry.NEXT = 0;
                    UNTIL PurchRcptHdr.NEXT = 0;
            UNTIL PurchaseHdr.NEXT = 0;
        MESSAGE('Vendor No has been updated');
    end;

    local procedure UpdateVatEntryVATZeroPercent()
    var
        VatEntry: Record "VAT Entry";
    begin
        VatEntry.RESET;
        //VatEntry.SETFILTER("Document No.",'PPI78/79-00437|PPI78/79-00630|PPI78/79-00639|PPI78/79-00636|PPI78/79-00633');
        VatEntry.SETRANGE("Posting Date", 20210917D, 20211017D);
        VatEntry.SETFILTER(Base, '500');
        VatEntry.SETFILTER(Amount, '65');
        VatEntry.SETFILTER("VAT Bus. Posting Group", '%1|%2', 'PUR-CUSTOM', 'PUR-LOCAL');
        VatEntry.SETFILTER(PragyapanPatra, '<>%1', '');
        VatEntry.SETFILTER("Localized VAT Identifier", '%1|%2', VatEntry."Localized VAT Identifier"::"Taxable Import Purchase", VatEntry."Localized VAT Identifier"::"Taxable Local Purchase");
        //VatEntry.SETFILTER("VAT Prod. Posting Group",'VATCUSTOM');
        IF VatEntry.FINDFIRST THEN
            REPEAT
                VatEntry."VAT Base 1" := 500;
                VatEntry.MODIFY;
            UNTIL VatEntry.NEXT = 0;
    end;

    local procedure UpdateLocalizedVATIdentifier()
    var
        VatEntryRec: Record "VAT Entry";
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        PurchInvLine.GET('PPI78/79-00638', 50000);
        PurchInvLine."VAT Prod. Posting Group" := 'VAT00';
        PurchInvLine.MODIFY;
    end;

    local procedure UpdateVatEntryBaseWise()
    var
        VatEntry: Record "VAT Entry";
        VatEntrySecond: Record "VAT Entry";
    begin
        ProgressWindow.OPEN(Text000);
        VatEntry.RESET;
        VatEntry.SETRANGE("Posting Date", 20210917D, 20211017D);
        VatEntry.SETFILTER(Base, '500');
        VatEntry.SETRANGE("Localized VAT Identifier", VatEntry."Localized VAT Identifier"::"Taxable Import Purchase");
        VatEntry.SETRANGE("VAT Calculation Type", VatEntry."VAT Calculation Type"::"Normal VAT");
        ProgressWindow.UPDATE(1, VatEntry.COUNT);
        IF VatEntry.FINDSET THEN
            REPEAT
                ProcessingCount += 1;
                VatEntrySecond.RESET;
                VatEntrySecond.SETRANGE("Document No.", VatEntry."Document No.");
                VatEntrySecond.SETRANGE("Localized VAT Identifier", VatEntrySecond."Localized VAT Identifier"::"Taxable Import Purchase");
                VatEntrySecond.SETRANGE("VAT Calculation Type", VatEntrySecond."VAT Calculation Type"::"Full VAT");
                IF VatEntrySecond.FINDFIRST THEN BEGIN
                    VatEntrySecond."VAT Base 1" := VatEntrySecond."VAT Base 1" - VatEntry.Base;
                    VatEntrySecond.MODIFY;
                    ModifyCount += 1;
                END;
                ProgressWindow.UPDATE(2, ProcessingCount);
                ProgressWindow.UPDATE(3, ModifyCount);
            UNTIL VatEntry.NEXT = 0;
    end;

    local procedure UpdateINVatentry()
    var
        VatentryFirst: Record "VAT Entry";
    begin
        VatentryFirst.RESET;
        VatentryFirst.SETRANGE("Document No.", 'PPI73/74-00006');//|PPI73/74-00005|PPI73/74-00006');
        VatentryFirst.SETFILTER(Base, '500');
        VatentryFirst.SETRANGE("VAT Calculation Type", VatentryFirst."VAT Calculation Type"::"Normal VAT");
        IF VatentryFirst.FINDFIRST THEN
            REPEAT
                //VatentryFirst."Localized VAT Identifier" := VatentryFirst."Localized VAT Identifier"::"Taxable Import Purchase";
                VatentryFirst.Amount := 65;
                VatentryFirst.MODIFY;
            UNTIL VatentryFirst.NEXT = 0;
    end;

    local procedure UpdateVatEntryAmtWise()
    var
        VatEntry: Record "VAT Entry";
        VatEntrySecond: Record "VAT Entry";
    begin
        ProgressWindow.OPEN(Text000);
        VatEntry.RESET;
        VatEntry.SETRANGE("Posting Date", 20210917D, 20211017D);
        VatEntry.SETFILTER(Amount, '65');
        VatEntry.SETRANGE("Localized VAT Identifier", VatEntry."Localized VAT Identifier"::"Taxable Import Purchase");
        VatEntry.SETRANGE("VAT Calculation Type", VatEntry."VAT Calculation Type"::"Normal VAT");
        ProgressWindow.UPDATE(1, VatEntry.COUNT);
        IF VatEntry.FINDSET THEN
            REPEAT
                ProcessingCount += 1;
                VatEntrySecond.RESET;
                VatEntrySecond.SETRANGE("Document No.", VatEntry."Document No.");
                VatEntrySecond.SETRANGE("Localized VAT Identifier", VatEntrySecond."Localized VAT Identifier"::"Taxable Import Purchase");
                VatEntrySecond.SETRANGE("VAT Calculation Type", VatEntrySecond."VAT Calculation Type"::"Full VAT");
                IF VatEntrySecond.FINDFIRST THEN BEGIN
                    VatEntrySecond.Amount := VatEntrySecond.Amount - VatEntry.Amount;
                    VatEntrySecond.MODIFY;
                    ModifyCount += 1;
                END;
                ProgressWindow.UPDATE(2, ProcessingCount);
                ProgressWindow.UPDATE(3, ModifyCount);
            UNTIL VatEntry.NEXT = 0;
    end;

    local procedure UpdateINVatentryData()
    var
        VatentryFirst: Record "VAT Entry";
    begin
        VatentryFirst.RESET;
        VatentryFirst.SETRANGE("Posting Date", 20220115D, 20210212D);
        //VatentryFirst.SETFILTER("Bill-to/Pay-to No.",'V00141');
        VatentryFirst.SETFILTER("VAT Bus. Posting Group", 'PUR-LOCAL');
        VatentryFirst.SETFILTER("VAT Prod. Posting Group", 'VAT00');
        VatentryFirst.SETRANGE("Localized VAT Identifier", VatentryFirst."Localized VAT Identifier"::"Exempt Purchase");
        IF VatentryFirst.FINDFIRST THEN
            REPEAT
                VatentryFirst."Exempt Amount" := VatentryFirst.Base;
                VatentryFirst.MODIFY;
            UNTIL VatentryFirst.NEXT = 0;
    end;

    local procedure UpdateINVatentry13Percent()
    var
        VatentryFirst: Record "VAT Entry";
    begin
        /*VatentryFirst.RESET; //Not required to execute this function
        VatentryFirst.SETRANGE("Posting Date",20210917D,20211017D);
        VatentryFirst.SETFILTER(Base,'500');
        VatentryFirst.SETFILTER(Amount,'65');
        VatentryFirst.SETRANGE(Type,VatentryFirst.Type::Purchase);
        VatentryFirst.SETFILTER("VAT Prod. Posting Group",'VAT13');
        //VatentryFirst.SETRANGE("Localized VAT Identifier",VatentryFirst."Localized VAT Identifier"::"Exempt Purchase");
        IF VatentryFirst.FINDFIRST THEN REPEAT
          VatentryFirst."VAT Base 1" := 0;
          VatentryFirst.MODIFY;
         UNTIL VatentryFirst.NEXT=0;*/

    end;

    local procedure UpdateVatEntryVATZeroPercentUpdate()
    var
        VatEntry: Record "VAT Entry";
    begin
        VatEntry.RESET;
        //VatEntry.SETFILTER("Document No.",'PPI78/79-00437|PPI78/79-00630|PPI78/79-00639|PPI78/79-00636|PPI78/79-00633');
        VatEntry.SETRANGE("Posting Date", 20220115D, 20210212D);
        VatEntry.SETFILTER(Base, '500');
        VatEntry.SETFILTER(Amount, '65');
        VatEntry.SETFILTER("VAT Bus. Posting Group", 'PUR-CUSTOM');
        VatEntry.SETFILTER(PragyapanPatra, '<>%1', '');
        //VatEntry.SETFILTER("VAT Base 1",'<>%1',0);
        //VatEntry.SETFILTER("VAT Prod. Posting Group",'VATCUSTOM');
        IF VatEntry.FINDFIRST THEN
            REPEAT
                VatEntry."VAT Base 1" := 500;
                VatEntry.MODIFY;
            UNTIL VatEntry.NEXT = 0;
    end;

    local procedure UpdateDocumentVatEntry()
    var
        VatEntryRec: Record "VAT Entry";
    begin
        VatEntryRec.RESET;
        VatEntryRec.SETRANGE("Document No.", 'PPI78/79-00927');
        VatEntryRec.SETRANGE("Localized VAT Identifier", VatEntryRec."Localized VAT Identifier"::"Exempt Purchase");
        IF VatEntryRec.FINDLAST THEN BEGIN
            VatEntryRec."Exempt Amount" := 0;
            VatEntryRec.MODIFY;
        END;
    end;

    local procedure UpdateINVatentryLocalPurchase()
    var
        VatentryFirst: Record "VAT Entry";
    begin
        VatentryFirst.RESET;
        VatentryFirst.SETRANGE("Posting Date", 20220115D, 20210212D);
        VatentryFirst.SETFILTER("VAT Bus. Posting Group", 'PUR-LOCAL');
        VatentryFirst.SETFILTER("VAT Prod. Posting Group", 'VAT13');
        VatentryFirst.SETRANGE("Localized VAT Identifier", VatentryFirst."Localized VAT Identifier"::"Taxable Local Purchase");
        IF VatentryFirst.FINDFIRST THEN
            REPEAT
                VatentryFirst."VAT Base 1" := VatentryFirst.Base;
                VatentryFirst.MODIFY;
            UNTIL VatentryFirst.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure UpdateSalesCrMemoMaterializeView()
    var
        SalesCrMemoMaterializeView: Record "Invoice Materialize View";
        VatEntry: Record "VAT Entry";
        CustomerRec: Record Customer;
        IRDMgmt: Codeunit "IRD Mgt.";
    begin
        VatEntry.RESET;
        VatEntry.SETRANGE("Document No.", 'CN78/79-0020');
        IF VatEntry.FINDFIRST THEN BEGIN
            SalesCrMemoMaterializeView.RESET;
            SalesCrMemoMaterializeView.SETRANGE("Bill No", VatEntry."Document No.");
            IF SalesCrMemoMaterializeView.FINDFIRST THEN
                MESSAGE('Already here')
            ELSE BEGIN
                SalesCrMemoMaterializeView.INIT;
                SalesCrMemoMaterializeView."Table ID" := DATABASE::"Sales Cr.Memo Header";
                SalesCrMemoMaterializeView."Bill No" := VatEntry."Document No.";
                SalesCrMemoMaterializeView."Source Code" := VatEntry."Source Code";
                SalesCrMemoMaterializeView."Customer Code" := VatEntry."Bill-to/Pay-to No.";
                IF CustomerRec.GET(VatEntry."Bill-to/Pay-to No.") THEN
                    SalesCrMemoMaterializeView."Customer Name" := CustomerRec.Name;
                SalesCrMemoMaterializeView."Bill Date" := VatEntry."Document Date";
                SalesCrMemoMaterializeView."Fiscal Year" := IRDMgmt.GetNepaliFiscalYear(VatEntry."Posting Date");
                SalesCrMemoMaterializeView."Posting Time" := TIME;
                SalesCrMemoMaterializeView."Source Type" := SalesCrMemoMaterializeView."Source Type"::Customer;
                SalesCrMemoMaterializeView."Document Type" := SalesCrMemoMaterializeView."Document Type"::"Sales Credit Memo";
                SalesCrMemoMaterializeView.Amount := VatEntry.Base;
                SalesCrMemoMaterializeView."VAT Registration No." := VatEntry."VAT Registration No.";
                SalesCrMemoMaterializeView."TAX Amount" := VatEntry.Amount;
                SalesCrMemoMaterializeView."Total Amount" := VatEntry.Base + VatEntry.Amount;
                SalesCrMemoMaterializeView."Taxable Amount" := VatEntry.Base;
                SalesCrMemoMaterializeView."Created By" := USERID;
                SalesCrMemoMaterializeView."Sync Status" := SalesCrMemoMaterializeView."Sync Status"::"Sync In Progress";
                SalesCrMemoMaterializeView."Is Bill Printed" := TRUE;
                SalesCrMemoMaterializeView."Is Bill Active" := TRUE;
                SalesCrMemoMaterializeView."Printed By" := USERID;
                SalesCrMemoMaterializeView.INSERT;
                MESSAGE('Updated sucessfully');
            END;
        END;
    end;
}

