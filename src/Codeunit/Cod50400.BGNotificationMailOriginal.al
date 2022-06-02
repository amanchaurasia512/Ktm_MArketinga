codeunit 50400 "BG Notification Mail Original"
{

    trigger OnRun()
    begin
        SendBGNotificationMail();
    end;

    var
        BGmsgBody: Label 'Your payment due is %1 and your remaining balance is %2';
        CustRec: Record Customer;

    [Scope('OnPrem')]
    procedure SendBGNotificationMail()
    var
        Customer: Record Customer;
        BGDetails: Record "Area";
        SMTPMailSetup: Record "SMTP Mail Setup";// move to Eamil -smtp
        SMTPMail: Codeunit "Email Message"; //replaced with email messgae
        ReminderDays: Integer;
        SendMail: Boolean;
        Tofile: Text;
        FileName: Text;
        MailReport: Report "Customer - Detail Trial Bal.";
        CustDetailTrialRangeFile: Text;
        StartDate: Code[15];
        EndDate: Code[15];
        SalesSetup: Record "Sales & Receivables Setup";
        EmailSubject: Text;
        MessageBody: Text;
        EmailBody: Text;
    begin
        CLEAR(SMTPMail);
        ReminderDays := 0;
        Tofile := '';
        FileName := '';
        StartDate := '';
        EndDate := '';
        SendMail := FALSE;
        SMTPMailSetup.GET;

        SalesSetup.GET;
        SalesSetup.TESTFIELD("First Reminder Days");  // to be confirmed with Fanindra Ji whether to ake mandatory or not
        SalesSetup.TESTFIELD("Second Reminder Days");  // to be confirmed with Fanindra Ji whether to ake mandatory or not
        SalesSetup.TESTFIELD("Third Reminder Days"); // to be confirmed with Fanindra Ji whether to ake mandatory or not
        SalesSetup.TESTFIELD("First Reminder Email");  // to be confirmed with Fanindra Ji whether to ake mandatory or not
        SalesSetup.TESTFIELD("Second Reminder Email");  // to be confirmed with Fanindra Ji whether to ake mandatory or not
        SalesSetup.TESTFIELD("Third Reminder Email"); // to be confirmed with Fanindra Ji whether to ake mandatory or not

        BGDetails.RESET;
        BGDetails.SETFILTER("End Date (AD)", '>%1', TODAY);
        IF BGDetails.FINDFIRST THEN
            REPEAT
                BGDetails."Reminder Days" := BGDetails."End Date (AD)" - TODAY;
                BGDetails.MODIFY;
            UNTIL BGDetails.NEXT = 0;

        Tofile := 'Customer Bank Guarantee Details';
        FileName := 'E:\BG\' + Tofile + '.pdf';

        MessageBody := 'Please find the attachment for the Customer Bank Guarantee Reminder Details.';

        EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
        EmailBody := EmailBody + 'Dear Sir/Mam,' + '<br><br>';
        EmailBody := EmailBody + MessageBody + '<br><br> Regards,<br><br> Sincerely yours, <br>'
                      + SalesSetup."Sender Name" + '<br><br><hr>';

        BGDetails.RESET;
        BGDetails.SETFILTER("End Date (AD)", '>%1', TODAY);
        BGDetails.SETFILTER("Reminder Days", '%1', SalesSetup."First Reminder Days");
        IF BGDetails.FINDSET THEN BEGIN
            REPORT.SAVEASPDF(50053, FileName, BGDetails);
            EmailSubject := 'Customer BG Reminder Days - ' + FORMAT(SalesSetup."First Reminder Days");
            //SMTPMail.CreateMessage(SalesSetup."Sender Name", SMTPMailSetup."User ID", SalesSetup."First Reminder Email", EmailSubject, EmailBody, TRUE);
            //SMTPMail.AddAttachment(FileName, Tofile + '.pdf');
            //SendMail := SMTPMail.TrySend;
            IF SendMail THEN
                MESSAGE('Mail Sent Successfuly from first reminder days');
        END;

        BGDetails.RESET;
        BGDetails.SETFILTER("End Date (AD)", '>%1', TODAY);
        BGDetails.SETFILTER("Reminder Days", '%1', SalesSetup."Second Reminder Days");
        IF BGDetails.FINDSET THEN BEGIN
            REPORT.SAVEASPDF(50053, FileName, BGDetails);
            EmailSubject := 'Customer BG Reminder Days - ' + FORMAT(SalesSetup."Second Reminder Days");
            // SMTPMail.CreateMessage(SalesSetup."Sender Name", SMTPMailSetup."User ID", SalesSetup."Second Reminder Email", EmailSubject, EmailBody, TRUE);
            // SMTPMail.AddAttachment(FileName, Tofile + '.pdf');
            // SendMail := SMTPMail.TrySend;
            IF SendMail THEN
                MESSAGE('Mail Send Successfully from second reminder days');
        END;

        BGDetails.RESET;
        BGDetails.SETFILTER("End Date (AD)", '>%1', TODAY);
        BGDetails.SETFILTER("Reminder Days", '%1', SalesSetup."Third Reminder Days");
        IF BGDetails.FINDSET THEN BEGIN
            REPORT.SAVEASPDF(50053, FileName, BGDetails);
            EmailSubject := 'Customer BG Reminder Days - ' + FORMAT(SalesSetup."Third Reminder Days");
            // SMTPMail.CreateMessage(SalesSetup."Sender Name", SMTPMailSetup."User ID", SalesSetup."Third Reminder Email", EmailSubject, EmailBody, TRUE);
            // SMTPMail.AddAttachment(FileName, Tofile + '.pdf');
            // SendMail := SMTPMail.TrySend;
            IF SendMail THEN
                MESSAGE('Mail Send Successfully from third reminder days');
        END;
    end;

    local procedure DownloadtoClientFileName(ServerFileName: Text[250]; ToFile: Text[250]): Text[250]
    var
        ClientFileName: Text[250];
        //ObjScript: Automation;
        CR: Text[1];
    begin
        ClientFileName := ToFile;
        IF NOT DOWNLOAD(ServerFileName, '', '<TEMP>', '', ClientFileName) THEN
            EXIT('');
        // IF CREATE(ObjScript, TRUE, TRUE) THEN BEGIN
        //     CR := '';
        //     CR[1] := 13;
        //     ObjScript.Language := 'VBScript';
        //     ObjScript.AddCode(
        // 'function RenameTempFile(fromFile, toFile)' + CR +
        //     'set fso = createobject("Scripting.FileSystemObject")' + CR +
        //     'set x = createobject("Scriptlet.TypeLib")' + CR +
        //     'path = fso.getparentfoldername(fromFile)' + CR +
        //     'toPath = path+"\"+left(x.GUID,38)' + CR +
        //     'fso.CreateFolder toPath' + CR +
        //     'fso.MoveFile fromFile, toPath+"\"+toFile' + CR +
        //     'RenameTempFile = toPath' + CR +
        //     'end function');
        //     ClientFileName := ObjScript.Eval('RenameTempFile("' + ClientFileName + '","' + ToFile + '")');
        //     ClientFileName := ClientFileName + '\' + ToFile;
        // END;
        // EXIT(ClientFileName);
    end;
}

