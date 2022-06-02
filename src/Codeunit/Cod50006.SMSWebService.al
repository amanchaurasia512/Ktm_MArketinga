codeunit 50006 "SMS Web Service"
{

    trigger OnRun()
    begin
    end;

    var
        SMSSetup: Record "Company Information";
        Text000: Label 'Sending SMS...';
        Text001: Label 'Sending SMS message failed!\Statuscode: %1\Description: %2';
        newMessage: Text;
        SMSDetails2: Record "Tax Jurisdiction";

    [Scope('OnPrem')]
    procedure SendSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]; MessageLength: Integer): Boolean
    begin
        IF SMSSetup."Enable Agile SMS Gateway" THEN BEGIN
            EXIT(SendAgileSMS(PhoneNo, MessageText, MessageID, MessageLength))
        END ELSE BEGIN
            EXIT(SendSparrowSMS(PhoneNo, MessageText, MessageID));
        END;
    end;

    local procedure SendAgileSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]; MessageLength: Integer) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        //encoding: DotNet Encoding;
        result: DotNet String;
        //resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        JsonConvert: DotNet JsonConvert;
        null: DotNet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
    begin
        SMSSetup.TESTFIELD("Agile Base URL");
        SMSSetup.TESTFIELD("Agile User Name");
        SMSSetup.TESTFIELD("Agile Password Key");
        SMSSetup.TESTFIELD("Agile SMS Length (1st)");
        SMSSetup.TESTFIELD("Agile SMS Length (2nd & above)");
        SMSSetup.TESTFIELD("SMS Length (1st) Unicode");
        SMSSetup.TESTFIELD("SMS Length (2nd & above) Unico");

        IF GUIALLOWED THEN
            Window.OPEN(Text000);

        data := '{"clientCode":"' + SMSSetup."Agile Client Code" + '","';
        data += 'mobileNumber":"' + PhoneNo + '","';
        data += 'textMessage":"' + MessageText + '","';
        data += 'messageLength":"' + FORMAT(CalculateMessageLength(MessageText)) + '"}';
        //data += 'messageLength":"'+FORMAT(250)+'"}';

        //tringContent := stringContent.StringContent(data, encoding.UTF8, 'application/json');


        ReturnValue := CallRESTWebService(SMSSetup."Agile Base URL",
                                                           SMSSetup."Agile Method",
                                                           FORMAT(SMSSetup."Agile RESTMethod"),
                                                           stringContent,
                                                           HttpResponseMessage);
        IF GUIALLOWED THEN
            Window.CLOSE;
        IF NOT ReturnValue THEN
            EXIT;

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;

        MessageID := result;

        separator := ',';
        //resultParts := result.Split(separator.ToCharArray());
        statusCode := FORMAT(result);
        ResponseCode := COPYSTR(statusCode, STRPOS(statusCode, 'response_code') + 16, 3);

        EXIT(TRUE);
    end;

    local procedure SendSparrowSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        // encoding: DotNet Encoding;
        //result: DotNet String;
        //resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        JsonConvert: DotNet JsonConvert;
        null: DotNet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
    begin
        IF SMSSetup."User Name" = '' THEN
            EXIT;
        SMSSetup.TESTFIELD("User Name");
        SMSSetup.TESTFIELD("Password Key");
        SMSSetup.TESTFIELD("SMS Text Length");

        IF GUIALLOWED THEN
            Window.OPEN(Text000);

        data := 'token=' + SMSSetup.Token;
        data += '&username=' + SMSSetup."User Name";
        //data += '&password=' + SMSSetup.GetPassword;
        data += '&from=' + SMSSetup.Identity;
        data += '&to=' + PhoneNo;
        data += '&text=' + COPYSTR(MessageText, 1, SMSSetup."SMS Text Length");

        // stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/x-www-form-urlencoded');


        ReturnValue := CallRESTWebService(SMSSetup."Base URL",
                                                           SMSSetup.Method,
                                                           FORMAT(SMSSetup.RESTMethod),
                                                           stringContent,
                                                           HttpResponseMessage);
        IF GUIALLOWED THEN
            Window.CLOSE;

        IF NOT ReturnValue THEN
            EXIT;

        //result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        //MESSAGE('result--->'+FORMAT(result));

        separator := ',';
        // resultParts := result.Split(separator.ToCharArray());
        // statusCode := FORMAT(result);
        ResponseCode := COPYSTR(statusCode, STRPOS(statusCode, 'response_code') + 16, 3);

        IF (ResponseCode = '200') THEN BEGIN
            EXIT(TRUE);
        END
        ELSE BEGIN
            EXIT(FALSE);
        END;
    end;

    [TryFunction]
    [Scope('OnPrem')]
    procedure CallRESTWebService(BaseUrl: Text; Method: Text; RestMethod: Text; var HttpContent: DotNet HttpContent; var HttpResponseMessage: DotNet HttpResponseMessage)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
        HttpClientHandler: DotNet HttpClientHandler;
        NetCredential: DotNet NetworkCredential;
    begin
        HttpClientHandler := HttpClientHandler.HttpClientHandler;

        //add httpclienthandler to httpclient:
        IF SMSSetup."Enable Agile SMS Gateway" THEN BEGIN
            HttpClientHandler.Credentials := NetCredential.NetworkCredential(SMSSetup."Agile User Name", SMSSetup."Agile Password Key");
            HttpClient := HttpClient.HttpClient(HttpClientHandler)
        END ELSE BEGIN
            HttpClient := HttpClient.HttpClient();
        END;

        HttpClient.BaseAddress := Uri.Uri(BaseUrl);

        CASE RestMethod OF
            'GET':
                HttpResponseMessage := HttpClient.GetAsync(Method).Result;
            'POST':
                BEGIN
                    IF SMSSetup."Enable Agile SMS Gateway" THEN
                        HttpResponseMessage := HttpClient.PostAsync('Microsoft.NAV.sendSMSviaAgileGateway', HttpContent).Result
                    ELSE
                        HttpResponseMessage := HttpClient.PostAsync(Method, HttpContent).Result;
                END;
            'PUT':
                HttpResponseMessage := HttpClient.PutAsync(Method, HttpContent).Result;
            'DELETE':
                HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        END;

        HttpResponseMessage.EnsureSuccessStatusCode();
    end;

    [Scope('OnPrem')]
    procedure PopUpForTestSMS(TestMsg: Text; TestMblNo: Code[10])
    var
        PageBuilderSMSDetails: FilterPageBuilder;
        SMSDetails: Record "Tax Jurisdiction";
        MobileNo: Text;
        MessageText: Text;
        MessageID: Text;
        MessageLength: Integer;
        SMSTemplate: Record "Transaction Specification";
    begin
        SMSSetup.GET;
        InsertSMSDetail(SMSTemplate, '', TestMblNo, TestMsg);
    end;

    local procedure CalculateMessageLength(TextMessage: Text): Integer
    var
        AsciiBytesCount: Integer;
        UnicodeBytesCount: Integer;
    //Encoding: DotNet Encoding;
    begin
        // AsciiBytesCount := Encoding.ASCII.GetByteCount(TextMessage);
        // UnicodeBytesCount := Encoding.Unicode.GetByteCount(TextMessage);
        IF AsciiBytesCount <> UnicodeBytesCount THEN BEGIN
            IF AsciiBytesCount <= SMSSetup."SMS Length (1st) Unicode" THEN
                EXIT(1)
            ELSE
                EXIT(1 + ROUND(((AsciiBytesCount - SMSSetup."SMS Length (1st) Unicode") / SMSSetup."SMS Length (2nd & above) Unico"), 1, '>'));
        END ELSE BEGIN
            IF AsciiBytesCount <= SMSSetup."Agile SMS Length (1st)" THEN
                EXIT(1)
            ELSE
                EXIT(1 + ROUND(((AsciiBytesCount - SMSSetup."Agile SMS Length (1st)") / SMSSetup."Agile SMS Length (2nd & above)"), 1, '>'));
        END;
    end;

    [Scope('OnPrem')]
    procedure InsertSMSDetail(PassedSMSTemplate: Record "Transaction Specification"; DocumentNo: Code[20]; MobileNumber: Text; TextMessage: Text)
    var
        SMSTemplate: Record "Transaction Specification";
        SMSDetails: Record "Tax Jurisdiction";
        EntryNo: Integer;
        SMSWebService: Codeunit "SMS Web Service";
        MessageID: Text[250];
    begin
        SMSSetup.GET;

        SMSDetails.RESET;
        IF SMSDetails.FINDLAST THEN
            EntryNo := SMSDetails."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSDetails.INIT;
        SMSDetails."Entry No." := EntryNo;
        SMSDetails."Mobile Number" := MobileNumber;
        SMSDetails."Creation Date" := TODAY;
        SMSDetails."Message Type" := PassedSMSTemplate.Type;
        SMSDetails.Status := SMSDetails.Status::New;
        SMSDetails."Document No." := DocumentNo;
        //SMSDetails."Ageing Date" :=
        SMSDetails.Company := COMPANYNAME;
        SMSDetails."Message Text" := COPYSTR(TextMessage, 1, 250);
        IF SMSSetup."Enable Agile SMS Gateway" THEN
            SMSDetails."Message Length" := CalculateMessageLength(TextMessage);
        SMSDetails.INSERT;

        IF SendSMS(MobileNumber, TextMessage, MessageID, SMSDetails."Message Length") THEN BEGIN
            SMSDetails.MessageID := MessageID;
            SMSDetails.Status := SMSDetails.Status::Processed;
            SMSDetails.MODIFY(TRUE);
            MESSAGE('SMS Sent !!')
        END ELSE BEGIN
            SMSDetails.MessageID := MessageID;
            SMSDetails.Status := SMSDetails.Status::Failed;
            SMSDetails.MODIFY(TRUE);
            MESSAGE('Sending SMS Failed !!');
        END;
    end;

    [Scope('OnPrem')]
    procedure SendHolidaySMS()
    var
        ServiceMgtSetup: Record "Sales & Receivables Setup";
        SMSTemplate: Record "Transaction Specification";
        SMSMessage: Text;
        BillAmount: Decimal;
        SMSDetail: Record "Tax Jurisdiction";
        MessageSentAlready: Boolean;
        DMSMgt: Codeunit "IRD Engine";
        EngNepDate: Record "English-Nepali Date";
        Customer: Record Customer;
        Employee: Record Employee;
        SMSTemplate2: Record "Transaction Specification";
    begin
        EngNepDate.RESET;
        EngNepDate.SETRANGE("English Date", TODAY);
        EngNepDate.SETRANGE("Holiday Type", EngNepDate."Holiday Type"::Festival);
        IF NOT EngNepDate.FINDFIRST THEN
            EXIT;

        SMSTemplate.RESET;
        SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::Holiday);
        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::Holiday);
        IF NOT SMSTemplate.FINDFIRST THEN BEGIN
            SMSTemplate.RESET;
            SMSTemplate.INIT;
            SMSTemplate."Document Profile" := SMSTemplate."Document Profile"::Holiday;
            SMSTemplate.Type := SMSTemplate.Type::Holiday;
            SMSTemplate."Line No." := 10000;
            SMSTemplate."Message Text" := EngNepDate."SMS Greeting Text";
            SMSTemplate.INSERT;
        END;

        SMSDetail.RESET;
        SMSDetail.SETRANGE("Creation Date", EngNepDate."English Date");
        SMSDetail.SETRANGE("Message Type", SMSDetail."Message Type"::Holiday);
        SMSDetail.SETRANGE(Status, SMSDetail.Status::Processed);
        IF SMSDetail.FINDFIRST THEN
            MessageSentAlready := TRUE
        ELSE
            MessageSentAlready := FALSE;

        IF NOT MessageSentAlready THEN BEGIN
            SMSTemplate2.RESET;
            SMSTemplate2.SETRANGE("Document Profile", SMSTemplate2."Document Profile"::Holiday);
            SMSTemplate2.SETRANGE(Type, SMSTemplate2.Type::Holiday);
            IF SMSTemplate2.FINDFIRST THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE(Status, Employee.Status::Active);
                IF Employee.FINDFIRST THEN
                    REPEAT
                        InsertSMSDetail(SMSTemplate, '', Employee."Mobile Phone No.", EngNepDate."SMS Greeting Text");
                    UNTIL Employee.NEXT = 0;
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure SendInvoiceAgeingSMS()
    var
        SMSSetup: Record "Company Information";
        i: Integer;
        CustLedg: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        OldMaturityDate: Date;
        FirstSMSDate: Date;
        SecondSMSDate: Date;
        ThirdSMSDate: Date;
        SMSDetail: Record "Tax Jurisdiction";
        MessageSentAlready: Boolean;
        MaturityAmount: Decimal;
        FirstSMSAmount: Decimal;
        SecondSMSAmount: Decimal;
        ThirdSMSAmount: Decimal;
        SMSTemplate2: Record "Transaction Specification";
    begin
        SMSSetup.GET;

        //OldMaturityDate := CALCDATE('<=-'+FORMAT(SMSSetup."Maturity Day")+'D'+'>',TODAY);
        FirstSMSDate := CALCDATE('<=-' + FORMAT(SMSSetup."1st sms alert") + 'D' + '>', TODAY);
        SecondSMSDate := CALCDATE('<=-' + FORMAT(SMSSetup."2nd sms alert") + 'D' + '>', TODAY);
        ThirdSMSDate := CALCDATE('<=-' + FORMAT(SMSSetup."3rd sms alert") + 'D' + '>', TODAY);
        Customer.RESET;
        Customer.SETRANGE(Blocked, Customer.Blocked::" ");
        IF Customer.FINDFIRST THEN
            REPEAT
                GetCustomerAmount(Customer."No.", FirstSMSDate);
            /*IF CheckAgeingForSMS(OldMaturityDate,Customer."No.") = FALSE THEN BEGIN

              sendAgeSMS(Customer."SMS Sent Date",Customer."No.");
              END
              ELSE
              IF CheckAgeingForSMS(FirstSMSDate,Customer."No.") = FALSE THEN
                sendAgeSMS(Customer."SMS Sent Date",Customer."No.")
                ELSE
                IF CheckAgeingForSMS(SecondSMSDate,Customer."No.") = FALSE THEN
                   CheckAgeingForSMS(Customer."SMS Sent Date",Customer."No.")
                   ELSE
                  IF CheckAgeingForSMS(ThirdSMSDate,Customer."No.") = FALSE THEN
                     sendAgeSMS(Customer."SMS Sent Date",Customer."No.")
                  ELSE
                    EXIT;*/
            UNTIL Customer.NEXT = 0;

    end;

    local procedure CheckAgeingForSMS(ageDate: Date; CustNo: Code[20]): Boolean
    begin
        /*
        SMSDetails2.RESET;
        //SMSDetails2.SETRANGE("Ageing Date",ageDate);
        SMSDetails2.SETRANGE("Customer No.",CustNo);
        SMSDetails2.SETRANGE("Creation Date",TODAY);
        SMSDetails2.SETRANGE("Message Type",SMSDetails2."Message Type"::Ageing);
        SMSDetails2.SETRANGE(Status,SMSDetails2.Status::Processed);
        IF SMSDetails2.FINDFIRST THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
        */

    end;

    local procedure sendAgeSMS(ageDate: Date; custNo: Code[20]; amountTillFirstSMS: Decimal; smsSeqNo: Integer)
    var
        SMSDetail: Record "Tax Jurisdiction";
        MessageSentAlready: Boolean;
        SMSTemplate2: Record "Transaction Specification";
        Customer: Record Customer;
        CustLedg: Record "Cust. Ledger Entry";
        TotalMaturityAmount: Decimal;
        SMSNo: Text;
        ageDate2: Date;
    begin
        IF smsSeqNo = 0 THEN BEGIN
            SMSDetail.RESET;
            SMSDetail.SETRANGE("Creation Date", TODAY);
            SMSDetail.SETRANGE("Message Type", SMSDetail."Message Type"::Ageing);
            SMSDetail.SETRANGE(Status, SMSDetail.Status::Processed);
            IF SMSDetail.FINDFIRST THEN
                MessageSentAlready := TRUE
            ELSE
                MessageSentAlready := FALSE;
        END
        ELSE BEGIN
            SMSDetail.RESET;
            SMSDetail.SETRANGE("Creation Date", ageDate);
            SMSDetail.SETRANGE("Message Type", SMSDetail."Message Type"::Ageing);
            SMSDetail.SETRANGE(Status, SMSDetail.Status::Processed);
            IF SMSDetail.FINDFIRST THEN
                MessageSentAlready := TRUE
            ELSE
                MessageSentAlready := FALSE;
        END;
        IF NOT MessageSentAlready THEN BEGIN
            SMSTemplate2.RESET;
            SMSTemplate2.SETRANGE("Document Profile", SMSTemplate2."Document Profile"::Ageing);
            SMSTemplate2.SETRANGE(Type, SMSTemplate2.Type::Ageing);
            SMSTemplate2.SETRANGE("Message Sequence", smsSeqNo);
            IF SMSTemplate2.FINDFIRST THEN BEGIN
                TotalMaturityAmount := 0;
                newMessage := '';
                CustLedg.RESET;
                CustLedg.SETRANGE("Customer No.", custNo);
                IF smsSeqNo = 1 THEN
                    ageDate2 := ageDate - SMSSetup."1st sms alert"
                ELSE
                    IF smsSeqNo = 2 THEN
                        ageDate2 := ageDate - (SMSSetup."1st sms alert" + SMSSetup."2nd sms alert")
                    ELSE
                        IF smsSeqNo = 3 THEN
                            ageDate2 := ageDate - (SMSSetup."1st sms alert" + SMSSetup."2nd sms alert" + SMSSetup."3rd sms alert");

                CustLedg.SETFILTER("Posting Date", '%1..%2', ageDate2, TODAY);
                CustLedg.SETRANGE("Document Type", CustLedg."Document Type"::Invoice);
                CustLedg.SETFILTER("Remaining Amount", '<>%1', 0);
                IF CustLedg.FINDFIRST THEN
                    REPEAT
                        CustLedg.CALCFIELDS("Remaining Amount");
                        TotalMaturityAmount += CustLedg."Remaining Amount";
                    UNTIL CustLedg.NEXT = 0;

                newMessage := STRSUBSTNO(SMSTemplate2."Message Text", amountTillFirstSMS, TotalMaturityAmount);
                /* Customer.RESET;
                 Customer.SETRANGE("No.",custNo);
                 IF Customer.FINDFIRST THEN
                   SMSNo := Customer."SMS Mobile No";
                 IF SMSNo <> '' THEN*/
                InsertSMSDetailForAgeing(SMSTemplate2, custNo, '9860761310', newMessage, ageDate, smsSeqNo)
                //ELSE
                //EXIT;
            END;
        END;

    end;

    [Scope('OnPrem')]
    procedure InsertSMSDetailForAgeing(PassedSMSTemplate: Record "Transaction Specification"; CustNo: Code[20]; MobileNumber: Text; TextMessage: Text; ageDate: Date; msgSeq: Integer)
    var
        SMSTemplate: Record "Transaction Specification";
        SMSDetails: Record "Tax Jurisdiction";
        EntryNo: Integer;
        SMSWebService: Codeunit "SMS Web Service";
        MessageID: Text[250];
    begin
        SMSSetup.GET;

        SMSDetails.RESET;
        IF SMSDetails.FINDLAST THEN
            EntryNo := SMSDetails."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSDetails.INIT;
        SMSDetails."Entry No." := EntryNo;
        SMSDetails."Mobile Number" := MobileNumber;
        IF msgSeq = 0 THEN
            SMSDetails."Creation Date" := TODAY
        ELSE
            SMSDetails."Creation Date" := ageDate;
        SMSDetails."Message Type" := PassedSMSTemplate.Type;
        SMSDetails.Status := SMSDetails.Status::New;
        SMSDetails."Customer No." := CustNo;
        IF msgSeq = 1 THEN
            SMSDetails."Ageing Date" := ageDate - SMSSetup."1st sms alert"
        ELSE
            IF msgSeq = 2 THEN
                SMSDetails."Ageing Date" := ageDate - (SMSSetup."1st sms alert" + SMSSetup."2nd sms alert")
            ELSE
                IF msgSeq = 3 THEN
                    SMSDetails."Ageing Date" := ageDate - (SMSSetup."1st sms alert" + SMSSetup."2nd sms alert" + SMSSetup."3rd sms alert");
        SMSDetails.Company := COMPANYNAME;
        SMSDetails."Message Text" := COPYSTR(TextMessage, 1, 250);
        IF SMSSetup."Enable Agile SMS Gateway" THEN
            SMSDetails."Message Length" := CalculateMessageLength(TextMessage);
        SMSDetails.INSERT;

        IF SendSMS(MobileNumber, TextMessage, MessageID, SMSDetails."Message Length") THEN BEGIN
            SMSDetails.MessageID := MessageID;
            SMSDetails.Status := SMSDetails.Status::Processed;
            SMSDetails.MODIFY(TRUE);
            MESSAGE('SMS Sent !!')
        END ELSE BEGIN
            SMSDetails.MessageID := MessageID;
            SMSDetails.Status := SMSDetails.Status::Failed;
            SMSDetails.MODIFY(TRUE);
            MESSAGE('Sending SMS Failed !!');
        END;
    end;

    local procedure GetCustomerAmount(CustNo: Code[20]; ageDate: Date)
    var
        Customer: Record Customer;
        CustLedg: Record "Cust. Ledger Entry";
        MaturityAmount: Decimal;
        SMSSetup: Record "Company Information";
        Customer2: Record Customer;
    begin
        SMSSetup.GET;
        MaturityAmount := 0;
        Customer.RESET;
        Customer.SETRANGE("No.", CustNo);
        Customer.SETRANGE("SMS Log No.", 3);
        IF Customer.FINDFIRST THEN BEGIN
            CustLedg.RESET;
            CustLedg.SETRANGE("Customer No.", CustNo);
            CustLedg.SETFILTER("Posting Date", '%1..%2', Customer."SMS Sent Date", Customer."SMS Sent Date" + SMSSetup."1st sms alert" + SMSSetup."2nd sms alert");
            CustLedg.SETRANGE("Document Type", CustLedg."Document Type"::Invoice);
            CustLedg.SETFILTER("Remaining Amount", '<>%1', 0);
            IF CustLedg.FINDFIRST THEN
                REPEAT
                    CustLedg.CALCFIELDS("Remaining Amount");
                    MaturityAmount += CustLedg."Remaining Amount";
                UNTIL CustLedg.NEXT = 0;
            //Compare the maturity amount with thresold setup here. if thresold matched is less than maturity amount then set SMS log No. to 0.
            //Customer."SMS Log No." := 0;
            IF MaturityAmount >= SMSSetup."SMS Thresold Amount" THEN BEGIN
                // Customer.Blocked := Customer.Blocked::Invoice;
                //Customer.MODIFY;
            END
            ELSE BEGIN
                Customer."SMS Log No." := 0;
                Customer.MODIFY;
            END;
            MaturityAmount := 0;
            Customer2.RESET;
            Customer2.SETRANGE("No.", CustNo);
            Customer2.SETFILTER("SMS Log No.", '<>%1', 3);
            IF Customer2.FINDFIRST THEN
                IF Customer2."SMS Log No." = 0 THEN BEGIN
                    CustLedg.RESET;
                    CustLedg.SETRANGE("Customer No.", CustNo);
                    CustLedg.SETFILTER("Posting Date", '%1..%2', ageDate, TODAY);
                    CustLedg.SETRANGE("Document Type", CustLedg."Document Type"::Invoice);
                    CustLedg.SETFILTER("Remaining Amount", '<>%1', 0);
                    IF CustLedg.FINDFIRST THEN
                        REPEAT
                            CustLedg.CALCFIELDS("Remaining Amount");
                            MaturityAmount += CustLedg."Remaining Amount";
                        UNTIL CustLedg.NEXT = 0;
                    IF MaturityAmount >= SMSSetup."SMS Thresold Amount" THEN BEGIN
                        //Compare the maturity amount with thresold setup here. if thresold matched then send sms first sms and Set SMS log No to 1
                        sendAgeSMS(ageDate, CustNo, MaturityAmount, 1);
                        Customer2."SMS Log No." := 1;
                        Customer2."SMS Sent Date" := ageDate;
                        Customer2.MODIFY;
                    END
                    ELSE
                        EXIT;
                END
                ELSE
                    IF Customer2."SMS Log No." = 1 THEN BEGIN
                        CustLedg.RESET;
                        CustLedg.SETRANGE("Customer No.", CustNo);
                        CustLedg.SETFILTER("Posting Date", '%1..%2', Customer2."SMS Sent Date", Customer2."SMS Sent Date" + SMSSetup."1st sms alert");
                        CustLedg.SETRANGE("Document Type", CustLedg."Document Type"::Invoice);
                        CustLedg.SETFILTER("Remaining Amount", '<>%1', 0);
                        IF CustLedg.FINDFIRST THEN
                            REPEAT
                                CustLedg.CALCFIELDS("Remaining Amount");
                                MaturityAmount += CustLedg."Remaining Amount";
                            UNTIL CustLedg.NEXT = 0;
                        IF MaturityAmount >= SMSSetup."SMS Thresold Amount" THEN BEGIN
                            //Compare the maturity amount with thresold setup here. if thresold matched then send second sms else do not send SMS and set the SMS log no to 0
                            sendAgeSMS(Customer2."SMS Sent Date" + (SMSSetup."1st sms alert" + SMSSetup."2nd sms alert"), CustNo, MaturityAmount, 2);
                            Customer2."SMS Log No." := 2;
                            Customer2.MODIFY;
                        END ELSE BEGIN
                            Customer2."SMS Log No." := 0;
                            Customer2.MODIFY;
                        END;
                    END
                    ELSE
                        IF Customer2."SMS Log No." = 2 THEN BEGIN
                            CustLedg.RESET;
                            CustLedg.SETRANGE("Customer No.", CustNo);
                            CustLedg.SETFILTER("Posting Date", '%1..%2', Customer2."SMS Sent Date", Customer2."SMS Sent Date" + SMSSetup."1st sms alert");
                            CustLedg.SETRANGE("Document Type", CustLedg."Document Type"::Invoice);
                            CustLedg.SETFILTER("Remaining Amount", '<>%1', 0);
                            IF CustLedg.FINDFIRST THEN
                                REPEAT
                                    CustLedg.CALCFIELDS("Remaining Amount");
                                    MaturityAmount += CustLedg."Remaining Amount";
                                UNTIL CustLedg.NEXT = 0;
                            IF MaturityAmount >= SMSSetup."SMS Thresold Amount" THEN BEGIN
                                //Compare the maturity amount with thresold setup here. if thresold matched then send third sms else do not send SMS set the SMS log no to 0
                                sendAgeSMS(Customer2."SMS Sent Date" + (SMSSetup."1st sms alert" + SMSSetup."2nd sms alert" + SMSSetup."3rd sms alert"), CustNo, MaturityAmount, 3);
                                Customer2."SMS Log No." := 3;
                                Customer2.MODIFY;
                            END ELSE BEGIN
                                Customer2."SMS Log No." := 0;
                                Customer2.MODIFY;
                            END;
                        END;


        END;
    end;
}

