page 50503 "View Records"
{
    Editable = false;
    PageType = List;
    SourceTable = Object;
    SourceTableView = WHERE(Type = CONST(Table));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Modified; Rec.Modified)
                {
                    ApplicationArea = all;
                }
                field(Compiled; Rec.Compiled)
                {
                    ApplicationArea = all;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = all;
                }
                field("Version List"; Rec."Version List")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Run")
            {
                Image = "Table";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    HYPERLINK(GETURL(CLIENTTYPE::Current, COMPANYNAME, OBJECTTYPE::Table, Rec.ID));
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        User.RESET;
        User.SETRANGE("User Name", USERID);
        User.FINDFIRST;
        IF NOT AccessControl.GET(User."User Security ID", 'SUPER') THEN
            IF NOT AccessControl.GET(User."User Security ID", 'VIEWRECORDS') THEN     //ZM June 13, 2017
                ERROR('');
    end;

    var
        AccessControl: Record "Access Control";
        User: Record User;
}

