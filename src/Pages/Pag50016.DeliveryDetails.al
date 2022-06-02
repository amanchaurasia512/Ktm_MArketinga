page 50016 "Delivery Details"
{
    PageType = List;
    SourceTable = "Tax Area";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Transport No."; Rec."Transport No.")
                {
                    ApplicationArea = all;
                    Editable = NOT Rec.Posted;
                }
                field("Transport Name"; Rec."Transport Name")
                {
                    ApplicationArea = all;
                    Editable = NOT Rec.Posted;
                }
                field("Bilty No."; Rec."Bilty No.")
                {
                    ApplicationArea = all;
                    Editable = NOT Rec.Posted;
                }
                field("Booking Date"; Rec."Booking Date")
                {
                    ApplicationArea = all;
                    Editable = NOT Rec.Posted;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(SendDeliveryMail)
            {
                Caption = 'Post';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to send delivery mail to customer?', FALSE) THEN
                        EXIT;
                    //IRDMgt.SendBillDeliveryMail(Rec);
                end;
            }
        }
    }

    var
        IRDMgt: Codeunit "IRD Mgt.";
}

