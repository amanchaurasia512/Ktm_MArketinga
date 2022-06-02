tableextension 50491 "Company Information_ktm" extends "Company Information"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Phone No."(Field 7)".

        field(50000; "CBMS Username"; Text[30])
        {
        }
        field(50001; "CBMS Password"; Text[30])
        {
        }
        field(50002; "CBMS Base URL"; Text[100])
        {
        }
        field(50003; "Enable CBMS Realtime Sync"; Boolean)
        {
        }
        field(50004; Picture2; BLOB)
        {
        }
        field(50005; Picture3; BLOB)
        {
        }
        field(50006; "User Name"; Text[250])
        {
            Description = 'SMS Setup';
        }
        field(50007; "Password Key"; Guid)
        {
            Description = 'SMS Setup';
        }
        field(50008; Token; Text[250])
        {
            Description = 'SMS Setup';
        }
        field(50009; Identity; Text[250])
        {
            Description = 'SMS Setup';
        }
        field(50010; "SMS Text Length"; Integer)
        {
            Description = 'SMS Setup';
        }
        field(50011; "Base URL"; Text[250])
        {
            Description = 'SMS Setup';
        }
        field(50012; Method; Text[30])
        {
            Description = 'SMS Setup';
        }
        field(50013; RESTMethod; Option)
        {
            Description = 'SMS Setup';
            OptionCaption = 'GET,POST,PUT,DELETE';
            OptionMembers = GET,POST,PUT,DELETE;
        }
        field(50014; Keywords; Integer)
        {
            Description = 'SMS Setup (For cut off first 6 digit of mesage)';
        }
        field(50015; "Enable Agile SMS Gateway"; Boolean)
        {
            Description = 'SMS Setup';
        }
        field(50016; "Agile User Name"; Text[50])
        {
            Description = 'SMS Setup';
        }
        field(50017; "Agile Password Key"; Text[100])
        {
            Description = 'SMS Setup';
            ExtendedDatatype = Masked;
        }
        field(50018; "Agile Base URL"; Text[250])
        {
            Description = 'SMS Setup';
        }
        field(50019; "Agile Method"; Text[30])
        {
            Description = 'SMS Setup';
        }
        field(50020; "Agile RESTMethod"; Option)
        {
            Description = 'SMS Setup';
            OptionCaption = 'GET,POST,PUT,DELETE';
            OptionMembers = GET,POST,PUT,DELETE;
        }
        field(50021; "Agile SMS Length (1st)"; Integer)
        {
            Description = 'SMS Setup (For non-unicode)';
        }
        field(50022; "Agile SMS Length (2nd & above)"; Integer)
        {
            Description = 'SMS Setup (For non-unicode)';
        }
        field(50023; "SMS Length (1st) Unicode"; Integer)
        {
            Description = 'SMS Setup (For non-unicode)';
        }
        field(50024; "SMS Length (2nd & above) Unico"; Integer)
        {
            Description = 'SMS Setup (For non-unicode)';
        }
        field(50025; "Agile Client Code"; Code[20])
        {
            Description = 'SMS Setup';
        }
        field(50026; "Maturity Day"; Integer)
        {
            Description = 'SMS Setup';
        }
        field(50027; "1st sms alert"; Integer)
        {
            Description = 'SMS Setup';
        }
        field(50028; "2nd sms alert"; Integer)
        {
            Description = 'SMS Setup';
        }
        field(50029; "3rd sms alert"; Integer)
        {
            Description = 'SMS Setup';
        }
        field(50030; "SMS Thresold Amount"; Decimal)
        {
        }
    }

    procedure GetDevBetaModeTxt(): Text[250]
    begin
        //EXIT(DevBetaModeTxt);
    end;

    local procedure "--------------"()
    begin
    end;

    //     procedure SetPassword(PasswordText: Text)
    //     var
    //         ServicePassword: Record "Service Password";
    //     begin
    //         IF ISNULLGUID("Password Key") OR NOT ServicePassword.GET("Password Key") THEN BEGIN
    //             ServicePassword.SavePassword(PasswordText);
    //             ServicePassword.INSERT(TRUE);
    //             "Password Key" := ServicePassword.Key;
    //         END ELSE BEGIN
    //             ServicePassword.SavePassword(PasswordText);
    //             ServicePassword.MODIFY;
    //         END;
    //     end;

    //     procedure GetPassword(): Text
    //     var
    //         ServicePassword: Record "Service Password";
    //     begin
    //         IF NOT ISNULLGUID("Password Key") THEN
    //             IF ServicePassword.GET("Password Key") THEN
    //                 EXIT(ServicePassword.GetPassword());
    //     end;
    // 
}
