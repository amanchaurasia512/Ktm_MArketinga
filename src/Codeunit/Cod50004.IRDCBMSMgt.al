codeunit 50004 "IRD CBMS Mgt."
{
    TableNo = 50001;

    trigger OnRun()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServInvoiceHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        InvoiceMaterializedView := Rec;
        IF InvoiceMaterializedView."Document Type" = InvoiceMaterializedView."Document Type"::"Sales Invoice" THEN BEGIN
            IF NOT SalesInvoiceHeader.GET(InvoiceMaterializedView."Bill No") THEN
                IF NOT ServInvoiceHeader.GET(InvoiceMaterializedView."Bill No") THEN
                    EXIT;
            PushBill;
        END
        ELSE
            IF InvoiceMaterializedView."Document Type" = InvoiceMaterializedView."Document Type"::"Sales Credit Memo" THEN BEGIN
                IF NOT SalesCrMemoHeader.GET(InvoiceMaterializedView."Bill No") THEN
                    IF NOT ServCrMemoHeader.GET(InvoiceMaterializedView."Bill No") THEN
                        EXIT;
                PushCreditBill;
            END;
        Rec := InvoiceMaterializedView;
        COMMIT;
    end;

    var
        InvoiceMaterializedView: Record "Invoice Materialize View";
        CompanyInfo: Record "Company Information";
        TotalSalesAmount: Decimal;
        TotalTaxableAmount: Decimal;
        TotalNonTaxableAmount: Decimal;
        TotalVATAmount: Decimal;
        BillType: Option Invoice,"Credit Memo";
        RealTimeTransaction: Boolean;
        IRDMgt: Codeunit "IRD Mgt.";

    [Scope('OnPrem')]
    procedure PushBill()
    var
        CompanyInformation: Record "Company Information";
        BillUpdateinIRD: Boolean;
        IRDWebService: Codeunit "IRD Web Service Mgt.";
        NepaliDate: Text;
        ResponseMessage: Text;
    begin
        CompanyInformation.GET;
        IF NOT InvoiceMaterializedView.MODIFY THEN
            EXIT;
        NepaliDate := IRDMgt.getNepaliDate(InvoiceMaterializedView."Bill Date");
        BillUpdateinIRD := IRDWebService.PushBill(
                CompanyInformation."VAT Registration No.",
                InvoiceMaterializedView."VAT Registration No.",
                InvoiceMaterializedView."Customer Name",
                InvoiceMaterializedView."Fiscal Year",
                InvoiceMaterializedView."Bill No",
                ReplaceString(FORMAT(NepaliDate), '/', '.'),
                InvoiceMaterializedView."Taxable Amount" + InvoiceMaterializedView."TAX Amount",
                InvoiceMaterializedView."Taxable Amount",
                InvoiceMaterializedView."TAX Amount",
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                InvoiceMaterializedView."Non Taxable Amount", RealTimeTransaction, CREATEDATETIME(InvoiceMaterializedView."Bill Date", InvoiceMaterializedView."Posting Time"), ResponseMessage);
        IF BillUpdateinIRD THEN BEGIN
            InvoiceMaterializedView."Sync Status" := InvoiceMaterializedView."Sync Status"::"Sync Completed";
            InvoiceMaterializedView."Sync with IRD" := TRUE;
            InvoiceMaterializedView."Synced Date" := TODAY;
            InvoiceMaterializedView."Synced Time" := TIME;
            InvoiceMaterializedView."Is RealTime" := RealTimeTransaction;
            InvoiceMaterializedView."CBMS Sync. Response" := '200: Success';
            InvoiceMaterializedView.MODIFY;
        END ELSE BEGIN
            InvoiceMaterializedView."CBMS Sync. Response" := ResponseMessage;
            InvoiceMaterializedView.MODIFY;
        END;
    end;

    [Scope('OnPrem')]
    procedure PushCreditBill()
    var
        CompanyInformation: Record "Company Information";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ReturnReason: Record "Return Reason";
        BillUpdateinIRD: Boolean;
        IRDWebService: Codeunit "IRD Web Service Mgt.";
        ReturnedDocNo: Code[20];
        ReturnReasonDesc: Text;
        NepaliDate: Text;
        ServInvoiceHeader: Record "Service Invoice Header";
        ServCrMemoLine: Record "Service Cr.Memo Line";
        ResponseMessage: Text;
    begin
        CompanyInformation.GET;
        IF NOT InvoiceMaterializedView.MODIFY THEN
            EXIT;
        NepaliDate := IRDMgt.getNepaliDate(InvoiceMaterializedView."Bill Date");
        ReturnedDocNo := '';
        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE("Document No.", InvoiceMaterializedView."Bill No");
        SalesCrMemoLine.SETFILTER("Returned Document No.", '<>%1', '');
        IF SalesCrMemoLine.FINDFIRST THEN BEGIN
            ReturnReasonDesc := SalesCrMemoLine."Return Reason Code";
            CLEAR(ReturnReason);
            IF ReturnReason.GET(SalesCrMemoLine."Return Reason Code") THEN
                ReturnReasonDesc := ReturnReason.Description;
            ReturnedDocNo := SalesCrMemoLine."Returned Document No.";
            IF SalesInvoiceHeader.GET(ReturnedDocNo) THEN BEGIN
                BillUpdateinIRD := IRDWebService.PushCreditBill(
                        CompanyInformation."VAT Registration No.",
                        InvoiceMaterializedView."VAT Registration No.",
                        InvoiceMaterializedView."Customer Name",
                        InvoiceMaterializedView."Fiscal Year",
                        ReturnedDocNo,
                        ReplaceString(FORMAT(NepaliDate), '/', '.'),
                        InvoiceMaterializedView."Bill No",
                        InvoiceMaterializedView."Taxable Amount" + InvoiceMaterializedView."TAX Amount",
                        InvoiceMaterializedView."Taxable Amount",
                        InvoiceMaterializedView."TAX Amount",
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        InvoiceMaterializedView."Non Taxable Amount", RealTimeTransaction, CREATEDATETIME(InvoiceMaterializedView."Bill Date", InvoiceMaterializedView."Posting Time"),
                        ReturnReasonDesc, ResponseMessage);
                IF BillUpdateinIRD THEN BEGIN
                    InvoiceMaterializedView."Sync Status" := InvoiceMaterializedView."Sync Status"::"Sync Completed";
                    InvoiceMaterializedView."Sync with IRD" := TRUE;
                    InvoiceMaterializedView."Synced Date" := TODAY;
                    InvoiceMaterializedView."Synced Time" := TIME;
                    InvoiceMaterializedView."Is RealTime" := RealTimeTransaction;
                    InvoiceMaterializedView."CBMS Sync. Response" := '200: Success';
                    InvoiceMaterializedView.MODIFY;
                END ELSE BEGIN
                    InvoiceMaterializedView."CBMS Sync. Response" := ResponseMessage;
                    InvoiceMaterializedView.MODIFY;
                END;
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure PushBatchBill(var InvoiceMaterializedView: Record "Invoice Materialize View")
    var
        PushInvoices: Codeunit "IRD CBMS Mgt.";
    begin
        IF InvoiceMaterializedView.FINDFIRST THEN
            REPEAT
                IF InvoiceMaterializedView."Sync Status" IN [InvoiceMaterializedView."Sync Status"::"Sync In Progress", InvoiceMaterializedView."Sync Status"::Pending] THEN BEGIN
                    CLEAR(PushInvoices);
                    IF PushInvoices.RUN(InvoiceMaterializedView) THEN;
                END;
            UNTIL InvoiceMaterializedView.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure SetRealTime()
    begin
        RealTimeTransaction := RealTimeEnabled;
    end;

    [Scope('OnPrem')]
    procedure Enabled(): Boolean
    begin
        CompanyInfo.GET;
        EXIT((CompanyInfo."CBMS Base URL" <> '') AND
             (CompanyInfo."CBMS Username" <> '') AND
             (CompanyInfo."CBMS Password" <> ''))
    end;

    [Scope('OnPrem')]
    procedure RealTimeEnabled(): Boolean
    begin
        CompanyInfo.GET;
        EXIT(CompanyInfo."Enable CBMS Realtime Sync");
    end;

    [Scope('OnPrem')]
    procedure StartRealTimeCBMSIntegration(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        PushInvoices: Codeunit "IRD CBMS Mgt.";
        SalesData: Record "Invoice Materialize View";
    begin
        IF SalesHeader.Invoice THEN BEGIN
            IF SalesInvHeader."No." <> '' THEN BEGIN
                CLEAR(PushInvoices);
                IF PushInvoices.Enabled THEN BEGIN
                    IF PushInvoices.RealTimeEnabled THEN BEGIN
                        PushInvoices.SetRealTime;
                        SalesData.RESET;
                        SalesData.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
                        SalesData.SETRANGE("Document Type", SalesData."Document Type"::"Sales Invoice");
                        SalesData.SETRANGE("Bill No", SalesInvHeader."No.");
                        IF SalesData.FINDLAST THEN BEGIN
                            COMMIT;
                            IF NOT PushInvoices.RUN(SalesData) THEN;
                        END;
                    END;
                END;
            END
            ELSE
                IF SalesCrMemoHeader."No." <> '' THEN BEGIN
                    CLEAR(PushInvoices);
                    IF PushInvoices.Enabled THEN BEGIN
                        IF PushInvoices.RealTimeEnabled THEN BEGIN
                            PushInvoices.SetRealTime;
                            SalesData.RESET;
                            SalesData.SETRANGE("Table ID", DATABASE::"Sales Cr.Memo Header");
                            SalesData.SETRANGE("Document Type", SalesData."Document Type"::"Sales Credit Memo");
                            SalesData.SETRANGE("Bill No", SalesCrMemoHeader."No.");
                            IF SalesData.FINDLAST THEN BEGIN
                                COMMIT;
                                IF NOT PushInvoices.RUN(SalesData) THEN;
                            END;
                        END;
                    END;
                END;
        END;
    end;

    [Scope('OnPrem')]
    procedure StartBatchCBMSIntegration(var InvoiceMaterializeView: Record "Invoice Materialize View")
    var
        PushInvoices: Codeunit "IRD CBMS Mgt.";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnedDocNo: Code[20];
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        IF (InvoiceMaterializeView."Sync Status" = InvoiceMaterializeView."Sync Status"::"Sync In Progress") OR
            (InvoiceMaterializeView."Sync Status" = InvoiceMaterializeView."Sync Status"::Pending)
        THEN BEGIN
            IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Invoice" THEN BEGIN
                IF (SalesInvoiceHeader.GET(InvoiceMaterializeView."Bill No") OR ServiceInvoiceHeader.GET(InvoiceMaterializeView."Bill No")) THEN BEGIN
                    CLEAR(PushInvoices);
                    IF PushInvoices.Enabled THEN BEGIN
                        COMMIT;
                        IF NOT PushInvoices.RUN(InvoiceMaterializeView) THEN;
                    END;
                END;
            END
            ELSE
                IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Credit Memo" THEN BEGIN
                    IF (SalesCrMemoHeader.GET(InvoiceMaterializeView."Bill No") OR ServiceCrMemoHeader.GET(InvoiceMaterializeView."Bill No")) THEN BEGIN
                        CLEAR(PushInvoices);
                        IF PushInvoices.Enabled THEN BEGIN
                            COMMIT;
                            IF NOT PushInvoices.RUN(InvoiceMaterializeView) THEN;
                        END;
                    END;
                END
        END;
    end;

    [Scope('OnPrem')]
    procedure SendDataForSync(var InvoiceMaterializeView: Record "Invoice Materialize View"; NewStatus: Option "Not Valid","Pending Approval","Sync In Progress","Sync Completed")
    var
        NewInvoiceMaterializeView: Record "Invoice Materialize View";
    begin
        IF InvoiceMaterializeView.FINDSET THEN
            REPEAT
                IF InvoiceMaterializeView."Sync Status" IN [InvoiceMaterializeView."Sync Status"::"Sync In Progress", InvoiceMaterializeView."Sync Status"::Pending] THEN BEGIN
                    NewInvoiceMaterializeView := InvoiceMaterializeView;
                    NewInvoiceMaterializeView."Sync Status" := NewStatus;
                    NewInvoiceMaterializeView.MODIFY;
                END;
            UNTIL InvoiceMaterializeView.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure GetAmounts(BillType: Option Invoice,"Credit Memo"; BillNo: Code[20])
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        TotalSalesAmount := 0;
        TotalTaxableAmount := 0;
        TotalNonTaxableAmount := 0;
        TotalVATAmount := 0;
        CASE BillType OF
            BillType::Invoice:
                BEGIN
                    SalesInvoiceLine.RESET;
                    SalesInvoiceLine.SETRANGE("Document No.", BillNo);
                    IF SalesInvoiceLine.FINDFIRST THEN BEGIN
                        TotalSalesAmount += SalesInvoiceLine.Amount;
                        IF SalesInvoiceLine."VAT %" = 0 THEN BEGIN
                            TotalNonTaxableAmount += SalesInvoiceLine.Amount;
                        END
                        ELSE BEGIN
                            TotalTaxableAmount += SalesInvoiceLine.Amount;
                            TotalVATAmount += ROUND((SalesInvoiceLine.Amount * SalesInvoiceLine."VAT %" / 100), 0.01);
                        END;
                    END;
                END;
            BillType::"Credit Memo":
                BEGIN
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", BillNo);
                    IF SalesCrMemoLine.FINDFIRST THEN BEGIN
                        TotalSalesAmount += SalesCrMemoLine.Amount;
                        IF SalesCrMemoLine."VAT %" = 0 THEN BEGIN
                            TotalNonTaxableAmount += SalesCrMemoLine.Amount;
                        END
                        ELSE BEGIN
                            TotalTaxableAmount += SalesCrMemoLine.Amount;
                            TotalVATAmount += ROUND((SalesCrMemoLine.Amount * SalesCrMemoLine."VAT %" / 100), 0.01);
                        END;
                    END;
                END;
        END;
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
        EXIT(NewString);
    end;

    [Scope('OnPrem')]
    procedure StartServiceInvoiceRealTimeCBMSIntegration(var ServHeader: Record "Service Header"; var ServInvHdr: Record "Service Invoice Header")
    var
        PushInvoices: Codeunit "IRD CBMS Mgt.";
        SalesData: Record "Invoice Materialize View";
    begin
        IF ServInvHdr."No." <> '' THEN BEGIN
            CLEAR(PushInvoices);
            IF PushInvoices.Enabled THEN BEGIN
                IF PushInvoices.RealTimeEnabled THEN BEGIN
                    PushInvoices.SetRealTime;
                    SalesData.RESET;
                    SalesData.SETRANGE("Table ID", DATABASE::"Service Invoice Header");
                    SalesData.SETRANGE("Document Type", SalesData."Document Type"::"Sales Invoice");
                    SalesData.SETRANGE("Bill No", ServInvHdr."No.");
                    IF SalesData.FINDLAST THEN BEGIN
                        COMMIT;
                        IF NOT PushInvoices.RUN(SalesData) THEN;
                    END;
                END;
            END;
        END
    end;

    [Scope('OnPrem')]
    procedure StartServiceCrMemoRealTimeCBMSIntegration(var ServHeader: Record "Service Header"; var ServCrMemoHdr: Record "Service Cr.Memo Header")
    var
        PushInvoices: Codeunit "IRD CBMS Mgt.";
        SalesData: Record "Invoice Materialize View";
    begin
        IF ServCrMemoHdr."No." <> '' THEN BEGIN
            CLEAR(PushInvoices);
            IF PushInvoices.Enabled THEN BEGIN
                IF PushInvoices.RealTimeEnabled THEN BEGIN
                    PushInvoices.SetRealTime;
                    SalesData.RESET;
                    SalesData.SETRANGE("Table ID", DATABASE::"Service Cr.Memo Header");
                    SalesData.SETRANGE("Document Type", SalesData."Document Type"::"Sales Credit Memo");
                    SalesData.SETRANGE("Bill No", ServCrMemoHdr."No.");
                    IF SalesData.FINDLAST THEN BEGIN
                        COMMIT;
                        IF NOT PushInvoices.RUN(SalesData) THEN;
                    END;
                END;
            END;
        END;
    end;
}

