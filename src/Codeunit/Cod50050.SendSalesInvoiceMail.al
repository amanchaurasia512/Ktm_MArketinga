codeunit 50050 "Send Sales Invoice Mail"
{

    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure SendMail(SalesInvHead: Record "Sales Invoice Header")
    var
        Mail: Codeunit Mail;
        Tofile: Text[250];
        FileName: Text[250];
    begin
        CLEAR(Mail);

        Tofile := 'Invoice';

        FileName := TEMPORARYPATH + Tofile;

        REPORT.SAVEASPDF(206, FileName, SalesInvHead);

        //Tofile := DownloadToClientFileName(FileName, Tofile);

        // Mail.NewMessage('ishwarsharma016@gmail.com',  // << To Addresses

        //                 'ishwarsharma016@gmail.com',  // << Cc Addresses

        //                 'Sales Invoice',              // << Subject

        //                 'Please find attached Sales Invoice',  // <<Body

        //                 Tofile,  // << Attachment File Name

        //                 TRUE);   // << Show Outlook Dialog before sending mail
    end;

    // [Scope('OnPrem')]
    // procedure DownloadToClientFileName(ServerFileName: Text[250]; ToFile: Text[250]): Text[250]
    // var
    //     ClientFileName: Text[250];
    //     objScript: Automation;
    //     CR: Text[1];
    // begin
    //     ClientFileName := ToFile;
    //     IF NOT DOWNLOAD(ServerFileName, '', '<TEMP>', '', ClientFileName) THEN
    //         EXIT('');
    //     //IF CREATE(objScript, TRUE, TRUE) THEN BEGIN
    //         CR := ' ';
    //         CR[1] := 13;
    //         //objScript.Language := 'VBScript';
    //         objScript.AddCode(
    //         'function RenameTempFile(fromFile, toFile)' + CR +
    //         'set fso = createobject("Scripting.FileSystemObject")' + CR +
    //         'set x = createobject("Scriptlet.TypeLib")' + CR +
    //         'path = fso.getparentfoldername(fromFile)' + CR +
    //         'toPath = path+"\"+left(x.GUID,38)' + CR +
    //         'fso.CreateFolder toPath' + CR +
    //         'fso.MoveFile fromFile, toPath+"\"+toFile' + CR +
    //         'RenameTempFile = toPath' + CR +
    //         'end function');
    //         ClientFileName := objScript.Eval('RenameTempFile("' + ClientFileName + '","' + ToFile + '")');
    //         ClientFileName := ClientFileName + '\' + ToFile;
    //     END;
    //     EXIT(ClientFileName);
    // end;
}

