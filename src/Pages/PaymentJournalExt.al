pageextension 50522 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Document Type")
        {
            Visible = false;
        }
        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                SHowDebitCreditTotal;// SRT July 7th 2019
            end;
        }
        modify("Has Payment Export Error")
        {
            Visible = false;
        }

        addafter("Has Payment Export Error")
        {
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = All;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = All;
                Visible = true;
                OptionCaptionML = ENU = ' , Employee ,Vendor,Customer,Party';
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = All;
            }
            field("Party Name"; Rec."Party Name")
            {
                ApplicationArea = All;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ApplicationArea = All;
            }

            field("T/R"; Rec."T/R")
            {
                ApplicationArea = All;
                Visible = false;

            }

            field(Margin; Rec.Margin)
            {
                ApplicationArea = All;
            }
            field("Line No."; Rec."Line No.")
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
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bal. Account Name")
        {
            group("Debit Amounts")
            {
                CaptionML = ENU = 'Debit Amount';
                field("Debit Amount1"; Rec."Debit Amount")
                {
                    ApplicationArea = All;
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
        addbefore("Test Report")
        {
            action("Print_PV_NP15.1001")
            {
                CaptionML = ENU = 'Print';
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    LocalGenJrnlLine: Record "Gen. Journal Line";
                begin
                    LocalGenJrnlLine.RESET;
                    LocalGenJrnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    LocalGenJrnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    LocalGenJrnlLine.SETRANGE("Document No.", Rec."Document No.");
                    LocalGenJrnlLine.SETRANGE("Posting Date", Rec."Posting Date");
                    REPORT.RUN(50002, TRUE, TRUE, LocalGenJrnlLine);
                end;

            }
        }
    }
    PROCEDURE SHowDebitCreditTotal();
    VAR
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        SRTGenJnlLine: Record "Gen. Journal Line";
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
                CreditAmount := DebitAmount - Rec."TDS Amount";
        END;
        //SRT July 7th 2019 <<
    END;

    var
        myInt: Integer;
}