page 50008 "Bank Receipt Journal"
{
    Caption = 'Bank Receipts';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Gen. Journal Batch";
    SourceTableView = WHERE("Journal Template Name" = CONST('CASH RECEI'));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Name"; Rec."Name")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = all;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
                field("Copy VAT Setup to Jnl. Lines"; Rec."Copy VAT Setup to Jnl. Lines")
                {
                    ApplicationArea = all;
                }
                field("Allow VAT Difference"; Rec."Allow VAT Difference")
                {
                    ApplicationArea = all;
                }
                field("Allow Payment Export"; Rec."Allow Payment Export")
                {
                    ApplicationArea = all;
                }
                field("Bank Statement Import Format"; Rec."Bank Statement Import Format")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Link; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditJournal)
            {
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ApplicationArea = all;

                trigger OnAction()
                begin
                    GenJnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    begin
                        GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", Rec.Name);
                        GLReconcile.SetGenJnlLine(GenJnlLine);
                        GLReconcile.RUN;
                    end;
                }
                action(TestReport)
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ApplicationArea = all;
                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-B.Post";
                    ShortCutKey = 'F9';
                    ApplicationArea = all;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ApplicationArea = all;
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("Recurring General Journal")
                {
                    Caption = 'Recurring General Journal';
                    Image = Journal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Recurring General Journal";
                    ApplicationArea = all;
                }
                action("Close Income Statement")
                {
                    Caption = 'Close Income Statement';
                    Image = CloseYear;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Close Income Statement";
                    ApplicationArea = all;
                }
                action("G/L Register_ktm")
                {
                    Caption = 'G/L Register';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Registers";
                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Detail Trial Balance";
                ApplicationArea = all;
            }
            action("Trial Balance")
            {
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance";
                ApplicationArea = all;
            }
            action("Trial Balance by Period")
            {
                Caption = 'Trial Balance by Period';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period";
                ApplicationArea = all;
            }
            action("G/L Register")
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "G/L Register";
                ApplicationArea = all;
            }
            action(MarkedOnOff)
            {
                Caption = 'Marked On/Off';
                Image = Change;
                ToolTip = 'Shows all journal batches or only marked journal batches. A journal batch is marked if an attempt to post the general journal fails.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.MARKEDONLY(NOT Rec.MARKEDONLY);
                    CurrPage.UPDATE(FALSE);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewBatch;
    end;

    trigger OnOpenPage()
    begin
        GenJnlManagement.OpenJnlBatch(Rec);
        Rec.SETFILTER(Name, '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10',
                  'BOK', 'EBL', 'GIME', 'HBL', 'KBL', 'NIBL', 'RBB', 'SBI', 'SBL', 'EVT');
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        GenJnlManagement: Codeunit GenJnlManagement;
        GenJnlLine: Record "Gen. Journal Line";
        GLReconcile: Page "Reconciliation";

    local procedure DataCaption(): Text[250]
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        IF NOT CurrPage.LOOKUPMODE THEN
            IF Rec.GETFILTER("Journal Template Name") <> '' THEN
                IF Rec.GETRANGEMIN("Journal Template Name") = Rec.GETRANGEMAX("Journal Template Name") THEN
                    IF GenJnlTemplate.GET(Rec.GETRANGEMIN("Journal Template Name")) THEN
                        EXIT(GenJnlTemplate.Name + ' ' + GenJnlTemplate.Description);
    end;
}

