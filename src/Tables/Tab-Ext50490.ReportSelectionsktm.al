tableextension 50490 "Report Selections_ktm" extends "Report Selections"
{
    fields
    {
        modify(Usage)
        {
            OptionCaption = 'S.Quote,S.Order,S.Invoice,S.Cr.Memo,S.Test,P.Quote,P.Order,P.Invoice,P.Cr.Memo,P.Receipt,P.Ret.Shpt.,P.Test,B.Stmt,B.Recon.Test,B.Check,Reminder,Fin.Charge,Rem.Test,F.C.Test,Prod. Order,S.Blanket,P.Blanket,M1,M2,M3,M4,Inv1,Inv2,Inv3,SM.Quote,SM.Order,SM.Invoice,SM.Credit Memo,SM.Contract Quote,SM.Contract,SM.Test,S.Return,P.Return,S.Shipment,S.Ret.Rcpt.,S.Work Order,Invt. Period Test,SM.Shipment,S.Test Prepmt.,P.Test Prepmt.,S.Arch. Quote,S.Arch. Order,P.Arch. Quote,P.Arch. Order,S. Arch. Return Order,P. Arch. Return Order,Asm. Order,P.Assembly Order,S.Order Pick Instruction,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,C.Statement,V.Remittance,Sales Inv. Confirmation';

            //Unsupported feature: Property Modification (OptionString) on "Usage(Field 1)".

        }
    }

    //Unsupported feature: Code Modification on "SendEmailDirectly(PROCEDURE 50)".

    //procedure SendEmailDirectly();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    AllEmailsWereSuccessful := TRUE;

    ShowNoBodyNoAttachmentError(ReportUsage,FoundBody,FoundAttachment);
    #4..6
        DocumentMailing.EmailFile('','',ServerEmailBodyFilePath,DocNo,EmailAddress,DocName,NOT ShowDialog,ReportUsage);

    IF FoundAttachment THEN BEGIN
      IF ReportUsage = Usage::JQ THEN BEGIN
        Usage := ReportUsage;
        CustomReportSelection.SETFILTER(Usage,GETFILTER(Usage));
        IF CustomReportSelection.FINDFIRST THEN
    #14..38

    OnAfterSendEmailDirectly(ReportUsage,RecordVariant,AllEmailsWereSuccessful);
    EXIT(AllEmailsWereSuccessful);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
      IF ReportUsage = Usage::"P.Order" THEN BEGIN //Usage::JQ
    #11..41
    */
    //end;


    //Unsupported feature: Code Modification on "ReportUsageToDocumentType(PROCEDURE 53)".

    //procedure ReportUsageToDocumentType();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE ReportUsage OF
      Usage::"S.Invoice",Usage::"S.Invoice Draft",Usage::"P.Invoice":
        DocumentType := SalesHeader."Document Type"::Invoice;
      Usage::"S.Quote",Usage::"P.Quote":
        DocumentType := SalesHeader."Document Type"::Quote;
    #6..10
        EXIT(FALSE);
    END;
    EXIT(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CASE ReportUsage OF
      Usage::"S.Invoice",Usage::"S.Invoice",Usage::"P.Invoice":       //S.Invoice Draft
    #3..13
    */
    //end;
}

