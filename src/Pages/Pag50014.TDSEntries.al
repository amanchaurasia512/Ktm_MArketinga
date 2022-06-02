page 50014 "TDS Entries"
{
    Editable = true;
    PageType = List;
    SourceTable = "TDS Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Bill-to/Pay-to Name"; BillToPayToName)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("TDS Posting Group"; Rec."TDS Posting Group")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Main G/L Account"; Rec."Main G/L Account")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Main G/L Account Name"; Rec."Main G/L Account Name")
                {
                    ApplicationArea = all;
                }
                field("TDS GL Account"; Rec."GL Account")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("TDS%"; Rec."TDS%")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Payment Done"; Rec."Payment Done")
                {
                    ApplicationArea = all;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("TDS Type"; Rec."TDS Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Submission No."; Rec."Submission No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("IRD Voucher No."; Rec."IRD Voucher No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("IRD Voucher Date"; Rec."IRD Voucher Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("G/L Entry No."; Rec."G/L Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Payment Transaction No."; Rec."Payment Transaction No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("GL Account Name"; Rec."GL Account Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
            }

            group(General)
            {
                fixed(contorl)
                {
                    group(Balance)
                    {
                        Caption = 'Balance';
                        field(TDS; TDSBalance + Rec."TDS Amount" - xRec."TDS Amount")
                        {
                            AutoFormatType = 1;
                            Caption = 'TDS';
                            Editable = false;
                            Visible = TDSBalanceVisible;
                        }
                        field("TDS Base"; BaseBalance + Rec.Base - xRec.Base)
                        {
                            Caption = 'TDS Base';
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field("Total TDS"; TotalTDSBalance + Rec."TDS Amount" - xRec."TDS Amount")
                        {
                            AutoFormatType = 1;
                            Caption = 'Total TDS';
                            Editable = false;
                            Visible = TotalTDSBalanceVisible;
                        }
                        field("Total TDS Base"; TotalBaseBalance + Rec.Base - xRec.Base)
                        {
                            Caption = 'Total TDS Base';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action("Close TDS Entries")
            {
                Caption = 'Close TDS Entries';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    //Filters := getfilters;
                    TDSentry.RESET;
                    CurrPage.SETSELECTIONFILTER(TDSentry);
                    IF TDSentry.FINDFIRST THEN BEGIN
                        TDSentry.MARK;
                        REPORT.RUNMODAL(50081, TRUE, FALSE, TDSentry);
                    END;
                end;
            }
            group(Reports)
            {
                Caption = 'Reports';
            }
            action("TDS Entry")
            {
                Caption = 'TDS Entry';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //RunObject = Report 50083;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    //Filters := getfilters;
                    TDSentry.RESET;
                    TDSentry.COPYFILTERS(Rec);
                    REPORT.RUNMODAL(50001, TRUE, FALSE, TDSentry);
                end;
            }
            action("Vendor TDS Entry")
            {
                Caption = 'Vendor TDS Entry';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = all;
                //RunObject = Report 50082;

                trigger OnAction()
                begin
                    //Filters := getfilters;
                    TDSentry.RESET;
                    TDSentry.COPYFILTERS(Rec);

                    REPORT.RUNMODAL(50001, TRUE, FALSE, TDSentry);
                end;
            }
            action("TDS Entry II")
            {
                Caption = 'TDS Entry II';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //RunObject = Report 50084;

                trigger OnAction()
                begin
                    //Filters := getfilters;
                    /*
                    TDSentry.RESET;
                    TDSentry.COPYFILTERS(Rec);
                    REPORT.RUNMODAL(50001,TRUE,FALSE,TDSentry);
                    */

                end;
            }
            action("TDS Payment")
            {
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BankAccNo: Code[20];
                    BankAccountTxt: Label 'Bank Account';
                    BankAccPage: Page "Bank Account List";
                    JournalBatchTxt: Label 'Enter Template and Batch before posting.';
                    GenJnlTemplateName: Code[10];
                    GenJnlBatchName: Code[10];
                    SelectionErr: Label 'Please enter Bank No., Journal Template Name and Journal Batch Name before posting.';
                    GenJnlLine: Record "Gen. Journal Line";
                    GenJnlBatchRec: Record "Gen. Journal Batch";
                    GenJnlTemplateRec: Record "Gen. Journal Template";
                    DocNo: Code[20];
                    LineNo: Integer;
                    TemplateSecurity: Record "Gen. Journal Line";
                begin
                    GLSetup.GET;
                    TotalBankAmt := 0;
                    LineNo := 10000;
                    BankPageBuilder.ADDRECORD(BankAccountTxt, BankAccount);
                    BankPageBuilder.ADDFIELD(BankAccountTxt, BankAccount."No.");
                    BankPageBuilder.ADDRECORD(JournalBatchTxt, TemplateSecurity);
                    BankPageBuilder.ADDFIELD(JournalBatchTxt, TemplateSecurity."Journal Template Name");
                    BankPageBuilder.ADDFIELD(JournalBatchTxt, TemplateSecurity."Journal Batch Name");
                    BankPageBuilder.RUNMODAL;
                    BankAccount.SETVIEW(BankPageBuilder.GETVIEW(BankAccountTxt));
                    TemplateSecurity.SETVIEW(BankPageBuilder.GETVIEW(JournalBatchTxt));
                    BankAccNo := BankAccount.GETFILTER("No.");
                    GenJnlTemplateName := TemplateSecurity.GETFILTER("Journal Template Name");
                    GenJnlBatchName := TemplateSecurity.GETFILTER("Journal Batch Name");

                    IF (BankAccNo <> '') AND (GenJnlTemplateName <> '') AND (GenJnlBatchName <> '') THEN BEGIN
                        TDSentry.RESET;
                        CurrPage.SETSELECTIONFILTER(TDSentry);
                        IF TDSentry.FINDFIRST THEN BEGIN
                            GenJnlBatchRec.RESET;
                            GenJnlBatchRec.SETRANGE("Journal Template Name", GenJnlTemplateName);
                            GenJnlBatchRec.SETRANGE(Name, GenJnlBatchName);
                            GenJnlBatchRec.SETFILTER("Posting No. Series", '<>%1', '');
                            IF GenJnlBatchRec.FINDFIRST THEN BEGIN
                                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatchRec."No. Series", TODAY, TRUE);
                                IF GenJnlTemplateRec.GET(GenJnlBatchRec."Journal Template Name") THEN
                                    GenJnlLine."Source Code" := GenJnlTemplateRec."Source Code";
                            END;
                            REPEAT
                                IF NOT TDSentry."Payment Done" THEN
                                    TotalBankAmt += TDSentry."TDS Amount";
                                IF NOT TDSentry."Payment Done" THEN BEGIN
                                    GenJnlLine.INIT;
                                    GenJnlLine."Document No." := DocNo;
                                    Rec.CreatePaymentJournals(GenJnlLine, TDSentry, FALSE, BankAccNo, GenJnlTemplateName, GenJnlBatchName, LineNo);
                                    LineNo += 10000;
                                END ELSE
                                    ERROR(PaymentAlreadyDone, TDSentry."Document No.", TDSentry."Entry No.");
                            UNTIL TDSentry.NEXT = 0;
                            GenJnlLine.INIT;
                            GenJnlLine."Document No." := DocNo;
                            GenJnlLine."Source Code" := GenJnlTemplateRec."Source Code";
                            Rec.CreateBalanceJournal(GenJnlLine, FALSE, BankAccNo, TotalBankAmt, LineNo);
                            IF TDSentry.FINDFIRST THEN BEGIN

                            END;
                        END;
                        MESSAGE(TDSPaymentDone);
                    END ELSE
                        ERROR(SelectionErr);
                end;
            }
            action("Reverse TDS Payment")
            {
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                    DocNo: Code[20];
                    GLEntry: Record "G/L Entry";
                    LineNo: Integer;
                begin
                    TotalBankAmt := 0;
                    TDSentry.RESET;
                    CurrPage.SETSELECTIONFILTER(TDSentry);
                    IF TDSentry.FINDFIRST THEN BEGIN
                        GLEntry.RESET;
                        GLEntry.SETRANGE("Transaction No.", TDSentry."Payment Transaction No.");
                        IF GLEntry.FINDFIRST THEN
                            DocNo := GLEntry."Document No.";
                        GenJnlLine.INIT;
                        GenJnlLine."Document No." := DocNo;
                        REPEAT
                            TotalBankAmt += TDSentry."TDS Amount";
                            IF (TDSentry."Payment Done") OR (NOT TDSentry.Reversed) THEN BEGIN
                                Rec.CreatePaymentJournals(GenJnlLine, TDSentry, TRUE, TDSentry."Bank Account No.", '', '', LineNo);
                                LineNo += 10000;
                            END ELSE
                                ERROR(ReverseHasAlreadyDone, TDSentry."Document No.");
                        UNTIL TDSentry.NEXT = 0;
                        Rec.CreateBalanceJournal(GenJnlLine, TRUE, TDSentry."Bank Account No.", TotalBankAmt, LineNo);
                        MESSAGE(TDSReversed);
                    END;
                    //ReverseTDSPaymentEntry(TDSentry);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetBillToPayToName;
    end;

    var
        Filters: Text[100];
        TDSentry: Record "TDS Entry";
        TDSBalance: Decimal;
        TotalTDSBalance: Decimal;
        ShowTDSBalance: Boolean;
        ShowTotalTDSBalance: Boolean;
        [InDataSet]
        TDSBalanceVisible: Boolean;
        [InDataSet]
        TotalTDSBalanceVisible: Boolean;
        GenJnlManagement: Codeunit GenJnlManagement;
        BaseBalance: Decimal;
        TotalBaseBalance: Decimal;
        ShowBaseBalance: Boolean;
        ShowTotalBaseBalance: Boolean;
        [InDataSet]
        BaseBalanceVisible: Boolean;
        [InDataSet]
        TotalBaseBalanceVisible: Boolean;
        BankPageBuilder: FilterPageBuilder;
        BankAccount: Record "Bank Account";
        TotalBankAmt: Decimal;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlPost: Codeunit "Gen. Jnl.-Post Line";
        GLSetup: Record "General Ledger Setup";
        PaymentAlreadyDone: Label 'Payment has already been done for Document No. %1 Entry No. %2.';
        ReverseHasAlreadyDone: Label 'Document No. %1 has already been reversed.';
        TDSPaymentDone: Label 'The payment for selected TDS Entries has been posted.';
        TDSReversed: Label 'The reversal of payment for selected TDS Entries has been posted.';
        BillToPayToName: Text;

    local procedure UpdateBalance()
    begin
        //GenJnlManagement.CalcTDSEntryTDSBalance(Rec, xRec, TDSBalance, TotalTDSBalance, ShowTDSBalance, ShowTotalTDSBalance); //TDS1.00
        TDSBalanceVisible := ShowTDSBalance;  //TDS1.00
        TotalTDSBalanceVisible := ShowTotalTDSBalance; //TDS1.00
        //GenJnlManagement.CalcTDSEntryBaseBalance(Rec, xRec, BaseBalance, TotalBaseBalance, ShowBaseBalance, ShowTotalBaseBalance); //TDS1.00
        BaseBalanceVisible := ShowBaseBalance;  //TDS1.00
        TotalBaseBalanceVisible := ShowTotalBaseBalance; //TDS1.00
    end;

    local procedure GetBillToPayToName()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin
        IF Rec."Source Type" = Rec."Source Type"::Customer THEN BEGIN
            IF Customer.GET(Rec."Bill-to/Pay-to No.") THEN
                BillToPayToName := Customer.Name
            ELSE
                BillToPayToName := '';
        END ELSE
            IF Rec."Source Type" = Rec."Source Type"::Employee THEN BEGIN
                GLSetup.GET;
                DimValue.RESET;
                DimValue.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                DimValue.SETRANGE(Code, Rec."Bill-to/Pay-to No.");
                IF DimValue.FINDFIRST THEN
                    BillToPayToName := DimValue.Name
                ELSE
                    BillToPayToName := '';
            END ELSE
                IF Rec."Source Type" = Rec."Source Type"::Vendor THEN BEGIN
                    IF Vendor.GET(Rec."Bill-to/Pay-to No.") THEN
                        BillToPayToName := Vendor.Name
                    ELSE
                        BillToPayToName := '';
                END;
    end;
}

