pageextension 50485 "pageextension70000114" extends "Sales Invoice List"
{
    layout
    {
        // modify("Control 12")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            // field(Amount; Amount)
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the sum of amounts in the Line Amount field on the sales order lines. It is used to calculate the invoice discount of the sales order.';
            // }
        }
    }
    actions
    {
        addafter(SalesReports)
        {
            action("Preview Confirmation ")
            {
                Caption = 'Print Confirmation';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SalesHeader1.RESET;
                    SalesHeader1.SETRANGE("No.", Rec."No.");
                    SalesHeader1.SETRANGE("Posting Date", Rec."Posting Date");
                    IF SalesHeader1.FINDFIRST THEN
                        REPORT.RUN(50065, TRUE, FALSE, SalesHeader1);
                    //DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
                end;
            }
        }
    }


    //Unsupported feature: Property Modification (Id) on "ApplicationAreaMgmtFacade(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApplicationAreaMgmtFacade : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApplicationAreaMgmtFacade : 1983;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "LinesInstructionMgt(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //LinesInstructionMgt : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //LinesInstructionMgt : 1984;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "JobQueueActive(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //JobQueueActive : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //JobQueueActive : 1985;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "OpenApprovalEntriesExist(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //OpenApprovalEntriesExist : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //OpenApprovalEntriesExist : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "OpenPostedSalesInvQst(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //OpenPostedSalesInvQst : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //OpenPostedSalesInvQst : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CanCancelApprovalForRecord(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //CanCancelApprovalForRecord : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CanCancelApprovalForRecord : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ReadyToPostQst(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //ReadyToPostQst : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ReadyToPostQst : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CanRequestApprovalForFlow(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //CanRequestApprovalForFlow : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CanRequestApprovalForFlow : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CanCancelApprovalForFlow(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //CanCancelApprovalForFlow : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CanCancelApprovalForFlow : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CustomerSelected(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //CustomerSelected : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CustomerSelected : 1992;
    //Variable type has not been exported.

    var
        SalesHeader1: Record "Sales Header";

    //Unsupported feature: Property Modification (Id) on "ShowPreview(PROCEDURE 1).SalesPostYesNo(Variable 1001)".


    //Unsupported feature: Property Modification (Id) on "SetControlAppearance(PROCEDURE 5).ApprovalsMgmt(Variable 1002)".


    //Unsupported feature: Property Modification (Id) on "SetControlAppearance(PROCEDURE 5).WorkflowWebhookManagement(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "Post(PROCEDURE 4).PreAssignedNo(Variable 1001)".


    //Unsupported feature: Property Modification (Id) on "ShowPostedConfirmationMessage(PROCEDURE 7).SalesInvoiceHeader(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "ShowPostedConfirmationMessage(PROCEDURE 7).InstructionMgt(Variable 1002)".

}

