report 50091 "Send Product Segment Reports"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1; Table2000000026)
        {
            DataItemTableView = WHERE (Number = CONST (1));

            trigger OnAfterGetRecord()
            begin
                IRDMgt.SendProductWiseReportMailToConcernedPersons;
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

    var
        IRDMgt: Codeunit "50000";
}

