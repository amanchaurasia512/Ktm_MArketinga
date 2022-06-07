report 50410 "Close TDS Entry"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("TDS Entry"; "TDS Entry")
        {
            RequestFilterFields = "Posting Date", "TDS Posting Group", "Document No.";

            trigger OnAfterGetRecord()
            begin
                UserSetUp.GET(USERID);

                IF NOT Reverse THEN
                    CloseTDSEntry("IRDVoucherNo.", "TDS Entry", IRDVoucherNoDate, FiscalYear)
                ELSE
                    IF UserSetUp."Blank IRD Voucher No." THEN
                        ReverseCloseTDSEntry("TDS Entry")
                    ELSE
                        ERROR(Text0001);
            end;

            trigger OnPostDataItem()
            begin
                IF NOT Reverse THEN
                    MESSAGE(Text0003)
                ELSE
                    MESSAGE(Text0004);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("IRDVoucherNo."; "IRDVoucherNo.")
                    {
                        Caption = 'IRD Voucher No.';

                        trigger OnValidate()
                        begin
                            IF Reverse THEN BEGIN
                                "IRDVoucherNo." := '';
                                IRDVoucherNoDate := 0D;
                                FiscalYear := '';
                            END
                        end;
                    }
                    field(IRDVoucherNoDate; IRDVoucherNoDate)
                    {
                        Caption = 'IRD Voucher Date';
                    }
                    field(FiscalYear; FiscalYear)
                    {
                        Caption = 'Fiscal Year';
                    }
                    field(Reverse; Reverse)
                    {
                        Caption = 'Blank IRD Voucher No.';

                        trigger OnValidate()
                        begin
                            IF ("IRDVoucherNo." <> '') OR (IRDVoucherNoDate <> 0D) OR (FiscalYear <> '') THEN
                                ERROR(Text0002);
                        end;
                    }
                    field(SubmissionNo; SubmissionNo)
                    {
                        Caption = 'Submission No.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        "IRDVoucherNo.": Code[20];
        Reverse: Boolean;
        UserSetUp: Record "User Setup";
        Text0001: Label 'You are not authorised to blank IRD Voucher No.';
        Text0002: Label 'IRD Voucher No., IRD Voucher Date, and Fiscal Year should be blank';
        Text0003: Label 'IRD Voucher No., IRD Voucher Date, and Fiscal Year has been updated in selected lines';
        Text0004: Label 'IRD Voucher No., IRD Voucher Date, and Fiscal Year has been updated blank in selected lines';
        IRDVoucherNoDate: Date;
        FiscalYear: Code[10];
        SubmissionNo: Code[50];

    local procedure CloseTDSEntry("IRDVouNo.": Code[20]; TDSEntry: Record "TDS Entry"; IRDVouNoDate: Date; FiscalYear: Code[10])
    begin
        IF ("IRDVoucherNo." <> '') AND (IRDVoucherNoDate <> 0D) AND (FiscalYear <> '') THEN BEGIN
            IF NOT TDSEntry.Reversed AND NOT "TDS Entry".Closed THEN BEGIN
                TDSEntry."IRD Voucher No." := "IRDVouNo.";
                TDSEntry."IRD Voucher Date" := IRDVouNoDate;
                TDSEntry."Fiscal Year" := FiscalYear;
                TDSEntry."Submission No." := SubmissionNo;
                TDSEntry.Closed := TRUE;
                TDSEntry.MODIFY;
            END;
        END
    end;

    local procedure ReverseCloseTDSEntry(TDSEntry: Record "TDS Entry")
    begin
        TDSEntry."IRD Voucher No." := '';
        TDSEntry."IRD Voucher Date" := 0D;
        TDSEntry."Fiscal Year" := '';
        TDSEntry."Submission No." := '';
        TDSEntry.Closed := FALSE;
        TDSEntry.MODIFY;
    end;
}

