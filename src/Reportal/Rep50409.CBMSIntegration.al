report 50409 "CBMS Integration"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integration; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                CBMSMgt: Codeunit "IRD CBMS Mgt.";
            begin
                InvoiceMaterializeView.RESET;
                InvoiceMaterializeView.LOCKTABLE;
                InvoiceMaterializeView.SETFILTER("Sync Status", '%1|%2', InvoiceMaterializeView."Sync Status"::Pending, InvoiceMaterializeView."Sync Status"::"Sync In Progress");
                InvoiceMaterializeView.SETFILTER("Bill Date", '>%1', 20190721D);
                IF NOT JobQueueActive THEN
                    ProgressWindow.UPDATE(2, InvoiceMaterializeView.COUNT);
                IF InvoiceMaterializeView.FINDSET THEN
                    REPEAT
                        IF NOT JobQueueActive THEN BEGIN
                            TotalCount += 1;
                            ProgressWindow.UPDATE(1, TotalCount);
                        END;
                        CBMSMgt.StartBatchCBMSIntegration(InvoiceMaterializeView);
                    UNTIL InvoiceMaterializeView.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                IF NOT JobQueueActive THEN
                    ProgressWindow.OPEN(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF NOT JobQueueActive THEN
            ProgressWindow.CLOSE;
    end;

    var
        InvoiceMaterializeView: Record "Invoice Materialize View";
        ProgressWindow: Dialog;
        Text001: Label 'Syncing #1############ of #2############';
        TotalCount: Integer;

    [Scope('OnPrem')]
    procedure JobQueueActive(): Boolean
    begin
        EXIT(NOT GUIALLOWED);
    end;
}

