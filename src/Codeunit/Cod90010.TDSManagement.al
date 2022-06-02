codeunit 50502 "TDS Management"
{
    Permissions = tabledata "G/L Entry" = rim;

    trigger OnRun()
    begin

    end;

    procedure GetPurchaseTDSVendorName(GenJournalLine: Record "Gen. Journal Line")
    var
    begin
        //TDS1.00
        CLEAR(VendorName);
        IF GenJournalLine."TDS Group" <> '' THEN BEGIN
            Vendor.RESET;
            //Vendor.SETRANGE("No.", "Document Subclass");
            IF Vendor.FINDFIRST THEN
                VendorName := Vendor.Name;
        END;
        //TDS1.00
    end;

    procedure GetTDSGLCodeName(GenJournalLine: Record "Gen. Journal Line")
    begin
        //TDS1.00
        CLEAR(GLAccountNo);
        CLEAR(GLAccountName);
        IF GenJournalLine."TDS Group" <> '' THEN BEGIN
            TDSpostingGroup.RESET;
            TDSpostingGroup.SETRANGE(Code, GenJournalLine."TDS Group");
            IF TDSpostingGroup.FINDFIRST THEN BEGIN
                GLAccountNo := TDSpostingGroup."GL Account No.";
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", GLAccountNo);
                IF GLAccount.FINDFIRST THEN
                    GLAccountName := GLAccount.Name;
            END;
        END;
        //TDS1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterSettingIsTransactionConsistent', '', true, true)]
    local procedure OnAfterSettingIsTransactionConsistent(GenJournalLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean)
    var
        GenJnlLine: record "Gen. Journal Line";
    begin
        GenJnlLine.Reset();
        GenJnlLine.setrange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        //GenJnlLine.SetRange("Document No.", GenJournalLine."Pre-Assigned No.");
        GenJnlLine.SetFilter("TDS Group", '<>%1', '');
        GenJnlLine.SetFilter("TDS Amount", '<>%1', 0);
        //GenJnlLine.SetFilter("Account Type", '<>%1&<>%2', GenJnlLine."Account Type"::"Fixed Asset", GenJnlLine."Account Type"::Employee);
        if GenJnlLine.FindFirst() then begin
            IsTransactionConsistent := false;
            GenJnlLine.Reset();
            GenJnlLine.setrange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            //GenJnlLine.SetRange("Document No.", GenJournalLine."Pre-Assigned No.");
            GenJnlLine.CalcSums("Amount (LCY)", "TDS Amount");
            if GenJnlLine."Amount (LCY)" - GenJnlLine."TDS Amount" = 0 then
                IsTransactionConsistent := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGLEntryBuffer', '', true, true)]
    local procedure OnBeforeInsertGLEntryBufferGenJnlPostLine(var TempGLEntryBuf: Record "G/L Entry" temporary; var GenJournalLine: Record "Gen. Journal Line"; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal; var NextEntryNo: Integer; var TotalAmount: Decimal; var TotalAddCurrAmount: Decimal)
    var
        PostingDate: Date;
        Amount: Decimal;
    begin
        PostingDate := GenJournalLine."Posting Date";
        //Amount := -GenJournalLine."TDS Amount";

        if abs(GenJournalLine."VAT Base Amount (LCY)") = Abs(TempGLEntryBuf.Amount) then begin
            if PostingDate = NormalDate(PostingDate) then begin
                BalanceCheckAmount :=
                  BalanceCheckAmount + Amount * ((PostingDate - 00000101D) mod 99 + 1);
                BalanceCheckAmount2 :=
                  BalanceCheckAmount2 + Amount * ((PostingDate - 00000101D) mod 98 + 1);
            end else begin
                BalanceCheckAmount :=
                  BalanceCheckAmount + Amount * ((NormalDate(PostingDate) - 00000101D + 50) mod 99 + 1);
                BalanceCheckAmount2 :=
                  BalanceCheckAmount2 + Amount * ((NormalDate(PostingDate) - 00000101D + 50) mod 98 + 1);
            end;
        end;
    end;

    /* Suman
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeCheckBalance', '', true, true)]

    local procedure OnBeforeCheckBalance(GenJnlTemplate: Record "Gen. Journal Template"; GenJnlLine: Record "Gen. Journal Line"; CurrentBalance: Decimal; CurrentBalanceReverse: Decimal; CurrencyBalance: Decimal; StartLineNo: Integer; StartLineNoReverse: Integer; LastDocType: Option; LastDocNo: Code[20]; LastDate: Date; LastCurrencyCode: Code[10]; CommitIsSuppressed: Boolean)
    begin
        if (GenJnlLine."TDS Group" <> '') and (GenJnlLine."TDS Amount" <> 0) then
            CurrentBalance += GenJnlLine."TDS Amount";
    end;
    */
    procedure CalcTDSBalance(VAR GenJnlLine: Record "Gen. Journal Line"; LastGenJnlLine: Record "Gen. Journal Line"; VAR TDSBalance: Decimal; VAR TotalTDSBalance: Decimal; VAR ShowTDSBalance: Boolean; VAR ShowTotalTDSBalance: Boolean)
    var
        TempGenJnlLine: Record "Gen. Journal Line";
    begin
        TempGenJnlLine.COPYFILTERS(GenJnlLine);
        ShowTotalTDSBalance := TempGenJnlLine.CALCSUMS("TDS Amount");
        IF ShowTotalTDSBalance THEN BEGIN
            IF GenJnlLine."Bal. Account No." = '' THEN
                TotalTDSBalance := TempGenJnlLine."TDS Amount"
            ELSE
                TotalTDSBalance := 0;
            IF GenJnlLine."Line No." = 0 THEN
                IF GenJnlLine."Bal. Account No." = '' THEN
                    TotalTDSBalance := TotalTDSBalance + LastGenJnlLine."TDS Amount"
                ELSE
                    TotalTDSBalance := 0;
        END;

        IF GenJnlLine."Line No." <> 0 THEN BEGIN
            TempGenJnlLine.SETRANGE("Line No.", 0, GenJnlLine."Line No.");
            ShowTDSBalance := TempGenJnlLine.CALCSUMS("TDS Amount");
            IF ShowTDSBalance THEN BEGIN
                IF GenJnlLine."Bal. Account No." = '' THEN
                    TDSBalance := TempGenJnlLine."TDS Amount"
                ELSE
                    TDSBalance := 0;
            END;
        END ELSE BEGIN
            TempGenJnlLine.SETRANGE("Line No.", 0, LastGenJnlLine."Line No.");
            ShowTDSBalance := TempGenJnlLine.CALCSUMS("TDS Amount");
            IF ShowTDSBalance THEN BEGIN
                TDSBalance := TempGenJnlLine."TDS Amount";
                TempGenJnlLine.COPYFILTERS(GenJnlLine);
                TempGenJnlLine := LastGenJnlLine;
                IF TempGenJnlLine.NEXT = 0 THEN
                    TDSBalance := TDSBalance + LastGenJnlLine."TDS Amount";
            END;
        END;
    end;

    procedure CalcTDSEntryTDSBalance(VAR TDSEntry: Record "TDS Entry"; LastTDSEntry: Record "TDS Entry"; VAR TDSBalance: Decimal; VAR TotalTDSBalance: Decimal; VAR ShowTDSBalance: Boolean; VAR ShowTotalTDSBalance: Boolean)
    var
        TempTDSEntry: Record "TDS Entry";
    begin
        TempTDSEntry.COPYFILTERS(TDSEntry);
        ShowTotalTDSBalance := TempTDSEntry.CALCSUMS("TDS Amount");
        IF ShowTotalTDSBalance THEN BEGIN
            TotalTDSBalance := TempTDSEntry."TDS Amount";
            IF TDSEntry."Entry No." = 0 THEN
                TotalTDSBalance := TotalTDSBalance + LastTDSEntry."TDS Amount";
        END;

        IF TDSEntry."Entry No." <> 0 THEN BEGIN
            TempTDSEntry.SETRANGE("Entry No.", 0, TDSEntry."Entry No.");
            ShowTDSBalance := TempTDSEntry.CALCSUMS("TDS Amount");
            IF ShowTDSBalance THEN
                TDSBalance := TempTDSEntry."TDS Amount";
        END ELSE BEGIN
            TempTDSEntry.SETRANGE("Entry No.", 0, LastTDSEntry."Entry No.");
            ShowTDSBalance := TempTDSEntry.CALCSUMS("TDS Amount");
            IF ShowTDSBalance THEN BEGIN
                TDSBalance := TempTDSEntry."TDS Amount";
                TempTDSEntry.COPYFILTERS(TDSEntry);
                TempTDSEntry := LastTDSEntry;
                IF TempTDSEntry.NEXT = 0 THEN
                    TDSBalance := TDSBalance + LastTDSEntry."TDS Amount";
            END;
        END;

    end;

    procedure CalcTDSEntryBaseBalance(VAR TDSEntry: Record "TDS Entry"; LastTDSEntry: Record "TDS Entry"; VAR BaseBalance: Decimal; VAR TotalBaseBalance: Decimal; VAR ShowBaseBalance: Boolean; VAR ShowTotalBaseBalance: Boolean)
    var
        TempTDSEntry: Record "TDS Entry";
    begin

        TempTDSEntry.COPYFILTERS(TDSEntry);
        ShowTotalBaseBalance := TempTDSEntry.CALCSUMS(Base);
        IF ShowTotalBaseBalance THEN BEGIN
            TotalBaseBalance := TempTDSEntry.Base;
            IF TDSEntry."Entry No." = 0 THEN
                TotalBaseBalance := TotalBaseBalance + LastTDSEntry.Base;
        END;

        IF TDSEntry."Entry No." <> 0 THEN BEGIN
            TempTDSEntry.SETRANGE("Entry No.", 0, TDSEntry."Entry No.");
            ShowBaseBalance := TempTDSEntry.CALCSUMS(Base);
            IF ShowBaseBalance THEN
                BaseBalance := TempTDSEntry.Base;
        END ELSE BEGIN
            TempTDSEntry.SETRANGE("Entry No.", 0, LastTDSEntry."Entry No.");
            ShowBaseBalance := TempTDSEntry.CALCSUMS(Base);
            IF ShowBaseBalance THEN BEGIN
                BaseBalance := TempTDSEntry.Base;
                TempTDSEntry.COPYFILTERS(TDSEntry);
                TempTDSEntry := LastTDSEntry;
                IF TempTDSEntry.NEXT = 0 THEN
                    BaseBalance := BaseBalance + LastTDSEntry.Base;
            END;
        END;
    end;

    procedure GetNextTdsEntryNo(): Integer
    begin
        EXIT(NextTdsEntryNo);
    end;

    procedure NextTdsEntryNo(): Integer
    var
        TDSEntry1: Record "TDS Entry";
        TDSEntryNo: Integer;

    begin
        TDSEntry1.LOCKTABLE;
        TDSEntry1.RESET;
        IF TDSEntry1.FINDLAST THEN
            TDSEntryNo := TDSEntry1."Entry No." + 1
        ELSE
            TDSEntryNo := 1;
        EXIT(TDSEntryNo);
    end;

    //>>TDS Reverse

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseOnBeforeFinishPosting', '', true, true)]
    // local procedure OnReverseOnBeforeFinishPosting(var ReversalEntry: Record "Reversal Entry"; var ReversalEntry2: Record "Reversal Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var GLRegister: Record "G/L Register")
    // var
    //     TDSEntry: record "TDS Entry";
    // begin
    //     //TDS1.00 >>
    //     TDSEntry.SETRANGE("Transaction No.", ReversalEntry."Transaction No.");
    //     ReverseTDS(TDSEntry, ReversalEntry, ReversalEntry."Source Code", GenJnlPostLine);
    //     //TDS1.00 <<
    // end;


    PROCEDURE ReverseTDS(VAR TDSEntry: Record "TDS Entry"; VAR TempReversedGLEntry: Record "G/L Entry"; SourceCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    VAR
        NewTDSEntry: Record "TDS Entry";
        ReversedTDSEntry: Record "TDS Entry";
        CannotReverseErr: Label 'You cannot reverse the transaction, because it has already been reversed.';
    BEGIN
        //TDS1.00
        IF TDSEntry.FINDSET THEN
            REPEAT
                IF TDSEntry."Reversed by Entry No." <> 0 THEN
                    ERROR(CannotReverseErr);
                WITH NewTDSEntry DO BEGIN
                    NewTDSEntry := TDSEntry;
                    "Posting Date" := TempReversedGLEntry."Posting Date";
                    Base := -Base;
                    "TDS Amount" := -"TDS Amount";
                    "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
                    "Source Code" := SourceCode;
                    "User ID" := USERID;
                    "Entry No." := NextTdsEntryNo();
                    "Reversed Entry No." := TDSEntry."Entry No.";
                    Reversed := TRUE;
                    // Reversal of Reversal
                    IF TDSEntry."Reversed Entry No." <> 0 THEN BEGIN
                        ReversedTDSEntry.GET(TDSEntry."Reversed Entry No.");
                        ReversedTDSEntry."Reversed by Entry No." := 0;
                        ReversedTDSEntry.Reversed := FALSE;
                        ReversedTDSEntry.MODIFY;
                        TDSEntry."Reversed Entry No." := "Entry No.";
                        "Reversed by Entry No." := TDSEntry."Entry No.";
                    END;
                    TDSEntry."Reversed by Entry No." := "Entry No.";
                    TDSEntry.Reversed := TRUE;
                    TDSEntry.MODIFY;
                    INSERT;
                END;
            UNTIL TDSEntry.NEXT = 0;
        //TDS1.00
    END;
    //<< TDS reverse


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterUpdateLineBalance', '', false, false)]
    local procedure OnAfterUpdateLineBalance(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Balance (LCY)" -= GenJournalLine."TDS Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnFillInvoicePostBufferOnAfterInitAmounts', '', true, true)]
    local procedure OnFillInvoicePostBufferOnAfterInitAmountsPurchPost(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var PurchLineACY: Record "Purchase Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var InvoicePostBuffer: Record "Invoice Post. Buffer"; var TotalAmount: Decimal; var TotalAmountACY: Decimal)
    begin
        SetTDSAccount(InvoicePostBuffer, PurchLine);
        //TDS1.00
        InvoicePostBuffer."TDS Amount" := PurchLine."TDS Amount";
        InvoicePostBuffer."TDS Base Amount" := PurchLine."TDS Base Amount";
        //>> no extension table of invoice post buffer both filed are not define <<
        InvoicePostBuffer."TDS Amount (ACY)" := PurchLineACY."TDS Amount";
        InvoicePostBuffer."TDS Base Amount (ACY)" := PurchLineACY."TDS Base Amount";
        //TDS1.00
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnBeforeInvPostBufferModify', '', true, true)]
    local procedure OnBeforeInvPostBufferModify(var InvoicePostBuffer: Record "Invoice Post. Buffer"; FromInvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        InvoicePostBuffer."TDS Amount" += FromInvoicePostBuffer."TDS Amount";
        InvoicePostBuffer."TDS Base Amount" += FromInvoicePostBuffer."TDS Base Amount";
        InvoicePostBuffer."TDS Base Amount (ACY)" += FromInvoicePostBuffer."TDS Base Amount (ACY)";
        InvoicePostBuffer."TDS Amount (ACY)" += FromInvoicePostBuffer."TDS Amount (ACY)";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        SetTDSAccount(InvoicePostBuffer, PurchaseLine);
        SetTDSAmounts(InvoicePostBuffer, PurchaseLine."TDS Amount", PurchaseLine."TDS Base Amount");
    end;

    local procedure SetTDSAccount(var InvoicePostBuffer: Record "Invoice Post. Buffer"; PurchLine: Record "Purchase Line")
    begin
        //TDS1.00
        IF PurchLine."TDS Group" <> '' THEN begin
            InvoicePostBuffer."TDS Group" := PurchLine."TDS Group";
            InvoicePostBuffer."Additional Grouping Identifier" := PurchLine."TDS Group";
        end;
        IF PurchLine."TDS%" <> 0 THEN
            InvoicePostBuffer."TDS%" := PurchLine."TDS%";
        IF PurchLine."TDS Type" <> PurchLine."TDS Type"::" " THEN
            InvoicePostBuffer."TDS Type" := PurchLine."TDS Type";
        //TDS1.00
    end;

    procedure SetTDSAmounts(var InvoicePostBuffer: Record "Invoice Post. Buffer"; TotalTDSAmount: Decimal; TotalTDSBaseAmount: Decimal)
    var
    begin
        //TDS1.00
        InvoicePostBuffer."TDS Amount" := TotalTDSAmount;
        InvoicePostBuffer."TDS Base Amount" := TotalTDSBaseAmount;
        //TDS1.00
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', false, false)]
    local procedure CopyTDSFields(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //TDS1.00
        GenJournalLine."TDS Group" := InvoicePostBuffer."TDS Group";
        GenJournalLine."TDS%" := InvoicePostBuffer."TDS%";
        GenJournalLine."TDS Type" := InvoicePostBuffer."TDS Type";
        GenJournalLine."TDS Amount" := InvoicePostBuffer."TDS Amount (ACY)";
        GenJournalLine."TDS Base Amount" := InvoicePostBuffer."TDS Base Amount (ACY)";
        GenJournalLine."TDS Amount" := InvoicePostBuffer."TDS Amount";
        GenJournalLine."TDS Base Amount" := InvoicePostBuffer."TDS Base Amount";
        //TDS1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostInvPostBuffer', '', false, false)]
    local procedure OnAfterPostInvPostBufferForFA(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; PurchHeader: Record "Purchase Header"; GLEntryNo: Integer; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        GLEntry: Record "G/L Entry";
    begin
        if (GenJnlLine."TDS Group" <> '') and (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset") then begin
            InsertTDSEntry(GenJnlLine, GLEntry, GenJnlPostLine.GetNextTransactionNo());
            GLEntry."Entry No." := GenJnlPostLine.GetNextEntryNo();
            GenJnlPostLine.IncrNextEntryNo();
            GLEntry."Transaction No." := GLEntry."Transaction No.";
            GLEntry.Insert();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostVend', '', false, false)]
    local procedure OnAfterPostVend(var GenJournalLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean)
    var
        GLEntry: Record "G/L Entry";

    begin
        if GenJournalLine."TDS Group" = '' then
            exit;

        InsertTDSEntry(GenJournalLine, GLEntry, NextTransactionNo);
        GLEntry."Entry No." := NextEntryNo;
        NextEntryNo += 1;
        GLEntry."Transaction No." := NextTransactionNo;
        TempGLEntryBuf := GLEntry;
        TempGLEntryBuf.Insert(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', false, false)]
    local procedure PostTDS(var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean)
    var
        GLEntry: Record "G/L Entry";

    begin
        if GenJnlLine."TDS Group" = '' then
            exit;

        InsertTDSEntry(GenJnlLine, GLEntry, NextTransactionNo);
        GLEntry."Entry No." := NextEntryNo;
        NextEntryNo += 1;
        GLEntry."Transaction No." := NextTransactionNo;
        TempGLEntryBuf := GLEntry;
        TempGLEntryBuf.Insert(true);
    end;

    local procedure InsertTDSEntry(GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; TransactionNo: Integer)
    var
        TDSPostingGrp: Record "TDS Posting Group";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        TDSEntry.Init();
        TDSEntry.CopyFromGenJnlLine(GenJnlLine);
        TDSEntry."Entry No." := NextTdsEntryNo();
        TDSEntry.Insert(true);
        TDSPostingGrp.Get(GenJnlLine."TDS Group");
        GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, TDSPostingGrp."GL Account No.", -GenJnlLine."TDS Amount", 0, false, true);
        GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, false);
        GLentry.UpdateDebitCredit(GenJnlLine.Correction);
        TDSEntry."Transaction No." := TransactionNo;
        TDSEntry.Modify(true);
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterInsertReversalEntry', '', false, false)]
    // local procedure OnAfterInsertReversalEntry(var TempRevertTransactionNo: Record "Integer"; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer; var TempReversalEntry: Record "Reversal Entry" temporary)
    // var
    //     ReversalEntry: Record "Reversal Entry";
    // begin
    //     //TDS1.00
    //     ReversalEntry.InsertFromTDSEntry(TempReversalEntry, TempRevertTransactionNo, Number, RevType::Transaction, NextLineNo);
    // end; //alread called in IRD ENGINE

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterSetReverseFilter', '', false, false)]
    local procedure OnAfterSetReverseFilter(Number: Integer; RevType: Option Transaction,Register; GLRegister: Record "G/L Register");
    var
        TDSEntry: Record "TDS Entry";
    begin
        if RevType = RevType::Transaction then begin
            TDSEntry.SetCurrentKey("Transaction No.");
            TDSEntry.SetRange("Transaction No.", Number);
        end else begin
            //tds from and to entry no. is not developed so cannot be used commented by Suman
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterCheckEntries', '', false, false)]
    local procedure OnAfterCheckEntries(var MaxPostingDate: Date);
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnCheckGLAccOnBeforeTestFields', '', false, false)]
    local procedure OnCheckGLAccOnBeforeTestFields(GLAcc: Record "G/L Account"; GLEntry: Record "G/L Entry"; var IsHandled: Boolean);
    var
    begin
        CheckTDS_PDC_Entries(GLEntry);
    end;

    LOCAL procedure CheckTDS_PDC_Entries(GL_Entry: Record "G/L Entry")
    var
        TDSEntryNotBlankErr: TextConst ENU = 'You cannot reverse the TDS Payment (Doc. No. %1) from this functionality. Please reverse it from TDS Entries Page.';
        PDCEntryNotBlankErr: TextConst ENU = 'You cannot reverse the PDC Payment (Doc. No. %1) from this functionality. Please reverse it from PDC Entries Page.';
    begin
        //UTS SM 18 Apr 2017
        IF (GL_Entry."TDS Entry No." <> 0) THEN
            ERROR(TDSEntryNotBlankErr, GL_Entry."Document No.");

        // IF GL_Entry."PDC Entry No." <> 0 THEN
        //     ERROR(PDCEntryNotBlankErr, GL_Entry."Document No.");
        //UTS SM 18 Apr 2017
    end;


    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure OnAfterFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    var
        Navigate: Page Navigate;
    begin
        Navigate.FindTDSEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ExtDocNo: Code[250])
    var
        Navigate: page Navigate;
    begin
        Navigate.ShowTDSEntries(TableID, DocNoFilter, PostingDateFilter);
    end;

    //Purchase TDS

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterReverseAmount', '', false, false)]
    local procedure OnAfterReverseAmount(var PurchLine: Record "Purchase Line");
    begin
        purchline."TDS Amount" := -PurchLine."TDS Amount";
        PurchLine."TDS Base Amount" := -PurchLine."TDS Base Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
        GenJnlLine.Amount := -(TotalPurchLine."Amount Including VAT" - TotalPurchLine."TDS Amount");
        GenJnlLine."Amount (LCY)" := -(TotalPurchLineLCY."Amount Including VAT" - TotalPurchLineLCY."TDS Amount");
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostBalancingEntry', '', false, false)]
    local procedure OnBeforePostBalancingEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean);
    begin
        GenJnlLine.Amount := GenJnlLine.Amount - TotalPurchLine."TDS Amount";
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - TotalPurchLineLCY."TDS Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRoundAmountOnBeforeIncrAmount', '', true, true)]
    local procedure OnRoundAmountOnBeforeIncrAmount(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; PurchLineQty: Decimal; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Usedate: Date;
    begin
        if PurchaseHeader."Currency Code" <> '' then begin
            if PurchaseHeader."Posting Date" = 0D then
                Usedate := WorkDate
            else
                Usedate := PurchaseHeader."Posting Date";

            PurchaseLine."TDS Amount" :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          Usedate, PurchaseHeader."Currency Code",
                          TotalPurchLine."TDS Amount", PurchaseHeader."Currency Factor")) -
                      TotalPurchLineLCY."TDS Amount";
            PurchaseLine."TDS Base Amount" :=
                    Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          Usedate, PurchaseHeader."Currency Code",
                          TotalPurchLine."TDS Base Amount", PurchaseHeader."Currency Factor")) -
                      TotalPurchLineLCY."TDS Base Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterIncrAmount', '', false, false)]
    local procedure OnAfterIncrAmount(var TotalPurchLine: Record "Purchase Line"; PurchLine: Record "Purchase Line");
    begin
        Increment(TotalPurchLine."TDS Base Amount", PurchLine."TDS Base Amount");
        Increment(TotalPurchLine."TDS Amount", PurchLine."TDS Amount");
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckAndUpdate', '', false, false)]
    // local procedure OnAfterCheckAndUpdate(var PurchaseHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    // var
    //     Currency: Record Currency;

    // begin
    //     if Currency.get(PurchaseHeader."Currency Code") then;
    //     PurchaseHeader.CalculateTDS(Currency);
    // end;

    //Sales TDS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterReverseAmount', '', false, false)]
    local procedure OnAfterReverseAmountSalesTDS(var SalesLine: Record "Sales Line")
    begin
        SalesLine."TDS Amount" := -SalesLine."TDS Amount";
        SalesLine."TDS Base Amount" := -SalesLine."TDS Base Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJnlLine.Amount := -(TotalSalesLine."Amount Including VAT" - TotalSalesLine."TDS Amount");
        GenJnlLine."Amount (LCY)" := -(TotalSalesLineLCY."Amount Including VAT" - TotalSalesLineLCY."TDS Amount");//
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostBalancingEntry', '', false, false)]
    local procedure OnBeforePostBalancingEntrySalesTDS(SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlLine: Record "Gen. Journal Line"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line")
    begin
        GenJnlLine.Amount := GenJnlLine.Amount - TotalSalesLine."TDS Amount";
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" - TotalSalesLineLCY."TDS Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterIncrAmount', '', false, false)]
    local procedure OnAfterIncrAmountSalesTDS(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var TotalSalesLine: Record "Sales Line")
    begin
        Increment(TotalSalesLine."TDS Base Amount", SalesLine."TDS Base Amount");
        Increment(TotalSalesLine."TDS Amount", SalesLine."TDS Amount");
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckAndUpdate', '', false, false)]
    // local procedure OnAfterCheckAndUpdateSalesTDS(CommitIsSuppressed: Boolean; PreviewMode: Boolean; var SalesHeader: Record "Sales Header")
    // var
    //     Currency: Record Currency;
    // begin
    //     if Currency.get(SalesHeader."Currency Code") then;
    //     SalesHeader.CalculateTDS(currency);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFillInvoicePostBuffer', '', false, false)]

    // local procedure OnAfterFillInvoicePostBufferSalesTDS(var InvoicePostBuffer: Record "Invoice Post. Buffer"; SalesLine: Record "Sales Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer"; CommitIsSuppressed: Boolean)
    // begin
    //     SetTDSAccountSalesTDS(InvoicePOstBuffer, SalesLine);
    //     SetTDSAmounts(InvoicePostBuffer, SalesLine."TDS Amount", SalesLine."TDS Base Amount");
    //     UpdateTDSFieldsSalesTDS(SalesLine, InvoicePostBuffer);
    // end;

    // local procedure SetTDSAccountSalesTDS(var InvoicePostBuffer: Record "Invoice Post. Buffer"; SalesLine: Record "Sales Line")
    // begin
    //     //TDS1.00
    //     IF SalesLine."TDS Group" <> '' THEN
    //         InvoicePostBuffer."TDS Group" := SalesLine."TDS Group";
    //     IF SalesLine."TDS %" <> 0 THEN
    //         InvoicePostBuffer."TDS %" := SalesLine."TDS %";
    //     IF SalesLine."TDS Type" <> SalesLine."TDS Type"::" " THEN
    //         InvoicePostBuffer."TDS Type" := SalesLine."TDS Type";
    //     //TDS1.00
    // end;

    // procedure UpdateTDSFieldsSalesTDS(var SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    // var
    // begin
    //     //TDS1.00
    //     IF SalesLine."TDS Group" <> '' THEN
    //         InvoicePostBuffer."TDS Group" := SalesLine."TDS Group";
    //     IF SalesLine."TDS %" <> 0 THEN
    //         InvoicePostBuffer."TDS%" := SalesLine."TDS %";
    //     IF SalesLine."TDS Type" <> SalesLine."TDS Type"::" " THEN
    //         InvoicePostBuffer."TDS Type" := SalesLine."TDS Type";
    //     //TDS1.00
    // end;

    var
        VendorName: Text[50];
        Vendor: Record Vendor;
        GLAccountName: Text[50];
        GLAccount: Record "G/L Account";
        TDSpostingGroup: Record "TDS Posting Group";
        GLAccountNo: Code[20];
        TDSPostSetup: Record "TDS Posting Group";
        TDSLine: Record "Gen. Journal Line";
        NewTDSEntry: Record "TDS Entry";
        ReversedTDSEntry: Record "TDS Entry";
        CannotReverseErr: TextConst ENU = 'You cannot reverse the transaction, because it has already been reversed.';
        TDSEntry: Record "TDS Entry";
        ToGLEntryNo: Integer;
        Text030: Label 'TDS Entry';
        

}