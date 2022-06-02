table 50008 "TDS Posting Group"
{
    DrillDownPageID = "TDS Posting Group";
    LookupPageID = "TDS Posting Group";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "TDS%"; Decimal)
        {
        }
        field(3; "GL Account No."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; Type; Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(5; "Effective From"; Date)
        {
        }
        field(6; Blocked; Boolean)
        {
        }
        field(7; Description; Text[100])
        {
        }
        field(8; "G/L Account Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("GL Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;

        }
        field(9; "Tax Revenue Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "GL Account No.", "G/L Account Name")
        {
        }
        fieldgroup(Brick; "Code", "TDS%", "GL Account No.", "G/L Account Name", Description)
        {
        }
    }

    [Scope('Internal')]
    procedure FindTDSGroup(TDSGroup: Code[20]; EffectiveDate: Date): Boolean
    var
        tds: Record "TDS Posting Group";
    begin
        RESET;
        SETRANGE(Code, TDSGroup);
        SETRANGE(Blocked, FALSE);
        //SETFILTER("Effective From",'<%1',EffectiveDate);
        EXIT(FINDLAST);
    end;
}

