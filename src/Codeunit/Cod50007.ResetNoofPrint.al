codeunit 50007 "Reset No. of Print"
{
    Permissions = TableData 112 = rimd,
                  TableData 50001 = rimd,
                  TableData 50002 = rimd;
    TableNo = 112;

    trigger OnRun()
    begin
    end;

    var
        CfmResetNoOfPrint: Label 'Do you want to reset no. of Print to Zero for invoice %1?';

    [Scope('OnPrem')]
    procedure ResetPrint(SalesInvoice: Record "Sales Invoice Header")
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvoicePrintHistory: Record "Sales Invoice Print History";
    begin
        IF NOT CONFIRM(CfmResetNoOfPrint, FALSE, SalesInvoice."No.") THEN
            EXIT;
        SalesInvoicePrintHistory.RESET;
        SalesInvoicePrintHistory.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
        SalesInvoicePrintHistory.SETRANGE("Document Type", SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
        SalesInvoicePrintHistory.SETRANGE("Document No.", SalesInvoice."No.");
        SalesInvoicePrintHistory.DELETEALL;
        SalesInvoice."No. Printed" := 0;
        SalesInvoice.MODIFY;
    end;
}

