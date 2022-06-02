page 50017 "SMS Setup"
{
    PageType = Card;
    SourceTable = "Company Information";

    layout
    {
        area(content)
        {
            group("SMS Configure")
            {
                field("Enable Agile SMS Gateway"; Rec."Enable Agile SMS Gateway")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        IF Rec."Enable Agile SMS Gateway" = FALSE THEN
                            showSparrowSMS := TRUE
                        ELSE
                            showSparrowSMS := FALSE;
                        CurrPage.UPDATE;
                    end;
                }
            }
            group("Sparrow SMS")
            {
                Visible = showSparrowSMS;
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = all;
                }
                field(PasswordTemp; PasswordTemp)
                {
                    ApplicationArea = all;
                    Caption = 'Password';

                    trigger OnValidate()
                    begin
                        //SetPassword(PasswordTemp);
                        COMMIT;
                        CurrPage.UPDATE;
                    end;
                }
                field(Token; Rec.Token)
                {
                    ApplicationArea = all;
                }
                field(Identity; Rec.Identity)
                {
                    ApplicationArea = all;
                }
                field("SMS Text Length"; Rec."SMS Text Length")
                {
                    ApplicationArea = all;
                }
                field("Base URL"; Rec."Base URL")
                {
                    ApplicationArea = all;
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = all;
                }
                field(RESTMethod; Rec.RESTMethod)
                {
                    ApplicationArea = all;
                }
                field(Keywords; Rec.Keywords)
                {
                    ApplicationArea = all;
                }
            }
            group("Agile SMS")
            {
                field("Agile Base URL"; Rec."Agile Base URL")
                {
                    Caption = 'Base URL';
                }
                field("Agile User Name"; Rec."Agile User Name")
                {
                    Caption = 'User Name';
                }
                field("Agile Password Key"; Rec."Agile Password Key")
                {
                    Caption = 'Password';
                }
                field("Agile Client Code"; Rec."Agile Client Code")
                {
                    Caption = 'Identity';
                }
                field("Agile Method"; Rec."Agile Method")
                {
                    Caption = 'Method';
                }
                field("Agile RESTMethod"; Rec."Agile RESTMethod")
                {
                    Caption = 'Rest Method';
                }
                group(Unicode)
                {
                    Caption = 'Unicode';
                    field("SMS Length (1st) Unicode"; Rec."SMS Length (1st) Unicode")
                    {
                        Caption = 'SMS Length (1st)';
                    }
                    field("SMS Length (2nd & above) Unico"; Rec."SMS Length (2nd & above) Unico")
                    {
                        Caption = 'SMS Length (2nd & above)';
                    }
                }
                group("Non-unicode")
                {
                    Caption = 'Non-unicode';
                    field("Agile SMS Length (1st)"; Rec."Agile SMS Length (1st)")
                    {
                        Caption = 'SMS Length (1st)';
                    }
                    field("Agile SMS Length (2nd & above)"; Rec."Agile SMS Length (2nd & above)")
                    {
                        Caption = 'SMS Length (2nd & above)';
                    }
                }
                group("SMS Test")
                {
                    Caption = 'SMS Test';
                    field("Test Message"; TestMsg)
                    {
                    }
                    field("Test Mobile No."; TestMblNo)
                    {
                    }
                }
                group("SMS For Ageing")
                {
                    field("1st sms alert"; Rec."1st sms alert")
                    {
                    }
                    field("2nd sms alert"; Rec."2nd sms alert")
                    {
                    }
                    field("3rd sms alert"; Rec."3rd sms alert")
                    {
                    }
                    field("SMS Thresold Amount"; Rec."SMS Thresold Amount")
                    {
                    }
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Send Test SMS")
            {
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF TestMblNo = '' THEN
                        ERROR('Test Mobile No. is empty.');
                    SMSWebService.PopUpForTestSMS(TestMsg, TestMblNo);
                    //SMSWebService.SendHolidaySMS;
                end;
            }
            action(SendAgeingSMS)
            {

                trigger OnAction()
                begin
                    SMSWebService.SendInvoiceAgeingSMS;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PasswordTemp := '';
        IF (Rec."User Name" <> '') AND (NOT ISNULLGUID(Rec."Password Key")) THEN
            PasswordTemp := '**********';
    end;

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;

    var
        PasswordTemp: Text;
        TestMsg: Text;
        TestMblNo: Text;
        SMSWebService: Codeunit "SMS Web Service";
        showSparrowSMS: Boolean;
}

