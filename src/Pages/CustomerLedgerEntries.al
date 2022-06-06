pageextension 50519 "Customer Ledger Entries" extends "Customer Ledger Entries"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        modify("Salesperson Code")
        {
            Visible = false;
            Editable = false;
        }
        modify(Description)
        {
            Editable = false;
        }
        addafter("Salesperson Code")
        { //already defined in base
            // field("Message to Recipient"; "Message to Recipient")
            // {
            //     ApplicationArea = All;
            // }
            // field(Description; Description)
            // {                        
            //     ApplicationArea = All;
            // }
            // field("IC Partner Code"; "IC Partner Code")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter(Amount)
        {   //already define in base
            // field("Debit Amount"; "Debit Amount")
            // {
            //     ApplicationArea = All;
            // }
            // field("Credit Amount"; "Credit Amount")
            // {
            //     ApplicationArea = All;
            // }

        }
        addafter("Amount (LCY)")
        {  //already defined in base
            // field("Sales (LCY)"; "Sales (LCY)")
            // {
            //     ApplicationArea = All;
            // }

        }
        addafter("Remaining Amt. (LCY)")
        {
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        addafter(ReverseTransaction)
        {
            action("[Credit Note]")
            {
                CaptionML = ENU = 'Credit Note';
                Promoted = false;
                Image = ValueLedger;
                ApplicationArea = all;
                trigger OnAction()
                var
                    GlEntry: Record "G/L Entry";
                begin
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Document No.");
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUN(50024, TRUE, FALSE, GLEntry);
                end;
            }
            action("Debit Note")
            {
                CaptionML = ENU = 'Debit Note';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Image = ValueLedger;
                ApplicationArea = all;
                trigger OnAction()
                var
                    GlEntry: Record "G/L Entry";
                begin
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Document No.");
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUN(50025, TRUE, FALSE, GLEntry);
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}