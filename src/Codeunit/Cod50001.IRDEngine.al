codeunit 50001 "IRD Engine"
{

    trigger OnRun()
    begin
    end;

    [Scope('Onprem')]
    procedure Binding()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnAfterCheckGenJnlLine', '', false, false)]
    local procedure CheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
        PurchSetup: Record "Purchases & Payables Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CheckGenJnlLine(GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLRegister', '', false, false)]
    local procedure CopyOnGLRegister(var GLRegister: Record "G/L Register"; var GenJournalLine: Record "Gen. Journal Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyOnGLRegister(GLRegister, GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure CopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyGLEntryFromGenJnlLine(GLEntry, GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, 254, 'OnAfterCopyVATEntryFromGenJnlLine', '', false, false)]
    local procedure CopyVATEntryFromGenJnlLine(var Sender: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyVATEntryFromGenJnlLine(Sender, GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure CopyItemLedgEntryFromItemJnlLine(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyItemLedgEntryFromItemJnlLine(ItemLedgerEntry, ItemJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchHeader', '', false, false)]
    local procedure CopyItemJnlLineFromPurchHeader(var ItemJnlLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyItemJnlLineFromPurchHeader(ItemJnlLine, PurchHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertValueEntry', '', false, false)]
    local procedure OnBeforeInsertValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean; var OldItemLedgEntry: Record "Item Ledger Entry"; var Item: Record Item; TransferItem: Boolean; var GlobalValueEntry: Record "Value Entry")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyValueEntryFromItemJnlLine(ValueEntry, ItemJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopyGenJnlLineFromPurchHeader(GenJnlLine, PurchHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnBeforeCopySalesInvLinesToBuffer', '', false, false)]

    local procedure CopySalesInvHeaderToSalesLine(var FromSalesLine: Record "Sales Line"; var FromSalesInvLine: Record "Sales Invoice Line"; var ToSalesHeader: Record "Sales Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
        FromSalesInvHdr: Record "Sales Invoice Header";
    begin
        FromSalesInvHdr.get(FromSalesInvLine."Document No.");
        IRDMgt.CopySalesInvHeaderToSalesLine(FromSalesLine, FromSalesInvHdr."No.", FromSalesInvLine."Line No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesShptLinesToBuffer', '', false, false)]
    local procedure OnBeforeCopySalesShptLinesToBuffer(var FromSalesLine: Record "Sales Line"; var FromSalesShptLine: Record "Sales Shipment Line"; var ToSalesHeader: Record "Sales Header")
    var
        SalesShptHdr: Record "Sales Shipment Header";
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        SalesShptHdr.Get(FromSalesShptLine."Document No.");
        IRDMgt.CopySalesShptHeaderToSalesLine(FromSalesLine, SalesShptHdr."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesReturnRcptLinesToBuffer', '', false, false)]
    local procedure OnBeforeCopySalesReturnRcptLinesToBuffer(var FromReturnReceiptLine: Record "Return Receipt Line"; var FromSalesLine: Record "Sales Line"; var ToSalesHeader: Record "Sales Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
        ReturnRcptHeaderNo: Record "Return Receipt Header";
    begin
        ReturnRcptHeaderNo.Get(FromReturnReceiptLine."Document No.");
        IRDMgt.CopySalesReturnRcptHeaderToSalesLine(FromSalesLine, ReturnRcptHeaderNo."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesCrMemoLinesToBuffer', '', false, false)]
    local procedure OnBeforeCopySalesCrMemoLinesToBuffer(var FromSalesCrMemoLine: Record "Sales Cr.Memo Line"; var FromSalesLine: Record "Sales Line"; var ToSalesHeader: Record "Sales Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
        SalesCrMemoHeaderNo: Record "Sales Cr.Memo Header";
    begin
        SalesCrMemoHeaderNo.Get(FromSalesCrMemoLine."Document No.");
        IRDMgt.CopySalesCrMemoHeaderToSalesLine(FromSalesLine, SalesCrMemoHeaderNo."No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostInvPostBuffer', '', false, False)]
    local procedure OnAfterPostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesHeader: Record "Sales Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        //IRDMgt.CopyGenJnlLineFromInvPostBufferSales(GenJnlLine, InvoicePostBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnAfterPostPrepmtInvLineBuffer', '', false, false)]
    local procedure OnAfterPostPrepmtInvLineBuffer(var GenJnlLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
        PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer";
    begin
        IRDMgt.CopyGenJnlLineFromPrepInvPostBufferSales(GenJnlLine, PrepaymentInvLineBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Serv-Posting Journals Mgt.", 'OnAfterPostInvoicePostBuffer', '', false, false)]
    local procedure OnAfterPostInvoicePostBuffer(var GenJournalLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; ServiceHeader: Record "Service Header"; GLEntryNo: Integer; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        //IRDMgt.CopyGenJnlLineFromInvPostBufferService(GenJournalLine, InvoicePostBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostInvPostBuffer', '', false, false)]
    local procedure OnAfterPostInvPostBuffers(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; PurchHeader: Record "Purchase Header"; GLEntryNo: Integer; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        //IRDMgt.CopyGenJnlLineFromInvPostBufferPurchase(GenJnlLine, InvoicePostBuffer, PurchHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSuppressed: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopySalesInvLineFromPrepInvPostBuffer(SalesInvLine, PrepmtInvLineBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnBeforeSalesCrMemoLineInsert', '', false, false)]
    local procedure OnBeforeSalesCrMemoLineInsert(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSuppressed: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CopySalesCrMemoLineFromPrepInvPostBuffer(SalesCrMemoLine, PrepmtInvLineBuffer);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'VAT Prod. Posting Group', false, false)]
    local procedure GetCustomVATPostingSetupOnSalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.GetCustomVATPostingSetupOnSalesLine(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'VAT Prod. Posting Group', false, false)]
    local procedure GetCustomVATPostingSetupOnPurchLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.GetCustomVATPostingSetupOnPurchLine(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, 5902, 'OnAfterModifyEvent', '', false, false)]
    local procedure GetCustomVATPostingSetupOnServiceLine(var Rec: Record "Service Line"; var xRec: Record "Service Line"; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.GetCustomVATPostingSetupOnServiceLine(Rec, xRec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, 5902, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure GetCustomVATPostingSetupOnF6ServiceLine(var Rec: Record "Service Line"; var xRec: Record "Service Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.GetCustomVATPostingSetupOnF6ServiceLine(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'VAT Bus. Posting Group', false, false)]
    local procedure GetCustomVATPostingSetupOnF90GenJnlLine(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.GetCustomVATPostingSetupOnF90GenJnlLine(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'VAT Prod. Posting Group', false, false)]
    local procedure GetCustomVATPostingSetupOnF91GenJnlLine(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.GetCustomVATPostingSetupOnF91GenJnlLine(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    local procedure InsertSalesMaterializedView(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.InsertSalesMaterializedView(SalesHeader, GenJnlPostLine, SalesShptHdrNo, RetRcpHdrNo, SalesInvHdrNo, SalesCrMemoHdrNo);
    end;

    // [EventSubscriber(ObjectType::Codeunit, 5980, 'OnAfterPostServiceDoc', '', false, false)]
    // local procedure InsertServiceMaterializedView(var ServiceHeader: Record "Service Header"; ServiceShptHdrNo: Code[20]; ServiceInvHdrNo: Code[20]; ServiceCrMemoHdrNo: Code[20]; Ship: Boolean; Consume: Boolean; Invoice: Boolean; WhseShip: Boolean)
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.InsertServiceMaterializedView(ServiceHeader, ServiceShptHdrNo, ServiceInvHdrNo, ServiceCrMemoHdrNo, Ship, Consume, Invoice, WhseShip);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 2, 'OnAfterInitializeCompany', '', false, false)]
    // local procedure InitializeCompany()
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.InitializeCompany;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 315, 'OnNoPrintedModify', '', false, false)]
    // local procedure ModifySalesInvPrintInformation(var SalesInvoiceHeader: Record "Sales Invoice Header")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.ModifySalesInvPrintInformation(SalesInvoiceHeader);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 316, 'OnNoPrintedModify', '', false, false)]
    // local procedure ModifySalesCrInvPrintInformation(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.ModifySalesCrInvPrintInformation(SalesCrMemoHeader);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 5902, 'OnNoPrintedModify', '', false, false)]
    // local procedure ModifyServiceInvPrintInformation(var ServiceInvoiceHeader: Record "Service Cr.Memo Header")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.ModifyServiceInvPrintInformation(ServiceInvoiceHeader);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 5904, 'OnNoPrintedModify', '', false, false)]
    // local procedure ModifyServiceCrInvPrintInformation(var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.ModifyServiceCrInvPrintInformation(ServiceCrMemoHeader);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterGetApplicationVersion', '', false, false)]
    // local procedure OnAfterBuildAppVersion(var AppVersion: Text[80])
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.BuildAppVersion(AppVersion);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterCopyToSalesLine', '', false, false)]
    // local procedure OnAfterCopyToSalesLineFromDocuments(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.OnAfterCopyToSalesLineFromDocuments(ToSalesLine, FromSalesLine);
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesLineOnAfterSetDimensions', '', false, false)]
    local procedure OnCopySalesLineOnAfterSetDimensions(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnAfterCopyToSalesLineFromDocuments(ToSalesLine, FromSalesLine);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure OnAfterValidationF2OnPurchHeader(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CheckVendor(Rec."Buy-from Vendor No.");
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidationF2OnSalesHeader(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.CheckCustomer(Rec."Sell-to Customer No.");
    end;

    [EventSubscriber(ObjectType::Table, 112, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesInvHeader(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertSalesInvHeader(Rec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, 114, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesCrMemoHeader(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertSalesCrMemoHeader(Rec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, 5992, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertServiceInvHeader(var Rec: Record "Service Invoice Header"; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertServiceInvHeader(Rec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, 5994, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertServiceCrMemoHeader(var Rec: Record "Service Cr.Memo Header"; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertServiceCrMemoHeader(Rec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, 122, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertPurchInvHeader(var Rec: Record "Purch. Inv. Header"; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertPurchInvHeader(Rec, RunTrigger);
    end;

    [EventSubscriber(ObjectType::Table, 124, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertPurchCrMemoHeader(var Rec: Record "Purch. Cr. Memo Hdr."; RunTrigger: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertPurchCrMemoHeader(Rec, RunTrigger);
    end;

    // [EventSubscriber(ObjectType::Codeunit, 442, 'OnBeforeInsertSalesCrMemoLine', '', false, false)]
    // local procedure OnBeforeInsertSalesCrMemoLineOnPrepPosting(var SalesCrMemoLine: Record "Sales Cr.Memo Header"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.OnBeforeInsertSalesCrMemoLineOnPrepPosting(SalesCrMemoLine, PrepaymentInvLineBuffer);
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnBeforeSalesCrMemoLineInsert', '', false, false)]
    local procedure OnBeforeSalesCrMemoLineInserts(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSuppressed: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertSalesCrMemoLineOnPrepPosting(SalesCrMemoLine, PrepmtInvLineBuffer);
    end;

    // [EventSubscriber(ObjectType::Codeunit, 442, 'OnBeforeInsertSalesInvLine', '', false, false)]
    // local procedure OnBeforeInsertSalesInvLineOnPrepPosting(var SalesInvoiceLine: Record "Sales Invoice Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.OnBeforeInsertSalesInvLineOnPrepPosting(SalesInvoiceLine, PrepaymentInvLineBuffer);
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure OnBeforeSalesInvLineInserts(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSuppressed: Boolean)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.OnBeforeInsertSalesInvLineOnPrepPosting(SalesInvLine, PrepmtInvLineBuffer);
    end;

    [EventSubscriber(ObjectType::Table, 49, 'OnAfterPrepareSales', '', false, false)]
    local procedure PrepareSalesFieldsOnInvPostBuffer(var Sender: Record "Invoice Post. Buffer"; SalesLine: Record "Sales Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.PrepareSalesFieldsOnInvPostBuffer(Sender, SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, 49, 'OnAfterPrepareService', '', false, false)]
    local procedure PrepareServiceFieldsOnInvPostBuffer(var Sender: Record "Invoice Post. Buffer"; ServiceLine: Record "Service Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.PrepareServiceFieldsOnInvPostBuffer(Sender, ServiceLine);
    end;

    [EventSubscriber(ObjectType::Table, 49, 'OnAfterPreparePurchase', '', false, false)]
    local procedure PreparePurchaseFieldsOnInvPostBuffer(var Sender: Record "Invoice Post. Buffer"; PurchaseLine: Record "Purchase Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.PreparePurchaseFieldsOnInvPostBuffer(Sender, PurchaseLine);
    end;

    [EventSubscriber(ObjectType::Table, 461, 'OnAfterPrepareSalesPrepmt', '', false, false)]
    local procedure PrepareSalesFieldsOnPrepInvPostBuffer(var Sender: Record "Prepayment Inv. Line Buffer"; SalesLine: Record "Sales Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.PrepareSalesFieldsOnPrepInvPostBuffer(Sender, SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnCheckPurchasePostRestrictions', '', false, false)]
    local procedure PurchPostRestriction(var Sender: Record "Purchase Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.PurchPostRestriction(Sender);
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnCheckSalesPostRestrictions', '', false, false)]
    local procedure SalesPostRestriction(var Sender: Record "Sales Header")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.SalesPostRestriction(Sender);
    end;

    // [EventSubscriber(ObjectType::Table, 5900, 'OnCheckPostRestrictions', '', false, false)]
    // local procedure ServicePostRestriction(var Sender: Record "Service Header")
    // var
    //     SalesSetup: Record "Sales & Receivables Setup";
    //     ServiceLine: Record "Service Line";
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.ServicePostRestriction(Sender);
    // end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterUpdatePurchaseLine', '', false, false)]
    local procedure UpdatePurchLinesFCallFromPurchHeader(var Sender: Record "Purchase Header"; ChangedFieldName: Text[100]; var PurchaseLine: Record "Purchase Line")
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.UpdatePurchLinesFCallFromPurchHeader(Sender, ChangedFieldName, PurchaseLine);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure UpdatePurchLineOnField6Validation(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.UpdatePurchLineOnField6Validation(Rec, xRec, CurrFieldNo);
    end;

    // [EventSubscriber(ObjectType::Table, 5900, 'OnAfterUpdateServLines', '', false, false)]
    // local procedure UpdateServLinesFCallFromServHeader(var Sender: Record "Service Header"; ChangedFieldName: Text[100]; var ServiceLine: Record "Service Line")
    // var
    //     IRDMgt: Codeunit "IRD Mgt.";
    // begin
    //     IRDMgt.UpdateServLinesFCallFromServHeader(Sender, ChangedFieldName, ServiceLine);
    // end;

    [EventSubscriber(ObjectType::Table, 5902, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure UpdateServLineOnField6Validation(var Rec: Record "Service Line"; var xRec: Record "Service Line"; CurrFieldNo: Integer)
    var
        IRDMgt: Codeunit "IRD Mgt.";
    begin
        IRDMgt.UpdateServLineOnField6Validation(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        VATEntry."VAT Base 1" := GenJournalLine."VAT Base 1";
        VATEntry."Exempt Amount" := GenJournalLine."Exempt Amount";
        VATEntry.PragyapanPatra := GenJournalLine.PragyapanPatra;
        VATEntry."Letter of Credit/Telex Trans." := GenJournalLine."Letter of Credit/Telex Trans.";
        VATEntry."Free Item Vendor No." := GenJournalLine."Free Item Vendor No.";
        VATEntry."Free Item Vendor Name" := GenJournalLine."Free Item Vendor Name";
        IF GenJournalLine."Bill-to/Pay-to No." <> '' THEN
            VATEntry."Bill-to/Pay-to No." := GenJournalLine."Bill-to/Pay-to No."
        ELSE
            VATEntry."Bill-to/Pay-to No." := GenJournalLine."Party No.";
        VATEntry."Exclude PP in VAT Book" := GenJournalLine."Exclude PP in VAT Book";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimMgt: Codeunit DimensionManagement;
        ShortcutCustomDimCode: array[8] of Code[20];
    begin
        //KMT2016CU5 >>
        GLEntry."Letter of Credit/Telex Trans." := GenJournalLine."Letter of Credit/Telex Trans.";
        GLEntry."Party Type" := GenJournalLine."Party Type";
        GLEntry."Party No." := GenJournalLine."Party No.";
        GLEntry.Loan := GenJournalLine."T/R";
        GLEntry."Demand loan" := GenJournalLine."demand loan";
        GLEntry.Margin := GenJournalLine.Margin;
        GLEntry."Party Name" := GenJournalLine."Party Name";
        GLEntry."VAT Base 1" := GenJournalLine."VAT Base 1";
        GLEntry."Exempt Amount" := GenJournalLine."Exempt Amount";
        GLEntry."RBI Product Code" := GenJournalLine."RBI Product Code";
        GLEntry."Free Item Vendor No." := GenJournalLine."Free Item Vendor No.";
        GLEntry."Free Item Vendor Name" := GenJournalLine."Free Item Vendor Name";
        GLEntry."Account Name" := GenJournalLine."Account Name";
        IF GenJournalLine."Party No." <> '' THEN
            GLEntry."Party VAT Registration No." := GenJournalLine."VAT Registration No.";

        DimensionSetEntry.RESET;
        DimensionSetEntry.SETRANGE("Dimension Set ID", GenJournalLine."Dimension Set ID");
        DimensionSetEntry.SETRANGE("Dimension Code", 'EMPLOYEE');
        IF DimensionSetEntry.FINDFIRST THEN BEGIN
            GLEntry."Employee Code" := DimensionSetEntry."Dimension Value Code";
        END;
        GLEntry."Pass Value to Sales/Purch (LCY" := GenJournalLine."Skip Document Type";
        GLEntry."Exclude PP in VAT Book" := GenJournalLine."Exclude PP in VAT Book";

        //TDS1.00
        GLEntry."TDS Group" := GenJournalLine."TDS Group";
        GLEntry."TDS%" := GenJournalLine."TDS%";
        GLEntry."TDS Type" := GenJournalLine."TDS Type";
        GLEntry."TDS Amount" := GenJournalLine."TDS Amount";
        GLEntry."TDS Base Amount" := GenJournalLine."TDS Base Amount";
        //KMT2016CU5 <<


        //ASPL Feb 25th 2021 >>
        CLEAR(ShortcutCustomDimCode);
        DimMgt.GetShortcutDimensions(GLEntry."Dimension Set ID", ShortcutCustomDimCode);
        GLEntry.CopyShortcutDimensions(GLEntry, ShortcutCustomDimCode);
        //ASPL Feb 25th 2021 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterInsertReversalEntry', '', true, true)]
    local procedure OnAfterInsertReversalEntry(var TempRevertTransactionNo: Record Integer; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer; var TempReversalEntry: Record "Reversal Entry" temporary)
    var
        ReversalEntry: Record "Reversal Entry";
    begin
        ReversalEntry.InsertFromTDSEntry(TempRevertTransactionNo, Number, RevType, NextLineNo); //TDS1.00
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterCheckEntries', '', false, false)]
    local procedure OnAfterCheckEntries(var MaxPostingDate: Date)
    var
        TDSEntry: Record "TDS Entry";
        ReversalEntry: Record "Reversal Entry";
    begin
        TDSEntry.LOCKTABLE; //TDS1.00
                            //TDS1.00 >>
        IF TDSEntry.FIND('-') THEN
            REPEAT
                ReversalEntry.CheckTDS(TDSEntry);
            UNTIL TDSEntry.NEXT = 0;
        //TDS1.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterSetReverseFilter', '', false, false)]
    local procedure OnAfterSetReverseFilter(Number: Integer; RevType: Option Transaction,Register; GLRegister: Record "G/L Register")
    var
        TDSEntry: Record "TDS Entry";
        GLReg: Record "G/L Register";
    begin
        TDSEntry.SETCURRENTKEY("Transaction No."); //TDS1.00
        TDSEntry.SETRANGE("Transaction No.", Number); //TDS1.00
        TDSEntry.SETRANGE("Entry No.", GLReg."From TDS Entry No.", GLReg."To TDS Entry No."); //TDS1.00
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterCaption', '', false, false)]
    local procedure OnAfterCaption(ReversalEntry: Record "Reversal Entry"; var NewCaption: Text)
    var
        TDSEntry: Record "TDS Entry";
    begin
        IF ReversalEntry."Entry Type" = ReversalEntry."Entry Type"::TDS THEN
            NewCaption := STRSUBSTNO('%1', TDSEntry.TableCaption);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", 'OnBeforeReverse', '', false, false)] //this event maybe hit this produrce VerifyReversalEntries() in reverasal ext table
    local procedure OnBeforeReverse(var ReversalEntry: Record "Reversal Entry"; var ReversalEntry2: Record "Reversal Entry"; var IsHandled: Boolean)
    var
        CurrDoc: Code[20];
        PrevDoc: code[20];
    begin
        IF ReversalEntry2.FINDSET THEN
            REPEAT
                CurrDoc := ReversalEntry2."Document No.";
                IF (PrevDoc <> '') AND (PrevDoc <> CurrDoc) THEN
                    ERROR('Different Document No. Found while reverse.');
                PrevDoc := CurrDoc;
                ReversalEntry2.TESTFIELD("Document Type", ReversalEntry2."Document Type"::" ");
            UNTIL ReversalEntry2.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterInsertFromCustLedgEntry', '', false, false)]
    local procedure OnAfterInsertFromCustLedgEntry(var TempRevertTransactionNo: Record "Integer"; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer; var TempReversalEntry: Record "Reversal Entry" temporary; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SETCURRENTKEY("Transaction No.", "Customer No.", "Entry Type");
        DtldCustLedgEntry.SETFILTER(
          "Entry Type", '%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");  //changed here 
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterLookupCity', '', false, false)]
    local procedure OnAfterLookupCity(var Customer: Record Customer; var PostCodeRec: Record "Post Code")
    var
        Text100: Label 'Do you want to save?';
    begin
        PostCodeRec.LookupPostCode(customer.City, Customer."Post Code", customer.County, Customer."Country/Region Code");
        //KMT2016CU5 >>
        IF NOT CONFIRM(Text100, FALSE) THEN
            ERROR('Saving canceled');
        //KMT2016CU5 <<
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeSetStyle', '', false, false)]
    // local procedure OnBeforeSetStyle(var IsHandled: Boolean; var Style: Text)
    // var
    //     custledEnt: Record "Cust. Ledger Entry";
    // begin
    //     IF custledEnt.Open THEN BEGIN
    //         IF WORKDATE >= custledEnt."Due Date" THEN
    //     end
    //     end;   //modifed code is not exported full #dicuss this issues
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        CustRec: Record Customer;
        ShortcutCustomDimCode: array[8] of Code[20];
        DimMgt: Codeunit DimensionManagement;
        GLEntry: Record "G/L Entry";
    begin
        //KMT2016CU5 >>
        CustRec.RESET;
        CustRec.SETRANGE("No.", CustLedgerEntry."Customer No.");
        IF CustRec.FINDFIRST THEN BEGIN
            IF CustRec."Also Vendor" THEN
                CustLedgerEntry."Also Vendor" := CustRec."Also Vendor";
        END;
        CustLedgerEntry."Pass Value to Sales/Purch (LCY" := GenJournalLine."Skip Document Type";
        CLEAR(ShortcutCustomDimCode);
        DimMgt.GetShortcutDimensions(CustLedgerEntry."Dimension Set ID", ShortcutCustomDimCode);
        CustLedgerEntry.CopyShortcutDimensions(GLEntry, ShortcutCustomDimCode);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeLookupPostCode', '', false, false)]
    local procedure OnBeforeLookupPostCode(var Vendor: Record Vendor; var PostCodeRec: Record "Post Code")
    var
        Text100: Label 'Do you want to save?';
    begin
        PostCodeRec.LookupPostCode(vendor.City, Vendor."Post Code", vendor.County, Vendor."Country/Region Code");
        //KMT2016CU5 >>
        IF NOT CONFIRM(Text100, FALSE) THEN
            ERROR('Saving canceled');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelGeneralJournalBatchApprovalRequest', '', false, false)]
    local procedure OnCancelGeneralJournalBatchApprovalRequest(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Manage Template" THEN
            ERROR('No permission.');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Vend: Record Vendor;
        DimMgt: Codeunit DimensionManagement;
        ShortcutCustomDimCode: array[8] of Code[20];
        GLEntry: Record "G/L Entry";
    begin
        VendorLedgerEntry.PragyapanPatra := GenJournalLine.PragyapanPatra;
        VendorLedgerEntry."Letter of Credit/Telex Trans." := GenJournalLine."Letter of Credit/Telex Trans.";
        Vend.RESET;
        Vend.SETRANGE("No.", VendorLedgerEntry."Vendor No.");
        IF Vend.FINDFIRST THEN BEGIN
            IF Vend."Also Customer" THEN
                VendorLedgerEntry."Also Customer" := Vend."Also Customer"
        END;
        VendorLedgerEntry."Pass Value to Sales/Purch (LCY" := GenJournalLine."Skip Document Type";
        CLEAR(ShortcutCustomDimCode);
        DimMgt.GetShortcutDimensions(VendorLedgerEntry."Dimension Set ID", ShortcutCustomDimCode);
        VendorLedgerEntry.CopyShortcutDimensions(GLEntry, ShortcutCustomDimCode);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLines(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        DimMgt: Codeunit DimensionManagement;
        ShortcutCustomDimCode: array[8] of Code[20];
        GLEntry: Record "G/L Entry";
    begin
        CLEAR(ShortcutCustomDimCode);
        DimMgt.GetShortcutDimensions(BankAccountLedgerEntry."Dimension Set ID", ShortcutCustomDimCode);
        BankAccountLedgerEntry.CopyShortcutDimensions(GLEntry, ShortcutCustomDimCode);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterInitRecord(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        UserSetupMgt: Codeunit "User Setup Management";
        Cust: Record Customer;
    begin
        SalesSetup.GET;
        IF SalesSetup."Populate Damage Location" AND (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN BEGIN
            SalesSetup.TESTFIELD("Damage Location");
            SalesHeader."Location Code" := SalesSetup."Damage Location";

        END ELSE begin
            SalesHeader.Validate("Location Code", UserSetupMgt.GetLocation(0, Cust."Location Code", SalesHeader."Responsibility Center"));
        end;
        //ASPl Apr 6th 2021 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure OnAfterInvPostBufferPreparePurchase(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin
        InvoicePostBuffer.PragyapanPatra := PurchaseLine.PragyapanPatra;
        InvoicePostBuffer."Localized VAT Identifier" := PurchaseLine."Localized VAT Identifier";
        InvoicePostBuffer."Letter of Credit/Telex Trans." := PurchaseLine."Letter of Credit/Telex Trans.";
        InvoicePostBuffer."Party Type" := PurchaseLine."Party Type";
        InvoicePostBuffer."Party No." := PurchaseLine."Party No.";
        InvoicePostBuffer."Free Item Vendor No." := PurchaseLine."Free Item Vendor No.";
        InvoicePostBuffer."Free Item Vendor Name" := PurchaseLine."Free Item Vendor Name";
        IF PurchaseLine."FA Item Charge" <> '' THEN
            InvoicePostBuffer."FA Item Charge" := PurchaseLine."FA Item Charge";
        InvoicePostBuffer."Exclude PP in VAT Book" := PurchaseLine."Exclude PP in VAT Book";
        InvoicePostBuffer."Deferral Code" := PurchaseLine."Deferral Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterInitRecords(var TransferHeader: Record "Transfer Header")
    begin
        TransferHeader."Assigned User ID" := USERID;
    end;


}

