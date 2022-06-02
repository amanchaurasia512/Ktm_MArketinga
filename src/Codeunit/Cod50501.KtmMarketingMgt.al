codeunit 50501 "KtmMarketing.Mgt"
{
    procedure CheckDocNoandPostingDateCombo(var GenJnlLine: Record "Gen. Journal Line")
    var
        xGenJnlLine: Record "Gen. Journal Line";
    begin
        WITH GenJnlLine DO BEGIN
            xGenJnlLine.RESET;
            xGenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            xGenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            xGenJnlLine.SETRANGE("Document No.", GenJnlLine."Document No.");
            IF xGenJnlLine.FINDFIRST THEN
                REPEAT
                    IF xGenJnlLine."Posting Date" <> GenJnlLine."Posting Date" THEN
                        ERROR('Multiple Posting Date with same Document No. cannot be posted');
                UNTIL xGenJnlLine.NEXT = 0;
        END;
    end;

    procedure GetTDSGLCodeName(var GenJnlLine: Record "Gen. Journal Line")
    var
        TDSpostingGroup: Record "TDS Posting Group";
        GLAccount: Record "G/L Account";
    BEGIN
        //TDS1.00
        CLEAR(GLAccountNo);
        CLEAR(GLAccountName);
        WITH GenJnlLine DO BEGIN
            IF "TDS Group" <> '' THEN BEGIN
                TDSpostingGroup.RESET;
                TDSpostingGroup.SETRANGE(Code, "TDS Group");
                IF TDSpostingGroup.FINDFIRST THEN BEGIN
                    GLAccountNo := TDSpostingGroup."GL Account No.";
                    GLAccount.RESET;
                    GLAccount.SETRANGE("No.", GLAccountNo);
                    IF GLAccount.FINDFIRST THEN
                        GLAccountName := GLAccount.Name;
                END;
            END;
        END;
        //TDS1.00
    END;

    PROCEDURE GetTDSSourceName(GenJnlLine: Record "Gen. Journal Line"): Text
    VAR
        Vendor: Record Vendor;
        Employee: Record Employee;
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
    BEGIN
        IF GenJnlLine."Party Type" = GenJnlLine."Party Type"::Vendor THEN BEGIN
            IF Vendor.GET(GenJnlLine."Party No.") THEN
                EXIT(Vendor.Name);
        END ELSE
            IF GenJnlLine."Party Type" = GenJnlLine."Party Type"::Customer THEN BEGIN
                IF Customer.GET(GenJnlLine."Party No.") THEN
                    EXIT(Customer.Name);
            END ELSE
                IF GenJnlLine."Party Type" = GenJnlLine."Party Type"::Employee THEN BEGIN
                    GLSetup.GET;
                    DimVal.RESET;
                    DimVal.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                    DimVal.SETRANGE(Code, GenJnlLine."Party No.");
                    IF DimVal.FINDFIRST THEN
                        EXIT(DimVal.Name);
                END;
        EXIT('');
    END;

    PROCEDURE CreateTDSJnlLine(var GenJournalLine: Record "Gen. Journal Line");
    VAR
        TDSLine: Record "Gen. Journal Line";
        TDSPostSetup: Record "TDS Posting Group";
        GenLineNo: Integer;
    BEGIN
        //TDS1.00
        WITH GenJournalLine DO BEGIN
            Gbl_Doc_No := "Document No.";
            GenLine.RESET;
            GenLine.SETRANGE("Journal Template Name", "Journal Template Name");
            GenLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
            IF GenLine.FINDLAST THEN
                GenLineNo := GenLine."Line No." + 10000
            ELSE
                GenLineNo := 10000;

            TDSPostSetup.RESET;
            TDSPostSetup.SETRANGE(Code, "TDS Group");
            TDSPostSetup.FINDFIRST;

            TDSLine.LOCKTABLE;
            TDSLine.INIT;
            TDSLine."Journal Template Name" := "Journal Template Name";
            TDSLine."Journal Batch Name" := "Journal Batch Name";
            TDSLine."Line No." := GenLineNo;
            TDSLine."Document Type" := "Document Type";
            TDSLine."Account Type" := TDSLine."Account Type"::"G/L Account";
            TDSLine."Account No." := TDSPostSetup."GL Account No.";
            TDSLine."Posting Date" := "Posting Date";
            TDSLine."Document Date" := "Document Date";
            TDSLine."Document No." := "Document No.";
            TDSLine.Description := Description; //TDSDesc; //pram
            TDSLine.Narration := Narration;
            TDSLine.VALIDATE(Amount, -"TDS Amount");
            TDSLine."Source Code" := "Source Code";
            TDSLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            TDSLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            TDSLine."Dimension Set ID" := "Dimension Set ID";
            TDSLine.Comment := Comment;
            TDSLine."Party Type" := "Party Type";
            TDSLine."Party No." := "Party No.";
            TDSLine."External Document No." := "External Document No.";
            TDSLine."Posting No. Series" := "Posting No. Series";
            TDSLine.INSERT;
        END;
        //TDS1.00
    END;

    procedure InsertTDS(var GenJournalLine: Record "Gen. Journal Line"; Doc_No: Code[20])
    var
        TDSEntry: Record "TDS Entry";
        TDSENTRy1: Record "TDS Entry";
        GenJnlLineRec: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        VendorName: Text[50];
        GLAccountName: Text[50];
        GLEntryNo: Integer;
    BEGIN
        //TDS1.00
        SourceCodeSetup.GET;
        GetTDSGLCodeName(GenJournalLine);

        WITH GenJournalLine DO BEGIN
            IF "TDS Group" <> '' THEN BEGIN
                IF (("Source Code" = SourceCodeSetup."General Journal") OR ("Source Code" = SourceCodeSetup."Payment Journal") OR
                  ("Source Code" = SourceCodeSetup."Cash Receipt Journal")) THEN BEGIN
                    GenJnlLineRec.RESET;
                    GenJnlLineRec.SETRANGE("Document No.", Doc_No);
                    GenJnlLineRec.SETRANGE("Posting Date", "Posting Date");
                    GenJnlLineRec.SETFILTER("Line No.", '<>%1', "Line No.");
                    GenJnlLineRec.SETFILTER("Party Type", '<>%1', GenJnlLineRec."Party Type"::" ");
                    GenJnlLineRec.SETFILTER("Party No.", '<>%1', ''); //party type and no filter added here //Amsa
                    GenJnlLineRec.FINDFIRST;
                END;

                TDSEntry1.INIT;
                TDSEntry.RESET;
                IF TDSEntry.FINDLAST THEN
                    TDSEntry1."Entry No." := TDSEntry."Entry No." + 1
                ELSE
                    TDSEntry1."Entry No." := 1;
                TDSEntry1."Posting Date" := GenJournalLine."Posting Date";
                TDSEntry1."Document No." := GenJournalLine."Document No.";
                IF GenJournalLine."Party Type" = GenJournalLine."Party Type"::Vendor THEN
                    TDSEntry1."Source Type" := TDSEntry1."Source Type"::Vendor
                ELSE
                    IF GenJournalLine."Party Type" = GenJournalLine."Party Type"::Customer THEN
                        TDSEntry1."Source Type" := TDSEntry1."Source Type"::Customer
                    ELSE
                        IF GenJournalLine."Party Type" = GenJournalLine."Party Type"::Employee THEN
                            TDSEntry1."Source Type" := TDSEntry1."Source Type"::Employee;

                IF (("Source Code" = SourceCodeSetup."General Journal") OR ("Source Code" = SourceCodeSetup."Payment Journal") OR
                 ("Source Code" = SourceCodeSetup."Cash Receipt Journal")) THEN BEGIN
                    TDSEntry1."Bill-to/Pay-to No." := GenJnlLineRec."Party No.";
                END ELSE BEGIN
                    TDSEntry1."Bill-to/Pay-to No." := GenJournalLine."Source No.";
                END;
                TDSEntry1."Source Name" := GetTDSSourceName(GenJnlLineRec);
                TDSEntry1."TDS Posting Group" := GenJournalLine."TDS Group";
                TDSEntry1."TDS%" := GenJournalLine."TDS%";
                TDSEntry1.Base := GenJournalLine."TDS Base Amount";
                TDSEntry1."TDS Amount" := GenJournalLine."TDS Amount";
                TDSEntry1."User ID" := USERID;
                TDSEntry1."Transaction No." := NextTransactionNo;
                TDSEntry1."Source Code" := GenJournalLine."Source Code";
                TDSEntry1."External Document No." := GenJournalLine."External Document No.";
                TDSEntry1."Document Date" := GenJournalLine."Document Date";
                TDSEntry1."Dimension Set ID" := GenJournalLine."Dimension Set ID";
                TDSEntry1."Shortcut Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
                TDSEntry1."Shortcut Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
                TDSEntry1."TDS Type" := GenJournalLine."TDS Type";
                TDSEntry1."Source Name" := VendorName;
                TDSEntry1."GL Account Name" := GLAccountName;
                TDSEntry1."Main G/L Account" := GenJournalLine."Main G/L Account";
                TDSEntry1."G/L Entry No." := GLEntryNo; //pram
                TDSEntry1.INSERT(TRUE);
            END;
        END;
        //TDS1.00
    END;

    PROCEDURE NextTdsEntryNo(): Integer;
    VAR
        TDSEntry1: Record "TDS Entry";
        TDSEntryNo: Integer;
    BEGIN
        //TDS1.00
        TDSEntry1.LOCKTABLE;
        TDSEntry1.RESET;
        IF TDSEntry1.FINDLAST THEN
            TDSEntryNo := TDSEntry1."Entry No." + 1
        ELSE
            TDSEntryNo := 1;
        EXIT(TDSEntryNo);
        //TDS1.00
    END;

    PROCEDURE GetPostingAccountNo(VATPostingSetup: Record "VAT Posting Setup"; VATEntry: Record "VAT Entry"; UnrealizedVAT: Boolean): Code[20];
    VAR
        TaxJurisdiction: Record "Tax Jurisdiction";
    BEGIN
        IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" THEN BEGIN
            VATEntry.TESTFIELD("Tax Jurisdiction Code");
            TaxJurisdiction.GET(VATEntry."Tax Jurisdiction Code");
            CASE VATEntry.Type OF
                VATEntry.Type::Sale:
                    EXIT(TaxJurisdiction.GetSalesAccount(UnrealizedVAT));
                VATEntry.Type::Purchase:
                    EXIT(TaxJurisdiction.GetPurchAccount(UnrealizedVAT));
            END;
        END;

        CASE VATEntry.Type OF
            VATEntry.Type::Sale:
                EXIT(VATPostingSetup.GetSalesAccount(UnrealizedVAT));
            VATEntry.Type::Purchase:
                EXIT(VATPostingSetup.GetPurchAccount(UnrealizedVAT));
        END;
    END;

    PROCEDURE InsertSalesJournalInvMaterialize(GeneralJournalLine: Record "Gen. Journal Line"; DocumentNo: Code[20]);
    VAR
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        IrdMgmt: Codeunit "IRD Mgt.";
        Cust: Record Customer;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    BEGIN
        CLEAR(RegisterofInvoiceNoSeries);
        RegisterofInvoiceNoSeries.INIT;
        RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Sales Cr.Memo Header";
        RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Credit Memo";
        RegisterofInvoiceNoSeries."Bill No" := GeneralJournalLine."Document No.";
        RegisterofInvoiceNoSeries."Fiscal Year" := IrdMgmt.GetNepaliFiscalYear(GeneralJournalLine."Posting Date");
        RegisterofInvoiceNoSeries."Bill Date" := GeneralJournalLine."Posting Date";
        RegisterofInvoiceNoSeries."Posting Time" := TIME;
        RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
        RegisterofInvoiceNoSeries."Customer Code" := GeneralJournalLine."Bill-to/Pay-to No.";
        RegisterofInvoiceNoSeries."Source Code" := GeneralJournalLine."Source Code";
        IF Cust.GET(GeneralJournalLine."Bill-to/Pay-to No.") THEN
            RegisterofInvoiceNoSeries."Customer Name" := Cust.Name;
        RegisterofInvoiceNoSeries."VAT Registration No." := GeneralJournalLine."VAT Registration No.";
        IrdMgmt.SetSyncStatus(RegisterofInvoiceNoSeries);
        RegisterofInvoiceNoSeries."Sync Status" := RegisterofInvoiceNoSeries."Sync Status"::"Sync In Progress";
        RegisterofInvoiceNoSeries.Amount := (GeneralJournalLine.Amount - GeneralJournalLine."VAT Amount");
        IF GeneralJournalLine."VAT %" > 0 THEN BEGIN
            RegisterofInvoiceNoSeries."TAX Amount" := GeneralJournalLine."VAT Amount";
            RegisterofInvoiceNoSeries."Taxable Amount" := (GeneralJournalLine.Amount - GeneralJournalLine."VAT Amount");
            RegisterofInvoiceNoSeries."Total Amount" := (GeneralJournalLine.Amount);
        END;
        RegisterofInvoiceNoSeries."Created By" := USERID;
        RegisterofInvoiceNoSeries."Is Bill Printed" := TRUE;
        RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
        RegisterofInvoiceNoSeries."Printed By" := USERID;
        RegisterofInvoiceNoSeries."Shortcut Dimension 1 Code" := GeneralJournalLine."Shortcut Dimension 1 Code";
        RegisterofInvoiceNoSeries."Shortcut Dimension 2 Code" := GeneralJournalLine."Shortcut Dimension 2 Code";
        RegisterofInvoiceNoSeries.INSERT;
    END;

    PROCEDURE GetPurchaseTDSVendorName(Vendor_No: Code[20]);
    VAR
        Vendor: Record Vendor;
    BEGIN
        //TDS1.00
        CLEAR(VendorName);
        Vendor.RESET;
        Vendor.SETRANGE("No.", Vendor_No);
        IF Vendor.FINDFIRST THEN
            VendorName := Vendor.Name;
        //TDS1.00
    END;

    //this two procedure were defined in Gen jnl post batch in ktm marketing 
    PROCEDURE ClearDataExchEntries(VAR PassedGenJnlLine: Record "Gen. Journal Line");
    VAR
        GenJnlLine: Record "Gen. Journal Line";
    BEGIN
        GenJnlLine.COPY(PassedGenJnlLine);
        IF GenJnlLine.FINDSET THEN
            REPEAT
                GenJnlLine.ClearDataExchangeEntries(TRUE);
            UNTIL GenJnlLine.NEXT = 0;
    END;

    PROCEDURE InsertSalesJournalInvMaterializeCheck(TableID: Integer; DocumentNo: Code[20]);
    VAR
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        IrdMgmt: Codeunit "IRD Mgt.";
        Cust: Record Customer;
        GLEntries: Record "G/L Entry";
    BEGIN
        CASE TableID OF
            DATABASE::"G/L Entry":
                BEGIN
                    //IF NOT GLEntries.GET(DocumentNo) THEN
                    //EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"G/L Entry";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Credit Memo";
                    RegisterofInvoiceNoSeries."Bill No" := GLEntries."Document No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := IrdMgmt.GetNepaliFiscalYear(GLEntries."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := GLEntries."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := TIME;
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := GLEntries."Party No.";
                    RegisterofInvoiceNoSeries."Source Code" := GLEntries."Source Code";
                    IF Cust.GET(GLEntries."Party No.") THEN BEGIN
                        RegisterofInvoiceNoSeries."Customer Name" := Cust.Name;
                        RegisterofInvoiceNoSeries."VAT Registration No." := Cust."VAT Registration No.";
                    END;
                    IrdMgmt.SetSyncStatus(RegisterofInvoiceNoSeries);
                    IrdMgmt.CalculateInvoiceTotals(DATABASE::"G/L Entry", GLEntries."Document No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Created By" := USERID;
                    RegisterofInvoiceNoSeries."Is Bill Printed" := TRUE;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := USERID;
                    //Agile SRT Jan 2nd 2019 >>
                    RegisterofInvoiceNoSeries."Shortcut Dimension 1 Code" := GLEntries."Global Dimension 1 Code";
                    RegisterofInvoiceNoSeries."Shortcut Dimension 2 Code" := GLEntries."Global Dimension 2 Code";
                    //Agile SRT Jan 2nd 2019 <<
                    RegisterofInvoiceNoSeries.INSERT;
                END;
        END;
    END;

    PROCEDURE SetSkipApplicationCheck(NewValue: Boolean);
    BEGIN
        SkipApplicationCheck := NewValue;
    END;

    PROCEDURE LogApply(ApplyItemLedgEntry: Record "Item Ledger Entry"; AppliedItemLedgEntry: Record "Item Ledger Entry");
    VAR
        ItemApplnEntry: Record "Item Application Entry";
    BEGIN
        ItemApplnEntry.INIT;
        IF AppliedItemLedgEntry.Quantity > 0 THEN BEGIN
            ItemApplnEntry."Item Ledger Entry No." := ApplyItemLedgEntry."Entry No.";
            ItemApplnEntry."Inbound Item Entry No." := AppliedItemLedgEntry."Entry No.";
            ItemApplnEntry."Outbound Item Entry No." := ApplyItemLedgEntry."Entry No.";
        END ELSE BEGIN
            ItemApplnEntry."Item Ledger Entry No." := AppliedItemLedgEntry."Entry No.";
            ItemApplnEntry."Inbound Item Entry No." := ApplyItemLedgEntry."Entry No.";
            ItemApplnEntry."Outbound Item Entry No." := AppliedItemLedgEntry."Entry No.";
        END;
        AddToApplicationLog(ItemApplnEntry, TRUE);
    END;

    PROCEDURE LogUnapply(ItemApplnEntry: Record "Item Application Entry");
    BEGIN
        AddToApplicationLog(ItemApplnEntry, FALSE);
    END;

    LOCAL PROCEDURE AddToApplicationLog(ItemApplnEntry: Record "Item Application Entry"; IsApplication: Boolean);
    BEGIN
        WITH TempItemApplnEntryHistory DO BEGIN
            IF FINDLAST THEN;
            "Primary Entry No." += 1;

            "Item Ledger Entry No." := ItemApplnEntry."Item Ledger Entry No.";
            "Inbound Item Entry No." := ItemApplnEntry."Inbound Item Entry No.";
            "Outbound Item Entry No." := ItemApplnEntry."Outbound Item Entry No.";

            "Cost Application" := IsApplication;
            INSERT;
        END;
    END;

    PROCEDURE ClearApplicationLog();
    BEGIN
        TempItemApplnEntryHistory.DELETEALL;
    END;

    PROCEDURE UndoApplications();
    VAR
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemApplnEntry: Record "Item Application Entry";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    BEGIN
        WITH TempItemApplnEntryHistory DO BEGIN
            ASCENDING(FALSE);
            IF FINDSET THEN
                REPEAT
                    IF "Cost Application" THEN BEGIN
                        ItemApplnEntry.SETRANGE("Inbound Item Entry No.", "Inbound Item Entry No.");
                        ItemApplnEntry.SETRANGE("Outbound Item Entry No.", "Outbound Item Entry No.");
                        ItemApplnEntry.FINDFIRST;
                        ItemJnlPostLine.UnApply(ItemApplnEntry);
                    END ELSE BEGIN
                        ItemLedgEntry.GET("Item Ledger Entry No.");
                        SetSkipApplicationCheck(TRUE);
                        ItemJnlPostLine.ReApply(ItemLedgEntry, "Inbound Item Entry No.");
                    END;
                UNTIL NEXT = 0;
            ClearApplicationLog;
            ASCENDING(TRUE);
        END;
    END;

    PROCEDURE ApplicationLogIsEmpty(): Boolean;
    BEGIN
        EXIT(TempItemApplnEntryHistory.ISEMPTY);
    END;

    PROCEDURE CopyShortcutDimensions(VAR ItemLedgerEntry: Record "Item Ledger Entry"; DimValueCode: ARRAY[8] OF Code[20]);
    BEGIN
        ItemLedgerEntry."Shortcut Dimension 3 Code" := DimValueCode[3];
        ItemLedgerEntry."Shortcut Dimension 4 Code" := DimValueCode[4];
        ItemLedgerEntry."Shortcut Dimension 5 Code" := DimValueCode[5];
        ItemLedgerEntry."Shortcut Dimension 6 Code" := DimValueCode[6];
        ItemLedgerEntry."Shortcut Dimension 7 Code" := DimValueCode[7];
        ItemLedgerEntry."Shortcut Dimension 8 Code" := DimValueCode[8];
    END;

    PROCEDURE CopyValueEntryShortcutDimensions(VAR ValueEntry: Record 5802; DimValueCode: ARRAY[8] OF Code[20]);
    BEGIN
        ValueEntry."Shortcut Dimension 3 Code" := DimValueCode[3];
        ValueEntry."Shortcut Dimension 4 Code" := DimValueCode[4];
        ValueEntry."Shortcut Dimension 5 Code" := DimValueCode[5];
        ValueEntry."Shortcut Dimension 6 Code" := DimValueCode[6];
        ValueEntry."Shortcut Dimension 7 Code" := DimValueCode[7];
        ValueEntry."Shortcut Dimension 8 Code" := DimValueCode[8];
    END;

    PROCEDURE DeleteWhseRqst(SalesHeader: Record "Sales Header");
    VAR
        WarehouseRequest: Record "Warehouse Request";
    BEGIN
        WarehouseRequest.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
        WarehouseRequest.SETRANGE("Source Type", DATABASE::"Sales Line");
        WarehouseRequest.SETRANGE("Source Subtype", SalesHeader."Document Type");
        WarehouseRequest.SETRANGE("Source No.", SalesHeader."No.");
        IF NOT WarehouseRequest.ISEMPTY THEN
            WarehouseRequest.DELETEALL;
    END;

    PROCEDURE SendToIRD(SalesHeader: Record 36);
    VAR
        CALMgt: Codeunit 50004;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    BEGIN
        CALMgt.StartRealTimeCBMSIntegration(SalesHeader, SalesInvHeader, SalesCrMemoHeader);
    END;

    PROCEDURE RetrieveILEFromPostedInvoice(VAR TempItemLedgEntry: Record 32 TEMPORARY; InvoiceRowID: Text[250]);
    VAR
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        SignFactor: Integer;
    BEGIN
        // retrieves a data set of Item Ledger Entries (Posted Invoices)

        ValueEntryRelation.SETCURRENTKEY("Source RowId");
        ValueEntryRelation.SETRANGE("Source RowId", InvoiceRowID);
        IF ValueEntryRelation.FIND('-') THEN BEGIN
            SignFactor := TableSignFactor2(InvoiceRowID);
            REPEAT
                ValueEntry.GET(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                IF TempItemLedgEntry."Entry Type" IN [TempItemLedgEntry."Entry Type"::Purchase, TempItemLedgEntry."Entry Type"::Sale] THEN
                    IF TempItemLedgEntry.Quantity <> 0 THEN
                        AddTempRecordToSet(TempItemLedgEntry, SignFactor);
            UNTIL ValueEntryRelation.NEXT = 0;
        END;
    END;

    PROCEDURE TableSignFactor(TableNo: Integer): Integer;
    BEGIN
        IF TableNo IN [
                       DATABASE::"Sales Line",
                       DATABASE::"Sales Shipment Line",
                       DATABASE::"Sales Invoice Line",
                       DATABASE::"Purch. Cr. Memo Line",
                       DATABASE::"Prod. Order Component",
                       DATABASE::"Transfer Shipment Line",
                       DATABASE::"Return Shipment Line",
                       DATABASE::"Planning Component",
                       DATABASE::"Posted Assembly Line",
                       DATABASE::"Service Line",
                       DATABASE::"Service Shipment Line",
                       DATABASE::"Service Invoice Line"]
        THEN
            EXIT(-1);

        EXIT(1);
    END;

    PROCEDURE TableSignFactor2(RowID: Text[250]): Integer;
    VAR
        TableNo: Integer;
    BEGIN
        RowID := DELCHR(RowID, '<', '"');
        RowID := COPYSTR(RowID, 1, STRPOS(RowID, '"') - 1);
        IF EVALUATE(TableNo, RowID) THEN
            EXIT(TableSignFactor(TableNo));

        EXIT(1);
    END;

    PROCEDURE AddTempRecordToSet(VAR TempItemLedgEntry: Record "Item Ledger Entry" TEMPORARY; SignFactor: Integer);
    VAR
        TempItemLedgEntry2: Record "Item Ledger Entry" TEMPORARY;
        ItmeTrackingManagement: Codeunit "Item Tracking Management";
    BEGIN
        IF SignFactor <> 1 THEN BEGIN
            TempItemLedgEntry.Quantity *= SignFactor;
            TempItemLedgEntry."Remaining Quantity" *= SignFactor;
            TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        END;
        ItmeTrackingManagement.RetrieveAppliedExpirationDate(TempItemLedgEntry);
        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.RESET;
        TempItemLedgEntry.SETRANGE("Serial No.", TempItemLedgEntry2."Serial No.");
        TempItemLedgEntry.SETRANGE("Lot No.", TempItemLedgEntry2."Lot No.");
        TempItemLedgEntry.SETRANGE("Warranty Date", TempItemLedgEntry2."Warranty Date");
        TempItemLedgEntry.SETRANGE("Expiration Date", TempItemLedgEntry2."Expiration Date");
        IF TempItemLedgEntry.FINDFIRST THEN BEGIN
            TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
            TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
            TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
            TempItemLedgEntry.MODIFY;
        END ELSE
            TempItemLedgEntry.INSERT;

        TempItemLedgEntry.RESET;
    END;

    PROCEDURE GetServInvHdrNo(): Code[20];
    BEGIN
        EXIT(ServInvHeader."No.");
    END;

    PROCEDURE GetServCrHdrNo(): Code[20];
    BEGIN
        EXIT(ServCrMemoHeader."No.");
    END;

    PROCEDURE GetServShptHdrNo_(): Code[20];
    BEGIN
        EXIT(ServShptHeader."No.");
    END;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeShowDimensions', '', false, false)]
    local procedure OnBeforeShowDimensions(var GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        GenJournalLine."Salespers./Purch. Code" := xGenJournalLine."Shortcut Dimension 2 Code";
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
        Navigate: Page Navigate;
    begin
        Navigate.ShowTDSEntries(TableID, DocNoFilter, PostingDateFilter);

    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Charge Assignment (Purch)", 'OnAfterUpdateQty', '', false, false)]
    local procedure OnAfterUpdateQty(var ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; var QtyToReceiveBase: Decimal; var QtyReceivedBase: Decimal; var QtyToShipBase: Decimal; var QtyShippedBase: Decimal)
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        ItemChargeAssignmentPurch.PragyapanPatra := PurchRcptLine.PragyapanPatra;
        ItemChargeAssignmentPurch."Letter of Credit/Telex Trans." := PurchRcptLine."Letter of Credit/Telex Trans.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeRunCheck', '', false, false)]
    local procedure OnBeforeRunCheck(var GenJournalLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        //SRT July 7th 2019 >>
        IF GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Purchase THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD("VAT Lock Date");
            IF GenJournalLine."Posting Date" <= GLSetup."VAT Lock Date" THEN
                ERROR('VAT has been already booked for document %1', GenJournalLine."Document No.");
        END;
        //SRT July 7th 2019 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        //KMT2016CU5 >>
        DtldVendLedgEntry.PragyapanPatra := VendLedgEntry.PragyapanPatra;
        DtldVendLedgEntry."Letter of Credit/Telex Trans." := VendLedgEntry."Letter of Credit/Telex Trans.";
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeStartOrContinuePosting', '', false, false)]
    local procedure OnBeforeStartOrContinuePosting(var GenJnlLine: Record "Gen. Journal Line"; LastDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder; LastDocNo: Code[20]; LastDate: Date; var NextEntryNo: Integer)
    var
        GLAccount: Record "G/L Account";
    begin
        CheckDocNoandPostingDateCombo(GenJnlLine);   //KMT2016CU5
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN
            IF GLAccount.GET(GenJnlLine."Account No.") THEN BEGIN //pram
                IF GLAccount."LC Code Mandatory" THEN
                    GenJnlLine.TESTFIELD("Letter of Credit/Telex Trans.");
                IF GLAccount."TR Code Mandatory" THEN
                    GenJnlLine.TESTFIELD("T/R");
                IF GLAccount."Demand loan code Mandatory" THEN
                    GenJnlLine.TESTFIELD("demand loan");
            END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnCodeOnAfterRunExhangeAccGLJournalLine', '', false, false)]
    local procedure OnCodeOnAfterRunExhangeAccGLJournalLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
        //TDS1.00 >>
        InsertTDS(GenJnlLine, Gbl_Doc_No);
        //TDS1.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnBeforeInitCustLedgEntry', '', false, false)]
    local procedure OnPostCustOnBeforeInitCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var CustPostingGr: Record "Customer Posting Group")
    begin
        //KMT2016CU5 >>
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", GenJnlLine."Account No.");
        IF GLAccount.FINDFIRST THEN BEGIN
            IF GLAccount."To Sales/Purch. (LCY)" THEN BEGIN
                IF (GenJournalLine."Source Code" = 'PURCHJNL') OR (GenJournalLine."Source Code" = 'SALESJNL') THEN
                    GenJournalLine.TESTFIELD("Sales/Purch. (LCY)");
            END;
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostCust', '', false, false)]
    local procedure OnAfterPostCust(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)

    begin
        //KMT2016CU5 >>
        IF Cust."Also Vendor" THEN BEGIN
            CustVendLedgEntry.LOCKTABLE;
            CustVendLedgEntry.INIT;
            IF CustVendLedgEntry.FINDLAST THEN
                CustVendLedgEntry."Entry No." += 1
            ELSE
                CustVendLedgEntry."Entry No." := 1;
            CustVendLedgEntry.CopyFromCustLedgEntry(CustLedgEntry);
            CustVendLedgEntry.INSERT(TRUE);
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostVendOnBeforeInitVendLedgEntry', '', false, false)]
    local procedure OnPostVendOnBeforeInitVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var VendPostingGr: Record "Vendor Posting Group")
    begin
        //KMT2016CU5 >>
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", GenJnlLine."Account No.");
        IF GLAccount.FINDFIRST THEN BEGIN
            IF GLAccount."To Sales/Purch. (LCY)" THEN BEGIN
                IF (GenJournalLine."Source Code" = 'PURCHJNL') OR (GenJournalLine."Source Code" = 'SALESJNL') THEN
                    GenJournalLine.TESTFIELD("Sales/Purch. (LCY)");
            END;
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostVend', '', false, false)]
    local procedure OnAfterPostVend(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
        //KMT2016CU5 >>
        IF Vend."Also Customer" THEN BEGIN
            CustVendLedgEntry.LOCKTABLE;
            CustVendLedgEntry.INIT;
            IF CustVendLedgEntry.FINDLAST THEN
                CustVendLedgEntry."Entry No." += 1
            ELSE
                CustVendLedgEntry."Entry No." := 1;
            CustVendLedgEntry.CopyFromVendLedgEntry(VendLedgEntry);
            CustVendLedgEntry.INSERT(TRUE);
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLRegister', '', false, false)]
    local procedure OnAfterInitGLRegister(var GLRegister: Record "G/L Register"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLRegister."From TDS Entry No." := NextTdsEntryNo; //defined NextTdsEntryNo in this codeunit
        // GLRegister."From TDS Entry No." := GenJnlLineReverse.NextTdsEntryNo; //TDS1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldVendLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldVendLedgEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        //KMT2016CU5 >>
        DtldVendLedgEntry.PragyapanPatra := GenJnlLine.PragyapanPatra;
        DtldVendLedgEntry."Letter of Credit/Telex Trans." := GenJnlLine."Letter of Credit/Telex Trans.";
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPrepareTempCustLedgEntryOnAfterSetFiltersByAppliesToId', '', false, false)]
    local procedure OnPrepareTempCustLedgEntryOnAfterSetFiltersByAppliesToId(var OldCustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; Customer: Record Customer)
    var
        TempOldCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        //KMT2016CU5 >>
        //STANDARD CODEUNIT IS REPLACED BY THIS 
        OldCustLedgerEntry.SETCURRENTKEY("Posting Date");
        TempOldCustLedgEntry.SETCURRENTKEY("Posting Date");
        //KMT2016CU5 <<
        //KMT2016CU5 >>
        SalesSetup.GET;
        IF SalesSetup."Apply Cust. Ledg. Dim. Wise" THEN BEGIN
            //OldCustLedgEntry.SETFILTER("Document Type",'%1|%2',OldCustLedgEntry."Document Type"::Invoice,OldCustLedgEntry."Document Type"::"Credit Memo");
            OldCustLedgerEntry.SETRANGE("Global Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code");
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnInsertVATEntriesFromTempOnBeforeVATEntryInsert', '', false, false)]
    local procedure OnInsertVATEntriesFromTempOnBeforeVATEntryInsert(var VATEntry: Record "VAT Entry"; TempVATEntry: Record "VAT Entry" temporary)
    var
        LinkedAmount: Decimal;
        Complete: Boolean;
        LastEntryNo: Integer;
        FirstEntryNo: Integer;
        DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";
    begin
        IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Full VAT" THEN BEGIN
            LinkedAmount += VATEntry.Amount;
            Complete := LinkedAmount = -DtldCVLedgEntryBuf."VAT Amount (LCY)";
        end;
        LastEntryNo := TempVATEntry."Entry No.";
        TempVATEntry.SETRANGE("Entry No.", FirstEntryNo, LastEntryNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    begin
        IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo" THEN //Min
            InsertSalesJournalInvMaterialize(GenJnlLine, GenJnlLine."Document No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterUpdateLineBalance', '', false, false)]
    local procedure OnAfterUpdateLineBalance(var GenJournalLine: Record "Gen. Journal Line")
    var
        CurrentBalance: Decimal;
    begin
        IF GenJournalLine."Bal. Account No." <> '' THEN //Amsa
            CurrentBalance := CurrentBalance + GenJournalLine."Balance (LCY)" + GenJournalLine."TDS Amount";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeProcessLines', '', false, false)]
    local procedure OnBeforeProcessLines(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        //TDS1.00
        IF (GenJournalLine.Amount <> 0) AND (GenJournalLine."TDS Group" <> '') THEN BEGIN
            GenJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Document No.");
            CreateTDSJnlLine(GenJnlLine);
        END;
        //TDS1.00 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseGLEntryOnBeforeInsertGLEntry', '', false, false)]
    local procedure OnReverseGLEntryOnBeforeInsertGLEntry(var GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    begin
        GLEntry."TDS Amount" := -GLEntry2."TDS Amount";  //TDS1.00
        GLEntry."TDS Base Amount" := -GLEntry2."TDS Base Amount"; //TDS1.00
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseOnBeforeFinishPosting', '', false, false)]
    local procedure OnReverseOnBeforeFinishPosting(var ReversalEntry: Record "Reversal Entry"; var ReversalEntry2: Record "Reversal Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var GLRegister: Record "G/L Register")
    var
        TDSEntry: Record "TDS Entry";
    begin
        //TDS1.00 >>
        IF ReversalEntry2."Reversal Type" = ReversalEntry2."Reversal Type"::Transaction THEN BEGIN
            TempRevertTransactionNo.FINDSET;
            REPEAT
                TDSEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
                TDSManagement.ReverseTDS(TDSEntry, TempReversedGLEntry, GenJnlLine."Source Code", GenJnlPostLine);
            UNTIL TempRevertTransactionNo.NEXT = 0;
        END ELSE
            TDSManagement.ReverseTDS(TDSEntry, TempReversedGLEntry, GenJnlLine."Source Code", GenJnlPostLine);
        //TDS1.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseCustLedgEntryOnBeforeInsertDtldCustLedgEntry', '', false, false)]
    procedure OnReverseCustLedgEntryOnBeforeInsertDtldCustLedgEntry(var NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var IsHandled: Boolean)
    var
        CustRec: Record Customer;
        NewCustLedgEntry: Record "Cust. Ledger Entry";
        NewCustVendLedg: Record "Cust-Vend Ledger";
    begin
        //KMT2016CU5 >>
        CustRec.RESET;
        CustRec.SETRANGE("No.", NewCustLedgEntry."Customer No.");
        IF CustRec.FINDFIRST THEN BEGIN
            IF CustRec."Also Vendor" THEN BEGIN
                NewCustVendLedg.INIT;
                IF NewCustVendLedg.FINDLAST THEN
                    NewCustVendLedg."Entry No." += 1
                ELSE
                    NewCustVendLedg."Entry No." := 1;
                NewCustVendLedg.CopyFromCustLedgEntry(NewCustLedgEntry);
                NewCustVendLedg.INSERT(TRUE);
            END;
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnReverseVendLedgEntryOnBeforeInsertDtldVendLedgEntry', '', false, false)]
    local procedure OnReverseVendLedgEntryOnBeforeInsertDtldVendLedgEntry(var NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; var IsHandled: Boolean)
    var
        VendRec: Record Vendor;
        NewCustVendLedg: Record "Cust-Vend Ledger";
        NewVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        //KMT2016CU5 >>
        VendRec.RESET;
        VendRec.SETRANGE("No.", NewVendLedgEntry."Vendor No.");
        IF VendRec.FINDFIRST THEN BEGIN
            IF VendRec."Also Customer" THEN BEGIN
                NewCustVendLedg.INIT;
                IF NewCustVendLedg.FINDLAST THEN
                    NewCustVendLedg."Entry No." += 1
                ELSE
                    NewCustVendLedg."Entry No." := 1;
                NewCustVendLedg.CopyFromVendLedgEntry(NewVendLedgEntry);
                NewCustVendLedg.INSERT(TRUE);
            END;
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        //KMT2016CU5 >>
        NewItemLedgEntry."Letter of Credit/Telex Trans." := ItemJournalLine."Letter of Credit/Telex Trans.";
        NewItemLedgEntry.PragyapanPatra := ItemJournalLine.PragyapanPatra;   //VAT1.00
        NewItemLedgEntry."Party Type" := ItemJournalLine."Party Type";
        NewItemLedgEntry."Party No." := ItemJournalLine."Party No.";
        NewItemLedgEntry."Item Name" := ItemJournalLine.Description;
        NewItemLedgEntry."Description 2" := ItemJournalLine."Description 2";
        NewItemLedgEntry."RBI Product Code" := ItemJournalLine."RBI Product Code";
        NewItemLedgEntry."Salespers./Purch. Code" := ItemJournalLine."Salespers./Purch. Code";
        //KMT2016CU5 <<

        NewItemLedgEntry."Transfer Receipt No." := ItemJournalLine."Transfer Receipt No."; //ASPL Apr 9th 2021
        NewItemLedgEntry."Transfer Receipt Line No." := ItemJournalLine."Transfer Receipt Line No."; //ASPL Apr 9th 2021
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry")
    begin
        //AGILE SRT >>
        CLEAR(ShortcutCustomDimCode);
        DimMgt.GetShortcutDimensions(ItemLedgerEntry."Dimension Set ID", ShortcutCustomDimCode);
        CopyShortcutDimensions(ItemLedgerEntry, ShortcutCustomDimCode);
        //AGILE SRT <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer; GlobalValueEntry: Record "Value Entry"; TransferItem: Boolean; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; var OldItemLedgerEntry: Record "Item Ledger Entry")
    begin
        //KMT2017CU5 >>
        IF (ItemLedgerEntry."Serial No." <> '') AND (ItemJournalLine."Source Code" = 'PURCHASES') THEN BEGIN
            SysMgt.CreateVehicle(ItemLedgerEntry."Item No.", ItemLedgerEntry."Serial No.", ItemLedgerEntry."Variant Code");
        END;
        //KMT2017CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnBeforeRoundAmtValueEntry', '', false, false)]
    local procedure OnInitValueEntryOnBeforeRoundAmtValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        //KMT2016CU5 >>
        ValueEntry.PragyapanPatra := ItemJnlLine.PragyapanPatra;
        ValueEntry."Purchase Consignment No." := ItemJnlLine."Purchase Consignment No.";
        ValueEntry."Letter of Credit/Telex Trans." := ItemJnlLine."Letter of Credit/Telex Trans.";
        ValueEntry."Item Name" := ItemJnlLine."Item Name";
        ValueEntry."RBI Product Code" := ItemJnlLine."RBI Product Code";
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnAfterRun', '', false, false)]
    local procedure OnAfterRun(var GenJnlLine: Record "Gen. Journal Line")
    var
        Productseg: Code[20];
    begin
        Productseg := GenJnlLine."Shortcut Dimension 1 Code";
        //KMT2016CU5 >>
        IF (GenJnlLine."Shortcut Dimension 1 Code" <> '') OR (GenJnlLine."Shortcut Dimension 2 Code" <> '') THEN BEGIN
            CustLedgEntry.SETRANGE("Global Dimension 1 Code", GenJnlLine."Shortcut Dimension 1 Code");
            //CustLedgEntry.SETRANGE("Global Dimension 2 Code","Shortcut Dimension 2 Code");
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-B.Post+Print", 'OnBeforePostJournalBatch', '', false, false)]
    local procedure OnBeforePostJournalBatch(var GenJournalBatch: Record "Gen. Journal Batch"; var HideDialog: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GLEntry: Record "G/L Entry";
        GLReg: Record "G/L Register";
    begin
        IF GenJnlTemplate."Posting Report ID" <> 0 THEN BEGIN
            GLEntry.SETRANGE("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            REPORT.RUN(GenJnlTemplate."Posting Report ID", FALSE, FALSE, GLEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, 'OnAfterSetGLAccGLEntryFilters', '', false, false)]
    local procedure OnAfterSetGLAccGLEntryFilters(var GLAccount: Record "G/L Account"; var GLEntry: Record "G/L Entry"; var AccSchedLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; UseBusUnitFilter: Boolean; UseDimFilter: Boolean)
    var
        AccSchedName: Record "Acc. Schedule Name";
    begin
        IF AccSchedName."SKip Prior Entry" THEN
            GLEntry.SETFILTER("Prior-Year Entry", FORMAT(FALSE));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeIsCreditDocType', '', false, false)]
    local procedure OnBeforeIsCreditDocType(SalesHeader: Record "Sales Header"; var CreditDocType: Boolean)
    begin
        SalesHeader.TestField("Shortcut Dimension 1 Code");  //KMT2016CU5
        SalesHeader.TestField("Shortcut Dimension 2 Code"); //KMT2016CU5
        SalesHeader.TestField("Salesperson Code"); //KMT2016CU5
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterTestSalesLine', '', false, false)]
    local procedure OnAfterTestSalesLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    var
        Item1: Record 27;
    begin
        //KMT2016CU5 <<
        IF SalesLine.Type = SalesLine.Type::Item THEN BEGIN
            SalesLine.TESTFIELD(Quantity);
            Item1.RESET;
            Item1.SETRANGE("No.", SalesLine."No.");
            IF Item1.FINDFIRST THEN BEGIN
                IF Item1."Free Item" THEN
                    SalesLine.TESTFIELD("Unit Price", 0)
                ELSE
                    SalesLine.TESTFIELD("Unit Price");
            END;
        END;
        // IF SalesLine."Item Category Code" <> '' THEN
        // SalesLine.TESTFIELD(Quantity,1);
        //KMT2016CU5 <<  
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    // local procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; PostingSalesLine: Record "Sales Line")
    // var
    // Sales_Post : Codeunit "Sales-Post";
    // begin
    //Local procedure form the codeunit was called but we can't access that procedure CreatePostedDeferralScheduleFromSalesDoc
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostDropOrderShipment', '', false, false)]
    local procedure OnBeforePostDropOrderShipment(var SalesHeader: Record "Sales Header"; var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        PurchPost: codeunit "Purch.-Post";
        PurchOrderHeader: Record "Purchase Header";
    begin
        PurchPost.ArchiveUnpostedOrder(PurchOrderHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnDeleteAfterPostingOnAfterDeleteLinks', '', false, false)]
    local procedure OnDeleteAfterPostingOnAfterDeleteLinks(var SalesLine: Record "Sales Line")
    begin
        IF SalesLine."Deferral Code" <> '' THEN
            DeferralUtilities.RemoveOrSetDeferralSchedule(
              '', DeferralUtilities.GetSalesDeferralDocType, '', '',
              SalesLine."Document Type",
              SalesLine."Document No.",
              SalesLine."Line No.", 0, 0D,
              SalesLine.Description,
              '',
              TRUE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnDeleteAfterPostingOnBeforeDeleteSalesHeader', '', false, false)]
    local procedure OnDeleteAfterPostingOnBeforeDeleteSalesHeader(var SalesHeader: Record "Sales Header")
    begin
        DeleteWhseRqst(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        SendToIRD(SalesHeader); //SRT July 23rd 2019
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line")
    begin
        ItemJournalLine."Description 2" := SalesLine."Description 2";  //KMT2016CU5
        ItemJournalLine."RBI Product Code" := SalesLine."RBI Product Code";   //KMT2016CU5
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInvoiceRoundingAmount', '', false, false)]
    local procedure OnAfterInvoiceRoundingAmount(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TotalSalesLine: Record "Sales Line"; UseTempData: Boolean; InvoiceRoundingAmount: Decimal; CommitIsSuppressed: Boolean)
    var
        TempSalesLineForCalc: Record 37 TEMPORARY;
        CustPostingGr: Record 92;
    begin
        TempSalesLineForCalc := SalesLine;
        TempSalesLineForCalc.VALIDATE("No.", CustPostingGr."Invoice Rounding Account");
        SalesLine := TempSalesLineForCalc;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCheckAndUpdate', '', false, false)]
    local procedure OnRunOnBeforeCheckAndUpdate(var SalesHeader: Record "Sales Header")
    var
        IrdMgt: Codeunit "IRD Mgt.";
    begin
        //Not sure about this it was called by this proceduere CheckPostRestrictions 
        //no event was called in this funtion
        IF SalesHeader.Ship OR SalesHeader.Invoice THEN
            IrdMgt.CheckCustomerCreditLimit(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnInsertInvoiceHeaderOnBeforeSetPaymentInstructions', '', false, false)]
    local procedure OnInsertInvoiceHeaderOnBeforeSetPaymentInstructions(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header"; var SalesShptHeader: Record "Sales Shipment Header")
    var
        PreviewMode: Boolean;
        FakeDocNoTxt: TextConst ENU = '***';
    begin
        IF PreviewMode THEN
            SalesInvHeader."No." := FakeDocNoTxt;

        SalesInvHeader.Note := SalesHeader.Note;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', false, false)]
    local procedure OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        UserSetup: Record "User Setup";
    begin
        //KMT2016CU5 >>
        SalesHeader.TESTFIELD("Inventory Posting Group");
        UserSetup.GET(USERID);
        IF NOT UserSetup."Allow Different Customer Post" THEN
            IF SalesHeader."Sell-to Customer No." <> SalesHeader."Bill-to Customer No." THEN
                ERROR('Sell-to Customer No. and Bill-to Customer No. must be same');
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    var
        Selection: Integer;
        Text1000: TextConst ENU = '&Ship';
    begin
        SalesSetup.GET; //ASPL Apr 6th 2021
        IF NOT SalesSetup."Restrict Invoicing from Damage" THEN BEGIN  //ASPL Apr 6th 2021
        END ELSE BEGIN
            Selection := STRMENU(Text1000, 1);
            SalesHeader.Ship := Selection IN [1, 1];
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCheckAndUpdateOnAfterCalcCopyAndCheckItemChargeNeeded', '', false, false)]
    local procedure OnCheckAndUpdateOnAfterCalcCopyAndCheckItemChargeNeeded(var PurchHeader: Record "Purchase Header"; var CopyAndCheckItemChargeNeeded: Boolean)
    var
        Vendor: Record Vendor;
        PurchLine: Record "Purchase Line";
    begin
        //KMT2016CU5 >>
        WITH PurchHeader DO BEGIN
            Vendor.GET(PurchHeader."Pay-to Vendor No.");
            IF Vendor."Pragyapan Patra Mandatory" THEN
                PurchHeader.TESTFIELD(PragyapanPatra)
            ELSE
                PurchHeader.TESTFIELD(PragyapanPatra, '');
            PurchLine.RESET;
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            IF PurchLine.FINDFIRST THEN
                REPEAT
                    IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
                        IF (PurchLine."VAT Base 1" = 0) AND (PurchLine."VAT Base Amount" = 0) THEN
                            ERROR('Enter the vat base amount for the g/l account selected...');
                    END;
                    IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN
                        PurchLine.CheckVendorApplicableItemCharge;
                //IF PurchLine."Item Category Code" <> '' THEN
                //PurchLine.TESTFIELD(Quantity,1);
                UNTIL PurchLine.NEXT = 0;
        END;
        //KMT2016CU5
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvLineInsert', '', false, false)]
    local procedure OnBeforePurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseLine: Record "Purchase Line"; CommitIsSupressed: Boolean; var xPurchaseLine: Record "Purchase Line")
    var
        ValueEntry1: Record "Value Entry";
        ItemLedgEntry1: Record "Item Ledger Entry";
        PurchReceiptLine1: Record "Purch. Rcpt. Line";
    begin
        //KMT2016CU5 >>
        ValueEntry1.SETRANGE("Document No.", PurchInvLine."Document No.");
        IF ValueEntry1.FINDFIRST THEN
            REPEAT
                IF (ValueEntry1.PragyapanPatra <> '') OR (ValueEntry1."Letter of Credit/Telex Trans." <> '') THEN
                    ItemLedgEntry1.SETRANGE("Entry No.", ValueEntry1."Item Ledger Entry No.");
                IF ItemLedgEntry1.FINDFIRST THEN BEGIN
                    //         {ItemLedgEntry1.PragyapanPatra := ValueEntry1.PragyapanPatra;
                    // ItemLedgEntry1."Letter of Credit/Telex Trans." := ValueEntry1."Letter of Credit/Telex Trans.";
                    // ItemLedgEntry1.MODIFY;}  //Kathmandu Marketing's License does not allow to modify the item ledger entries so it shows the error while posting the purchase order
                    PurchReceiptLine1.SETRANGE("Document No.", ItemLedgEntry1."Document No.");
                    IF PurchReceiptLine1.FINDSET THEN
                        REPEAT
                            PurchReceiptLine1.PragyapanPatra := ValueEntry1.PragyapanPatra;
                            PurchReceiptLine1."Letter of Credit/Telex Trans." := ValueEntry1."Letter of Credit/Telex Trans.";
                            PurchReceiptLine1.MODIFY;
                        UNTIL PurchReceiptLine1.NEXT = 0;
                END;
            UNTIL ValueEntry1.NEXT = 0;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        InvPostingBuffer: ARRAY[2] OF Record "Invoice Post. Buffer" TEMPORARY;
    begin
        //KMT2016CU5 >>
        GenJnlLine."Letter of Credit/Telex Trans." := InvPostingBuffer[1]."Letter of Credit/Telex Trans.";
        GenJnlLine.PragyapanPatra := InvPostingBuffer[1].PragyapanPatra;
        GenJnlLine."Party Type" := InvPostingBuffer[1]."Party Type";
        GenJnlLine."Party No." := InvPostingBuffer[1]."Party No.";
        GenJnlLine."Party Name" := PurchHeader."Buy-from Vendor Name";
        GenJnlLine."Free Item Vendor No." := InvPostingBuffer[1]."Free Item Vendor No.";
        GenJnlLine."Free Item Vendor Name" := InvPostingBuffer[1]."Free Item Vendor Name";
        GenJnlLine."RBI Product Code" := InvPostingBuffer[1]."RBI Product Code";
        //KMT2016CU5 <<
        //KMT2016CU5 >>
        GenJnlLine.PragyapanPatra := PurchHeader.PragyapanPatra;
        GenJnlLine."Letter of Credit/Telex Trans." := PurchHeader."Letter of Credit/Telex Trans.";
        GenJnlLine."Free Item Vendor No." := PurchHeader."Free Item Vendor No.";
        GenJnlLine."Free Item Vendor Name" := PurchHeader."Free Item Vendor Name";
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostBalancingEntry', '', false, false)]
    local procedure OnBeforePostBalancingEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        InvPostingBuffer: ARRAY[2] OF Record "Invoice Post. Buffer" TEMPORARY;
    begin
        //KMT2016CU5 <<
        GenJnlLine."Letter of Credit/Telex Trans." := InvPostingBuffer[1]."Letter of Credit/Telex Trans.";
        GenJnlLine.PragyapanPatra := InvPostingBuffer[1].PragyapanPatra;
        GenJnlLine."Party Type" := InvPostingBuffer[1]."Party Type";
        GenJnlLine."Party No." := InvPostingBuffer[1]."Party No.";
        GenJnlLine."Party Name" := PurchHeader."Buy-from Vendor Name";
        GenJnlLine."VAT Base 1" := PurchHeader."VAT Base 1";
        GenJnlLine."Exempt Amount" := PurchHeader."Exempt Amount";
        GenJnlLine."Free Item Vendor No." := InvPostingBuffer[1]."Free Item Vendor No.";
        GenJnlLine."Free Item Vendor Name" := InvPostingBuffer[1]."Free Item Vendor Name";
        //KMT2016CU5 >>
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure OnAfterPostItemJnlLines(var ItemJournalLine: Record "Item Journal Line"; var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        //KTM2016CU5 >>
        ItemJournalLine."Purchase Consignment No." := PurchaseHeader."Purchase Consignment No.";
        ItemJournalLine."Letter of Credit/Telex Trans." := PurchaseLine."Letter of Credit/Telex Trans.";
        ItemJournalLine.PragyapanPatra := PurchaseLine.PragyapanPatra;
        ItemJournalLine."Party Type" := PurchaseLine."Party Type";
        ItemJournalLine."Party No." := PurchaseLine."Party No.";
        ItemJournalLine."Description 2" := PurchaseLine."Description 2";
        ItemJournalLine."RBI Product Code" := PurchaseLine."RBI Product Code";
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInvoiceRoundingAmount', '', false, false)]
    local procedure OnBeforeInvoiceRoundingAmount(PurchHeader: Record "Purchase Header"; TotalAmountIncludingVAT: Decimal; UseTempData: Boolean; var InvoiceRoundingAmount: Decimal; CommitIsSupressed: Boolean)
    var
        PurchLine: Record "Purchase Line";
        TempPurchLineForCalc: Record "Purchase Line";
        VendPostingGr: Record "Vendor Posting Group";

    begin
        TempPurchLineForCalc := PurchLine;
        TempPurchLineForCalc.VALIDATE("No.", VendPostingGr."Invoice Rounding Account");
        PurchLine := TempPurchLineForCalc;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemChargeOnBeforePostItemJnlLine', '', false, false)]
    local procedure OnPostItemChargeOnBeforePostItemJnlLine(var PurchaseLineToPost: Record "Purchase Line"; var PurchaseLine: Record "Purchase Line"; QtyToAssign: Decimal; var TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary)
    begin
        PurchaseLineToPost.PragyapanPatra := PurchaseLine.PragyapanPatra;
        PurchaseLineToPost."Letter of Credit/Telex Trans." := PurchaseLine."Letter of Credit/Telex Trans.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnBeforeInsertItemChargeAssgntWithAssignValues', '', false, false)]
    local procedure OnBeforeInsertItemChargeAssgntWithAssignValues(var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    begin
        //KMT2016CU5 >>
        ItemChargeAssgntPurch.PragyapanPatra := FromItemChargeAssgntPurch.PragyapanPatra;
        ItemChargeAssgntPurch."Letter of Credit/Telex Trans." := FromItemChargeAssgntPurch."Letter of Credit/Telex Trans.";
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnBeforeAssignItemCharges', '', false, false)]
    local procedure OnBeforeAssignItemCharges(var PurchaseLine: Record "Purchase Line"; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal; var IsHandled: Boolean)
    var
        PurchRcptLine1: Record "Purch. Rcpt. Line";
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
    begin
        //KMT2016CU5 >>
        PurchRcptLine1.SETRANGE("Document No.", ItemChargeAssgntPurch2."Applies-to Doc. No.");
        IF PurchRcptLine1.FINDFIRST THEN BEGIN
            ItemChargeAssgntPurch2.PragyapanPatra := PurchRcptLine1.PragyapanPatra;
            ItemChargeAssgntPurch2."Letter of Credit/Telex Trans." := PurchRcptLine1."Letter of Credit/Telex Trans.";
            ItemChargeAssgntPurch2.MODIFY;
        END;
        //KMT2016CU5 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnAssignByAmountOnAfterAssignAppliesToDocLineAmount', '', false, false)]
    local procedure OnAssignByAmountOnAfterAssignAppliesToDocLineAmount(ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; var TempItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)" temporary);
    var
        CurrencyCode: code[20];
        PurchHeader: Record "Purchase Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ILE: Record "Item Ledger Entry";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        //KMT2016CU5  BEGIN>>
        IF CurrencyCode = PurchHeader."Currency Code" THEN BEGIN
            ItemChargeAssignmentPurch."Applies-to Doc. Line Amount" :=
              ABS(PurchRcptLine."Item Charge Base Amount");
            ILE.SETRANGE("Document No.", TempItemChargeAssignmentPurch."Applies-to Doc. No.");
            ILE.SETRANGE("Document Line No.", TempItemChargeAssignmentPurch."Applies-to Doc. Line No.");
            IF ILE.FINDFIRST THEN BEGIN
                ItemChargeAssignmentPurch."Applies-to Doc. Line Amount" :=
                CurrExchRate.ExchangeAmtFCYToFCY(
                  PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                  ABS(ILE."Cost Amount (Actual)"));
            END;
            //MESSAGE(FORMAT(ABS(ILE."Cost Amount (Actual)")));
        END ELSE BEGIN
            ItemChargeAssignmentPurch."Applies-to Doc. Line Amount" :=
              CurrExchRate.ExchangeAmtFCYToFCY(
                PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
              ABS(PurchRcptLine."Item Charge Base Amount"));
            ILE.SETRANGE("Document No.", TempItemChargeAssignmentPurch."Applies-to Doc. No.");
            ILE.SETRANGE("Document Line No.", TempItemChargeAssignmentPurch."Applies-to Doc. Line No.");
            IF ILE.FINDFIRST THEN BEGIN
                ILE.CALCFIELDS("Cost Amount (Actual)");
                ItemChargeAssignmentPurch."Applies-to Doc. Line Amount" :=
                CurrExchRate.ExchangeAmtFCYToFCY(
                  PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                  ABS(ILE."Cost Amount (Actual)"));
            END;
            //MESSAGE(FORMAT(ABS(ILE."Cost Amount (Actual)")));
        END;
        //KMT2016CU5 END <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterCheckBeforePost', '', false, false)]
    local procedure OnAfterCheckBeforePost(var TransferHeader: Record "Transfer Header")
    begin
        //modified change of codeunit TransferOrder-Post Receipt
        //CheckBeforePost
        TransferHeader.TESTFIELD("Shortcut Dimension 1 Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeTransRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeTransRcptHeaderInsert(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferReceiptHeader."Source Document No." := TransferHeader."Source Document No."; //ASPL Apr 6th 2021
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterInsertTransRcptLine', '', false, false)]
    local procedure OnAfterInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    begin
        //ASPL Apr 6th 2021 >>
        TransRcptLine."Source Document No." := TransLine."Source Document No.";
        TransRcptLine."Source Document Line No." := TransLine."Source Document Line No.";
        //ASPL Apr 6th 2021 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', false, false)]
    local procedure OnAfterTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CreateItemJnlAfterTransferReceive(TransferReceiptHeader, TRUE); //ASPL Apr 9th 2021
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Make FA Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(var FALedgerEntry: Record "FA Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //KMT2016CU5 >>
        FALedgerEntry."FA Item Charge" := GenJnlLine."FA Item Charge";
        FALedgerEntry.PragyapanPatra := GenJnlLine.PragyapanPatra;
        //KMT2016CU5 <<
    end;

    var
        GLAccount: Record "G/L Account";
        SourceCodeSetup: Record "Source Code Setup";
        VendorName: Text[50];
        GLAccountNo: Code[20];
        GLAccountName: Text[50];
        Gbl_Doc_No: Code[20];
        GenLine: Record "Gen. Journal Line";
        GenJnlLineReverse: Codeunit "Gen. Jnl.-Post Reverse";
        NextTransactionNo: Integer;
        TDSDesc: TextConst ENU = 'System Created TDS Entry';
        GenJnlLine: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustVendLedgEntry: Record "Cust-Vend Ledger";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        SalesSetup: Record "Sales & Receivables Setup";
        TempRevertTransactionNo: Record "Integer" temporary;
        TDSManagement: Codeunit "TDS Management";
        TempReversedGLEntry: Record "G/L Entry" TEMPORARY;
        SysMgt: Codeunit "IRD Mgt.";
        ShortcutCustomDimCode: ARRAY[8] OF Code[20];
        DimMgt: Codeunit DimensionManagement;
        TempItemApplnEntryHistory: Record "Item Application Entry History" TEMPORARY;
        SkipApplicationCheck: Boolean;
        SalesLine: Record "Sales Line";
        DeferralUtilities: Codeunit "Deferral Utilities";
        ServInvHeader: Record "Service Invoice Header" temporary;
        ServCrMemoHeader: Record "Service Cr.Memo Header" temporary;
        ServShptHeader: Record "Service Shipment Header" temporary;

}