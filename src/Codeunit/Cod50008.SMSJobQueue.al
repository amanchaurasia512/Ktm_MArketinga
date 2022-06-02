codeunit 50008 "SMS Job Queue"
{

    trigger OnRun()
    begin
        SMSWebService.SendHolidaySMS;
        SMSWebService.SendInvoiceAgeingSMS;
        // CustLedgerEntry.RESET;
        // CustLedgerEntry.SETFILTER("Posting Date",'%1..%2',DMY2DATE(17,3,2021),TODAY);
        // IF CustLedgerEntry.FINDFIRST THEN REPEAT
        //  CustLedgerEntry."Document Type" := CustLedgerEntry."Document Type"::Invoice;
        //  CustLedgerEntry.MODIFY;
        //  UNTIL CustLedgerEntry.NEXT = 0;
    end;

    var
        SMSWebService: Codeunit "SMS Web Service";
        CustLedgerEntry: Record "Cust. Ledger Entry";
}

