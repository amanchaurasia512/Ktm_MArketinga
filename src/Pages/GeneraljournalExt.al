pageextension 50527 "General journal Ext" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Document Type")
        {
            Visible = false;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.NotAllowTDSAccountSelectInJournalLines; //TDS1.00
            end;
        }
        modify("Bal. Account Type")
        {
            Visible = false;
        }
        modify("Bal. Account No.")
        {
            Visible = false;
            trigger OnAfterValidate()
            begin
                Rec.NotAllowTDSAccountSelectInJournalLines; //TDS1.00
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify(Quantity)
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        addbefore("Posting Date")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
            }

        }
        addafter("Document No.")
        {   //already there
            // field("External Document No.";"External Document No.")
            // {
            //     ApplicationArea = All;
            // }

        }
        addafter("Currency Code")
        {

            field(Narration; Rec.Narration)
            {
                ToolTip = 'Specifies the value of the Narration field.';
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ToolTip = 'Specifies the value of the PragyapanPatra field.';
                ApplicationArea = All;
            }
            field("Party Type"; Rec."Party Type")
            {
                ToolTip = 'Specifies the value of the Party Type field.';
                ApplicationArea = All;
            }
            field("Party No."; Rec."Party No.")
            {
                ToolTip = 'Specifies the value of the Party No. field.';
                ApplicationArea = All;
            }
            field("Party Name"; Rec."Party Name")
            {
                ToolTip = 'Specifies the value of the Party Name field.';
                ApplicationArea = All;
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ToolTip = 'Specifies the value of the Letter of Credit/Telex Trans. field.';
                ApplicationArea = All;
            }
            field("T/R"; Rec."T/R")
            {
                ToolTip = 'Specifies the value of the T/R field.';
                ApplicationArea = All;
            }
            field("demand loan"; Rec."demand loan")
            {
                ToolTip = 'Specifies the value of the demand loan field.';
                ApplicationArea = All;
            }
            field(Margin; Rec.Margin)
            {
                ApplicationArea = All;
            }
        }
        addafter("On Hold")
        {
            field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
            {
                ApplicationArea = All;
            }

        }
        addafter("Bank Payment Type")
        {
            field("VAT Base 1"; Rec."VAT Base 1")
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field("TDS Group"; Rec."TDS Group")
            {
                ToolTip = 'Specifies the value of the TDS Group field.';
                ApplicationArea = All;
            }
            field("TDS Type"; Rec."TDS Type")
            {
                ToolTip = 'Specifies the value of the TDS Type field.';
                ApplicationArea = All;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ToolTip = 'Specifies the value of the TDS Amount field.';
                ApplicationArea = All;
            }
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
                ToolTip = 'Specifies the value of the TDS Base Amount field.';
                ApplicationArea = All;
            }
            field("TDS%"; Rec."TDS%")
            {
                ToolTip = 'Specifies the value of the TDS% field.';
                ApplicationArea = All;
            }
        }
        addafter("Bal. Account Name")
        {
            group("Debiit Amount")
            {
                CaptionML = ENU = 'Debit Amount';

                field("Debit Amount1"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Debit Amount 1';
                }
            }
            group("Credit Amounts")
            {
                CaptionML = ENU = 'Credit Amount';
                field("Credit Amount1"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                }

            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Test Report")
        {
            action("NP151001_Print_JV")
            {
                CaptionML = ENU = 'Print';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    GenJournalLine.SETRANGE("Document No.", Rec."Document No.");
                    GenJournalLine.SETRANGE("Posting Date", Rec."Posting Date");
                    REPORT.RUN(50000, TRUE, TRUE, GenJournalLine);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec, (Balance - TDSBalance), BelowxRec); //TDS1.00
    end;

    PROCEDURE SHowDebitCreditTotal();
    VAR
        SRTGenJnlLine: Record "Gen. Journal Line";
        DebitAmount: Decimal;
        CreditAmount: Decimal;
    BEGIN
        //SRT July 7th 2019 >>
        SRTGenJnlLine.RESET;
        SRTGenJnlLine.SETRANGE("Document No.", Rec."Document No.");
        IF SRTGenJnlLine.FINDSET THEN BEGIN
            SRTGenJnlLine.CALCSUMS("Debit Amount");
            SRTGenJnlLine.CALCSUMS("Credit Amount");
            DebitAmount := SRTGenJnlLine."Debit Amount";
            CreditAmount := SRTGenJnlLine."Credit Amount";
            IF Rec."Bal. Account No." <> '' THEN
                CreditAmount := DebitAmount;
        END;
        //SRT July 7th 2019 <<
    End;

    var
        myInt: Integer;
        Balance: Decimal;
        TDSBalance: Decimal;
}