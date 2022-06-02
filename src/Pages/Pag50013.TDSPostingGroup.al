page 50013 "TDS Posting Group"
{
    SourceTable = "TDS Posting Group";

    layout
    {

        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("TDS%"; Rec."TDS%")
                {
                    ApplicationArea = all;
                }
                field("GL Account No."; Rec."GL Account No.")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        Rec.CALCFIELDS("G/L Account Name");
                    end;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Effective From"; Rec."Effective From")
                {
                    ApplicationArea = all;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = all;
                }
                field("Tax Revenue Code"; Rec."Tax Revenue Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

