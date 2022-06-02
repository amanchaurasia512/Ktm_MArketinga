page 50018 "SMS Details"
{
    SourceTable = "Tax Jurisdiction";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Mobile Number"; Rec."Mobile Number")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Message Type"; Rec."Message Type")
                {
                    ApplicationArea = all;
                }
                field("Message Text"; Rec."Message Text")
                {
                    ApplicationArea = all;
                }
                field("Message Length"; Rec."Message Length")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(MessageID; Rec.MessageID)
                {
                    ApplicationArea = all;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
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

