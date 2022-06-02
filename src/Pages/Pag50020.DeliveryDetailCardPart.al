page 50020 "Delivery Detail CardPart"
{
    PageType = CardPart;
    SourceTable = "Tax Area";

    layout
    {
        area(content)
        {
            field("Transport Name"; Rec."Transport Name")
            {
                ApplicationArea = all;
            }
            field("Bilty No."; Rec."Bilty No.")
            {
                ApplicationArea = all;
            }
            field("Booking Date"; Rec."Booking Date")
            {
                ApplicationArea = all;
            }
            field("Mail Sent"; Rec."Mail Sent")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
    }
}

