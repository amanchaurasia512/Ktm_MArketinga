tableextension 50426 "Reversal Entry_ktm" extends "Reversal Entry"
{
    fields
    {
        modify("Entry Type")
        {
            OptionCaption = ' ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Maintenance,VAT,Employee,TDS';

            //Unsupported feature: Property Modification (OptionString) on ""Entry Type"(Field 2)".

        }
        modify("Entry No.")
        {
            TableRelation = IF ("Entry Type" = CONST("G/L Account")) "G/L Entry" ELSE
            IF ("Entry Type" = CONST(Customer)) "Cust. Ledger Entry" ELSE
            IF ("Entry Type" = CONST(Vendor)) "Vendor Ledger Entry" ELSE
            IF ("Entry Type" = CONST("Bank Account")) "Bank Account Ledger Entry" ELSE
            IF ("Entry Type" = CONST("Fixed Asset")) "FA Ledger Entry" ELSE
            IF ("Entry Type" = CONST(Maintenance)) "Maintenance Ledger Entry" ELSE
            IF ("Entry Type" = CONST(VAT)) "VAT Entry";
        }
        modify("Source No.")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Source Type" = CONST(Employee)) Employee;
        }
        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
    }

    //Unsupported feature: Code Modification on "CopyReverseFilters(PROCEDURE 15)".

    //procedure CopyReverseFilters();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GLEntry2.COPY(GLEntry);
    CustLedgEntry2.COPY(CustLedgEntry);
    VendLedgEntry2.COPY(VendLedgEntry);
    EmployeeLedgerEntry2.COPY(EmployeeLedgerEntry);
    BankAccLedgEntry2.COPY(BankAccLedgEntry);
    VATEntry2.COPY(VATEntry);
    FALedgEntry2.COPY(FALedgEntry);
    MaintenanceLedgEntry2.COPY(MaintenanceLedgEntry);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    TDSEntry2.COPY(TDSEntry); //TDS1.00
    */
    //end;

    //Unsupported feature: Property Deletion (Attributes) on "Caption(PROCEDURE 3)".

    //Unsupported feature: Code Modification on "CheckFAPostingDate(PROCEDURE 24)".

    //procedure CheckFAPostingDate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (AllowPostingFrom = 0D) AND (AllowPostingto = 0D) THEN BEGIN
      IF USERID <> '' THEN
        IF UserSetup.GET(USERID) THEN BEGIN
    #4..9
        AllowPostingto := FASetup."Allow FA Posting To";
      END;
      IF AllowPostingto = 0D THEN
        AllowPostingto := 1Vendor19998D;
    END;
    IF (FAPostingDate < AllowPostingFrom) OR (FAPostingDate > AllowPostingto) THEN
      ERROR(Text005,Caption,EntryNo,FALedgEntry.FIELDCAPTION("FA Posting Date"));
    IF FAPostingDate > MaxPostingDate THEN
      MaxPostingDate := FAPostingDate;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
        //AllowPostingto := 31129998D;//format error
    #14..18
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: PrevDoc) (VariableCollection) on "VerifyReversalEntries(PROCEDURE 25)".


    //Unsupported feature: Variable Insertion (Variable: CurrDoc) (VariableCollection) on "VerifyReversalEntries(PROCEDURE 25)".



    //Unsupported feature: Code Modification on "VerifyReversalEntries(PROCEDURE 25)".

    //procedure VerifyReversalEntries();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InsertReversalEntry(Number,RevType);
    CLEAR(TempReversalEntry);
    CLEAR(ReversalEntry2);
    IF ReversalEntry2.FINDSET THEN
      REPEAT
        IF TempReversalEntry.NEXT = 0 THEN
          EXIT(FALSE);
        IF NOT TempReversalEntry.Equal(ReversalEntry2) THEN
          EXIT(FALSE);
      UNTIL ReversalEntry2.NEXT = 0;
    EXIT(TempReversalEntry.NEXT = 0);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3

    //KMT2017CU5 >>
    IF ReversalEntry2.FINDSET THEN REPEAT
      CurrDoc := ReversalEntry2."Document No.";
      IF (PrevDoc <> '') AND (PrevDoc <> CurrDoc) THEN
        ERROR('Different Document No. Found while reverse.');
      PrevDoc := CurrDoc;
      ReversalEntry2.TESTFIELD("Document Type",ReversalEntry2."Document Type"::" ");
    UNTIL ReversalEntry2.NEXT = 0;
    //KMT2016CU5 <<


    #4..11
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: TDSEntry) (ParameterCollection) on "CheckTDS(PROCEDURE 41)".


    //Unsupported feature: Property Deletion (Attributes) on "SetHideWarningDialogs(PROCEDURE 41)".


    //Unsupported feature: Property Modification (Name) on "SetHideWarningDialogs(PROCEDURE 41)".


    //Unsupported feature: Property Insertion (Local) on "SetHideWarningDialogs(PROCEDURE 41)".




    procedure SetHideWarningDialogs_ktm()
    begin
        CheckPostingDate(
       TDSEntry."Posting Date", TDSEntry.TABLECAPTION, TDSEntry.FIELDCAPTION("Entry No."),
       TDSEntry."Entry No.");
        IF TDSEntry.Closed THEN
            ERROR(
              Text006, TDSEntry.TABLECAPTION, TDSEntry."Entry No.");
        IF TDSEntry.Reversed THEN
            AlreadyReversedEntry(TDSEntry.TABLECAPTION, TDSEntry."Entry No.");
    end;

    procedure CopyFromVATEntry(VATEntry: Record "VAT Entry")
    begin
        "Entry No." := VATEntry."Entry No.";
        "Posting Date" := VATEntry."Posting Date";
        "Source Code" := VATEntry."Source Code";
        "Transaction No." := VATEntry."Transaction No.";
        Amount := VATEntry.Amount;
        "Amount (LCY)" := VATEntry.Amount;
        "Document Type" := VATEntry."Document Type";
        "Document No." := VATEntry."Document No.";
        PAGE.RUN(0, TDSEntry);
        OnAfterCopyFromVATEntry(Rec, VATEntry);
    end;

    procedure CopyFromVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        "Entry No." := VendLedgEntry."Entry No.";
        "Posting Date" := VendLedgEntry."Posting Date";
        "Source Code" := VendLedgEntry."Source Code";
        "Journal Batch Name" := VendLedgEntry."Journal Batch Name";
        "Transaction No." := VendLedgEntry."Transaction No.";
        "Currency Code" := VendLedgEntry."Currency Code";
        Description := VendLedgEntry.Description;
        VendLedgEntry.CALCFIELDS(Amount, "Debit Amount", "Credit Amount",
          "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        Amount := VendLedgEntry.Amount;
        "Debit Amount" := VendLedgEntry."Debit Amount";
        "Credit Amount" := VendLedgEntry."Credit Amount";
        "Amount (LCY)" := VendLedgEntry."Amount (LCY)";
        "Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
        "Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
        "Document Type" := VendLedgEntry."Document Type";
        "Document No." := VendLedgEntry."Document No.";
        "Bal. Account Type" := VendLedgEntry."Bal. Account Type";
        "Bal. Account No." := VendLedgEntry."Bal. Account No.";

        OnAfterCopyFromVendLedgEntry(Rec, VendLedgEntry);
    end;

    procedure CopyFromEmployeeLedgerEntry(EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
        "Entry No." := EmployeeLedgerEntry."Entry No.";
        "Posting Date" := EmployeeLedgerEntry."Posting Date";
        "Source Code" := EmployeeLedgerEntry."Source Code";
        "Journal Batch Name" := EmployeeLedgerEntry."Journal Batch Name";
        "Transaction No." := EmployeeLedgerEntry."Transaction No.";
        "Currency Code" := EmployeeLedgerEntry."Currency Code";
        Description := EmployeeLedgerEntry.Description;
        EmployeeLedgerEntry.CALCFIELDS(
          Amount, "Debit Amount", "Credit Amount", "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
        Amount := EmployeeLedgerEntry.Amount;
        "Debit Amount" := EmployeeLedgerEntry."Debit Amount";
        "Credit Amount" := EmployeeLedgerEntry."Credit Amount";
        "Amount (LCY)" := EmployeeLedgerEntry."Amount (LCY)";
        "Debit Amount (LCY)" := EmployeeLedgerEntry."Debit Amount (LCY)";
        "Credit Amount (LCY)" := EmployeeLedgerEntry."Credit Amount (LCY)";
        "Document Type" := EmployeeLedgerEntry."Document Type";
        "Document No." := EmployeeLedgerEntry."Document No.";
        "Bal. Account Type" := EmployeeLedgerEntry."Bal. Account Type";
        "Bal. Account No." := EmployeeLedgerEntry."Bal. Account No.";

        OnAfterCopyFromEmplLedgEntry(Rec, EmployeeLedgerEntry);
    end;

    local procedure InsertCustTempRevertTransNo(var TempRevertTransactionNo: Record Integer temporary; CustLedgEntryNo: Integer)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        //DtldCustLedgEntry.GET(CustLedgEntryNo);
        //IF DtldCustLedgEntry."Transaction No." <> 0 THEN BEGIN
        //  TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
        //IF TempRevertTransactionNo.INSERT THEN;
        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntryNo);
        DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);    //changed by oman (changed true to false)
        IF DtldCustLedgEntry.FINDSET THEN BEGIN
            REPEAT
                TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
                IF TempRevertTransactionNo.INSERT THEN;
            UNTIL DtldCustLedgEntry.NEXT = 0;
        END;
    end;

    procedure CheckTDS(var TDSEntry: Record "TDS Entry")
    //TDS1.00

    begin

        CheckPostingDate(TDSEntry."Posting Date", TDSEntry.TABLECAPTION, TDSEntry.FIELDCAPTION("Entry No."),
          TDSEntry."Entry No.");

        IF TDSEntry.Closed THEN
            ERROR(Text006, TDSEntry.TABLECAPTION, TDSEntry."Entry No.");
        IF TDSEntry.Reversed THEN
            AlreadyReversedEntry(TDSEntry.TABLECAPTION, TDSEntry."Entry No.");
        //TDS1.00
    end;

    local procedure InsertVendTempRevertTransNo(var TempRevertTransactionNo: Record Integer temporary; VendLedgEntryNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin

        //DtldVendLedgEntry.GET(VendLedgEntryNo);
        //IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
        //TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
        //IF TempRevertTransactionNo.INSERT THEN;
        DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);  //changed by oman (changed true to false)
        IF DtldVendLedgEntry.FINDSET THEN BEGIN
            REPEAT
                TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
                IF TempRevertTransactionNo.INSERT THEN;
            UNTIL DtldVendLedgEntry.NEXT = 0;
        END;
    end;

    local procedure InsertEmplTempRevertTransNo(var TempRevertTransactionNo: Record Integer temporary; EmployeeLedgEntryNo: Integer)
    var
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
    begin
        DetailedEmployeeLedgerEntry.GET(EmployeeLedgEntryNo);
        IF DetailedEmployeeLedgerEntry."Transaction No." <> 0 THEN BEGIN
            TempRevertTransactionNo.Number := DetailedEmployeeLedgerEntry."Transaction No.";
            IF TempRevertTransactionNo.INSERT THEN;
        END;
    end;

    local procedure InsertTempRevertTransactionNoUnappliedEmployeeEntries(var TempRevertTransactionNo: Record Integer temporary; var DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    begin
        DetailedEmployeeLedgerEntry.SETRANGE(Unapplied, TRUE);
        IF DetailedEmployeeLedgerEntry.FINDSET THEN
            REPEAT
                InsertEmplTempRevertTransNo(TempRevertTransactionNo, DetailedEmployeeLedgerEntry."Unapplied by Entry No.");
            UNTIL DetailedEmployeeLedgerEntry.NEXT = 0;
        DetailedEmployeeLedgerEntry.SETRANGE(Unapplied);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCaption(ReversalEntry: Record "Reversal Entry"; var NewCaption: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckEntries()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckBankAcc(BankAccount: Record "Bank Account"; BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckGLAcc(var GLAccount: Record "G/L Account"; GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckCust(Customer: Record Customer; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckVend(Vendor: Record "Vendor"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckEmpl(Employee: Record Employee; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckFA(FixedAsset: Record "Fixed Asset"; FALedgerEntry: Record "FA Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckMaintenance(FixedAsset: Record "Fixed Asset"; MaintenanceLedgerEntry: Record "Maintenance Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckVAT(var VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyFromVATEntry(var ReversalEntry: Record "Reversal Entry"; VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyFromVendLedgEntry(var ReversalEntry: Record "Reversal Entry"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyFromEmplLedgEntry(var ReversalEntry: Record "Reversal Entry"; EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterInsertReversalEntry(var TempRevertTransactionNo: Record Integer; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer; var TempReversalEntry: Record "Reversal Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetReverseFilter(Number: Integer; RevType: Option Transaction,Register; GLRegister: Record "G/L Register")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckEntries(ReversalEntry: Record "Reversal Entry"; TableID: Integer; var SkipCheck: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckGLAcc(var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckRegister(RegisterNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReverseEntries(Number: Integer; RevType: Integer; var IsHandled: Boolean)
    begin
    end;

    procedure InsertFromTDSEntry(var TempRevertTransactionNo: Record Integer temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        TDSEntry: Record "TDS Entry";
        ReversalEntry: Record "Reversal Entry";
    begin
        // TDS1.00
        TempRevertTransactionNo.FINDSET;
        REPEAT
            IF RevType = RevType::Transaction THEN
                TDSEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
            IF TDSEntry.FINDSET THEN
                REPEAT
                    CLEAR(ReversalEntry);
                    IF RevType = RevType::Register THEN
                        ReversalEntry."G/L Register No." := Number;
                    ReversalEntry."Reversal Type" := RevType;
                    //ReversalEntry."Entry Type" := ReversalEntry."Entry Type"::TDS;
                    ReversalEntry."Entry No." := TDSEntry."Entry No.";
                    ReversalEntry."Posting Date" := TDSEntry."Posting Date";
                    ReversalEntry."Source Code" := TDSEntry."Source Code";
                    ReversalEntry."Transaction No." := TDSEntry."Transaction No.";
                    ReversalEntry.Amount := TDSEntry."TDS Amount";
                    ReversalEntry."Amount (LCY)" := TDSEntry."TDS Amount";
                    //ReversalEntry."Document Type" := TDSEntry."Document Type";
                    ReversalEntry."Document No." := TDSEntry."Document No.";
                    ReversalEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    ReversalEntry.INSERT;
                UNTIL TDSEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;
        // TDS1.00
    end;

    procedure SetTDSEntry(NewIsTDSEntry: Boolean)
    begin
        IsTDSEntry := NewIsTDSEntry;
    end;

    //Unsupported feature: Property Modification (Id) on "InsertFromCustLedgEntry(PROCEDURE 34).Cust(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "InsertFromCustLedgEntry(PROCEDURE 34).DtldCustLedgEntry(Variable 1004)".


    //Unsupported feature: Deletion (ParameterCollection) on "CopyFromVATEntry(PROCEDURE 47).VATEntry(Parameter 1001)".



    //Unsupported feature: Property Modification (Id) on "GLSetup(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //GLSetup : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GLSetup : 1937;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TempReversalEntry(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //TempReversalEntry : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TempReversalEntry : 1936;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GLEntry(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //GLEntry : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GLEntry : 1935;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CustLedgEntry(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //CustLedgEntry : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CustLedgEntry : 1934;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "VendLedgEntry(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //VendLedgEntry : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //VendLedgEntry : 1932;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "EmployeeLedgerEntry(Variable 1031)".

    //var
    //>>>> ORIGINAL VALUE:
    //EmployeeLedgerEntry : 1031;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //EmployeeLedgerEntry : 1938;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "BankAccLedgEntry(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //BankAccLedgEntry : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BankAccLedgEntry : 1931;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "VATEntry(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //VATEntry : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //VATEntry : 1930;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "FALedgEntry(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //FALedgEntry : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //FALedgEntry : 1929;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "MaintenanceLedgEntry(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //MaintenanceLedgEntry : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //MaintenanceLedgEntry : 1928;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GLReg(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //GLReg : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GLReg : 1927;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text000(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : 1010;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : 1926;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "FAReg(Variable 1015)".

    //var
    //>>>> ORIGINAL VALUE:
    //FAReg : 1015;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //FAReg : 1925;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GenJnlCheckLine(Variable 1011)".

    //var
    //>>>> ORIGINAL VALUE:
    //GenJnlCheckLine : 1011;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GenJnlCheckLine : 1924;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text001(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text001 : 1012;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text001 : 19Vendor;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AllowPostingFrom(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //AllowPostingFrom : 1014;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AllowPostingFrom : 1922;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AllowPostingto(Variable 1013)".

    //var
    //>>>> ORIGINAL VALUE:
    //AllowPostingto : 1013;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AllowPostingto : 1921;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text002(Variable 1016)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text002 : 1016;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text002 : 1920;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text003(Variable 1017)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text003 : 1017;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text003 : 1919;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text004(Variable 1018)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text004 : 1018;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text004 : 1918;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text005(Variable 1020)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text005 : 1020;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text005 : 1917;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text006(Variable 1022)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text006 : 1022;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text006 : 1916;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text007(Variable 1021)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text007 : 1021;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text007 : 1915;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text008(Variable 1019)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text008 : 1019;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text008 : 1914;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "MaxPostingDate(Variable 1024)".

    //var
    //>>>> ORIGINAL VALUE:
    //MaxPostingDate : 1024;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //MaxPostingDate : 1913;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CannotReverseDeletedErr(Variable 1025)".

    //var
    //>>>> ORIGINAL VALUE:
    //CannotReverseDeletedErr : 1025;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CannotReverseDeletedErr : 1912;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text010(Variable 10Vendor)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text010 : 10Vendor;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text010 : 1911;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text011(Variable 1026)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text011 : 1026;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text011 : 1910;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PostedAndAppliedSameTransactionErr(Variable 1028)".

    //var
    //>>>> ORIGINAL VALUE:
    //PostedAndAppliedSameTransactionErr : 1028;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PostedAndAppliedSameTransactionErr : 1909;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text013(Variable 1039)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text013 : 1039;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text013 : 1908;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "HideDialog(Variable 1030)".

    //var
    //>>>> ORIGINAL VALUE:
    //HideDialog : 1030;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //HideDialog : 1907;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UnrealizedVATReverseErr(Variable 1027)".

    //var
    //>>>> ORIGINAL VALUE:
    //UnrealizedVATReverseErr : 1027;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UnrealizedVATReverseErr : 1906;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "HideWarningDialogs(Variable 1029)".

    // var
    // >>>> ORIGINAL VALUE:
    // HideWarningDialogs : 1029;
    // Variable type has not been exported.
    // >>>> MODIFIED VALUE:
    // HideWarningDialogs : 1905;
    // Variable type has not been exported.

    LOCAL procedure CheckPostingDate(PostingDate: Date; Caption: Text[50]; CaptionEntryNo: Text[50]; EntryNo: Integer)
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text001: Label 'You cannot reverse %1 No. %2 because the posting date is not within the allowed posting period.';
        MaxPostingDate: Date;
    begin
        IF GenJnlCheckLine.DateNotAllowed(PostingDate) THEN
            ERROR(Text001, Caption, EntryNo);
        IF PostingDate > MaxPostingDate THEN
            MaxPostingDate := PostingDate;
    end;

    var
        TDSEntry: Record "TDS Entry";
        IsTDSEntry: Boolean;
        ReversalEntry: Record "Reversal Entry";
        Text006: Label 'You cannot reverse %1 No. %2 because the entry is closed.';
}

