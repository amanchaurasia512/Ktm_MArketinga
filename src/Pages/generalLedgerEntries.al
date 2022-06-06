pageextension 50518 "Gen Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Posting Date")
        {
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {   //already defined by base application 
            // field("External Document No."; "External Document No.")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter(Amount)
        {  //already defined by base application
            // field("Debit Amount"; "Debit Amount")
            // {
            //     ApplicationArea = All;
            // }
            // field("Credit Amount"; "Credit Amount")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("VAT Amount")
        {  //already defined by base application
            // field("Source Type"; "Source Type")
            // {
            //     ApplicationArea = All;
            // }
            // field("Source No."; "Source No.")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Entry No.")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = All;
            }
            field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
            {
                ApplicationArea = All;
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = All;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = All;
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = All;
            }
            field("Party Name"; Rec."Party Name")
            {
                ApplicationArea = All;
            }
            field(Loan; Rec.Loan)
            {
                ApplicationArea = All;
            }
            field(Margin; Rec.Margin)
            {
                ApplicationArea = All;
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ApplicationArea = All;
            }
            field("Employee Code"; Rec."Employee Code")
            {
                ApplicationArea = All;
            }
            field("TDS Group"; Rec."TDS Group")
            {
                ApplicationArea = All;
            }
            field("TDS%"; Rec."TDS%")
            {
                ApplicationArea = All;
            }
            field("TDS Type"; Rec."TDS Type")
            {
                ApplicationArea = All;
            }
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Entry No."; Rec."TDS Entry No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
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
                    GLEntry: Record "G/L Entry";
                begin
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
                Image = ValueLedger;
                Promoted = true;
                PromotedCategory = New;
                ApplicationArea = all;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
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
        addafter(IncomingDocAttachFile)
        {
            action("Print_V_NP15.1001")
            {
                CaptionML = ENU = 'Prinlt_V_NP15.1001';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = ValueLedger;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Document No.");
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUN(50011, TRUE, FALSE, GLEntry);
                end;
            }

        }
        addafter(DocsWithoutIC)
        {
            action("Change LC & TR")
            {
                RunObject = page "Update TR and LC";
                RunPageLink = "Entry No." = field("Entry No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = UpdateDescription; //update //update was not found
                PromotedCategory = Process;
                ApplicationArea = all;
            }
            action("Update Gl Account")
            {
                Promoted = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    TempCodeUnit: Codeunit "TempCode SRT";
                begin
                    //SRT Sept 9th 2019 >>
                    IF NOT CONFIRM('Do you want to update G/L Account No. based on temp update table.?', FALSE) THEN
                        EXIT;
                    TempCodeunit.UpdateGLEntryGLAccNo;
                    //SRT Sept 9th 2019 <<
                end;
            }
        }
    }


    var
        myInt: Integer;
}