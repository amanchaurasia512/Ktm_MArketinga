page 50011 "Product Segment wise Report"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Tax Area Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Segment Code"; Rec."Product Segment Code")
                {
                    ApplicationArea = all;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Report Name"; Rec."Report Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Concerned Persons")
            {
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Product Segments Concerns";
                RunPageLink = "Product Segment Code" = FIELD("Product Segment Code"),
                           "Report ID" = FIELD("Report ID");
            }
            action("Send Email")
            {
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    IRDMgt: Codeunit "IRD Mgt.";
                begin
                    IF NOT CONFIRM('Do you want to send emails?', FALSE) THEN
                        EXIT;
                    IRDMgt.SendProductWiseReportMailToConcernedPersons;
                end;
            }
        }
    }
}

