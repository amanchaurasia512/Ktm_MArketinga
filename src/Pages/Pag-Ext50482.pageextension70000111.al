pageextension 50482 "pageextension70000111" extends "Base Calendar Entries Subform"
{
    layout
    {
        addafter(Description)
        {
            field(HolidayType; HolidayType)
            {

                trigger OnValidate()
                begin
                    UpdateBaseCalendarChanges_ktm;
                end;
            }
            field("SMS Greeting Text"; SMSGreetinText)
            {

                trigger OnValidate()
                begin
                    UpdateBaseCalendarChanges_ktm;
                end;
            }
        }
    }


    //Unsupported feature: Property Modification (Id) on "BaseCalendarChange(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //BaseCalendarChange : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BaseCalendarChange : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PeriodFormMgt(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //PeriodFormMgt : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PeriodFormMgt : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CalendarMgmt(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //CalendarMgmt : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CalendarMgmt : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PeriodType(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //PeriodType : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PeriodType : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Nonworking(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //Nonworking : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Nonworking : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "WeekNo(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //WeekNo : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //WeekNo : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Description(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //Description : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Description : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CurrentCalendarCode(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //CurrentCalendarCode : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CurrentCalendarCode : 1997;
    //Variable type has not been exported.

    var
        ItemPeriodLength: Option Day,Week,Month,Quarter,Year,Period;

    var
        HolidayType: Option " ",Weekend," Public",Festival;
        SMSGreetinText: Text;

    procedure UpdateBaseCalendarChanges_ktm()
    var
        BaseCalendarChange: Record "Base Calendar Change";
    begin
        BaseCalendarChange.Reset();
        BaseCalendarChange.SetRange("Base Calendar Code", Rec."Base Calendar Code");
        BaseCalendarChange.SetRange(Date, Rec.Date);
        if BaseCalendarChange.FindFirst then
            BaseCalendarChange.Delete();
        BaseCalendarChange.Init();
        BaseCalendarChange."Base Calendar Code" := Rec."Base Calendar Code";
        BaseCalendarChange.Date := Rec.Date;
        BaseCalendarChange.Description := Rec.Description;
        BaseCalendarChange.Nonworking := Rec.Nonworking;
        BaseCalendarChange.Day := Rec.Day;
        BaseCalendarChange."Holiday Type" := HolidayType;           //modified code
        BaseCalendarChange."SMS Greeting Text" := SMSGreetinText;    //modified code
        //OnUpdateBaseCalendarChanges(BaseCalendarChange);
        BaseCalendarChange.Insert();
    end;
    //Unsupported feature: Code Modification on "UpdateBaseCalendarChanges(PROCEDURE 2)".

    //procedure UpdateBaseCalendarChanges();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    BaseCalendarChange.RESET;
    BaseCalendarChange.SETRANGE("Base Calendar Code",CurrentCalendarCode);
    BaseCalendarChange.SETRANGE(Date,"Period Start");
    #4..8
    BaseCalendarChange.Description := Description;
    BaseCalendarChange.Nonworking := Nonworking;
    BaseCalendarChange.Day := "Period No.";
    BaseCalendarChange.INSERT;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    BaseCalendarChange."Holiday Type" := HolidayType;
    BaseCalendarChange."SMS Greeting Text" := SMSGreetinText;
    BaseCalendarChange.INSERT;
    */
    //end;
}

