report 50091 "Send Product Segment Reports"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));

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
        IRDMgt: Codeunit "IRD Mgt.";
}

