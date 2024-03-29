pageextension 50521 "Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    layout
    {

        // Add changes to page layout here
        modify("Document Type")
        {
            Visible = false;
        }
        modify("Debit Amount")
        {
            trigger OnAfterValidate()
            begin
                SHowDebitCreditTotal; //SRT July 7th 2019
            end;
        }
        modify("Credit Amount")
        {
            Visible = true;
            trigger OnAfterValidate()
            begin
                SHowDebitCreditTotal; //SRT July 7th 2019
            end;
        }
        modify("Bal. Account No.")
        {
            Visible = true;
            trigger OnAfterValidate()
            begin
                GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                Rec.ShowShortcutDimCode(ShortcutDimCode);
            end;
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                SHowDebitCreditTotal; //SRT July 7th 2019
            end;
        }
        modify("Applied (Yes/No)")
        {
            Visible = false;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = false;
        }
        modify("Applies-to Doc. Type")
        {
            Visible = false;
        }
        addafter("Account No.")
        {  //already defiend
           // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
           // {
           //     ApplicationArea = All;
           //     Visible = true;
           // }
           // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
           // {
           //     ApplicationArea = All;
           //     Visible =true;
           // }
        }
        addafter("Credit Amount")
        {
            // field("Amount (LCY)";"Amount (LCY)")
            // {
            //     ApplicationArea = All;
            // }
            // field("Bal. Account Type";"Bal. Account Type")
            // {
            //     ApplicationArea = All;
            //     Visible = true;
            // }
            // field(Amount;Amount)
            // {
            //     ApplicationArea = All;
            //Visible = true;
            // }

        }
        addafter(ShortcutDimCode3)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = All;
                OptionCaptionML = ENU = ' ,Employee,,Vendor,Customer,Party';
                Visible = false;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("T/R"; Rec."T/R")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field(Margin; Rec.Margin)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Visible = false;
                Editable = false;
            }
            field("TDS Group"; Rec."TDS Group")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("TDS%"; Rec."TDS%")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("TDS Type"; Rec."TDS Type")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
                ApplicationArea = All;
                Visible = false;
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
                field(CreditAmount1; CreditAmount)
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addbefore(Post)
        {
            action("Print_RV_NP15.1001")
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
                    REPORT.RUN(50001, TRUE, TRUE, LocalGenJrnlLine);
                end;
            }
        }

    }

    procedure SHowDebitCreditTotal()
    var
        SRTGenJnlLine: Record "Gen. Journal Line";
    begin
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
    end;

    var

        DebitAmount: Decimal;
        CreditAmount: Decimal;
        GenJnlManagement: Codeunit GenJnlManagement;
        AccName: Text[50];
        BalAccName: Text[50];

}