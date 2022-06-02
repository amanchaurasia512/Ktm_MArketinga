page 50015 "Product Segments Concerns"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Tax Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Concerned Emails"; Rec."Concerned Emails")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Product Segment Code"; Rec."Product Segment Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ProductSegmentConcerns.RESET;
        ProductSegmentConcerns.SETRANGE("Product Segment Code", Rec."Product Segment Code");
        ProductSegmentConcerns.SETRANGE("Report ID", Rec."Report ID");
        IF ProductSegmentConcerns.FINDLAST THEN
            Rec."Line No." := ProductSegmentConcerns."Line No." + 1000
        ELSE
            Rec."Line No." := 1000;
    end;

    var
        ProductSegmentConcerns: Record "Tax Detail";
}

