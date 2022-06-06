pageextension 50515 "Posted sales Cr Memos Ext" extends "Posted Sales Credit Memos"
{


    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            //this filed are already defined
            // field("Posting Date"; "Posting Date")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Location Code")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(ActivityLog)
        {
            action("old Print")
            {
                CaptionML = ENU = 'Old Print';
                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeader.RESET;//aakrista 3/23/2022
                    SalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN
                        REPORT.RUN(50099, TRUE, TRUE, SalesCrMemoHeader);
                end;

            }
        }
    }

    var
        myInt: Integer;
}