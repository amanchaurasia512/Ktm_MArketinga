pageextension 50486 "pageextension70000115" extends "Purchase Order List"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Purchase Order List"(Page 9307)".


    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Purchase Order List"(Page 9307)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Purchase Order List"(Page 9307)".

    layout
    {
        modify("Amount Received Not Invoiced excl. VAT (LCY)")
        {
            Visible = false;
        }
        // modify("Control 20")
        // {
        //     Visible = false;
        // }
        // modify("Control 22")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            // field("Amount Including VAT"; "Amount Including VAT")
            // {
            // }
            // field(Amount; Amount)
            // {
            // }
            // field("Delete Record"; "Delete Record")
            // {
            // }
            // field("Amount Received Not Invoiced excl. VAT (LCY)"; "A. Rcd. Not Inv. Ex. VAT (LCY)")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the amount excluding VAT for the items on the order that have been received but are not yet invoiced.';
            //     Visible = false;
            // }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (Level) on "Send(Action 24)".


        //Unsupported feature: Property Modification (ActionType) on "Send(Action 24)".



        //Unsupported feature: Property Deletion (Name) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (Ellipsis) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (CaptionML) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (ToolTipML) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (Promoted) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (PromotedIsBig) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (Image) on "Send(Action 24)".


        //Unsupported feature: Property Deletion (PromotedCategory) on "Send(Action 24)".

        addafter(Print)
        {
            action(Send_ktm)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                    PurchaseHeader.SendRecords;
                end;
            }
        }
        addafter(Send)
        {
            action(Delete)
            {
                Caption = 'Delete';
                Image = "Delete";
                Promoted = true;
                Visible = CanDel;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want delete the Purchase Order ?') THEN BEGIN
                        Rec."Delete Record" := TRUE;
                        Rec.MODIFY;
                    END;
                end;
            }
        }
        // moveafter(Print; "Action 10")
    }


    //Unsupported feature: Property Modification (Id) on "JobQueueActive(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //JobQueueActive : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //JobQueueActive : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "OpenApprovalEntriesExist(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //OpenApprovalEntriesExist : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //OpenApprovalEntriesExist : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CanCancelApprovalForRecord(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //CanCancelApprovalForRecord : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CanCancelApprovalForRecord : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SkipLinesWithoutVAT(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //SkipLinesWithoutVAT : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SkipLinesWithoutVAT : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ReadyToPostQst(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //ReadyToPostQst : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ReadyToPostQst : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CanRequestApprovalForFlow(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //CanRequestApprovalForFlow : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CanRequestApprovalForFlow : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CanCancelApprovalForFlow(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //CanCancelApprovalForFlow : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CanCancelApprovalForFlow : 1993;
    //Variable type has not been exported.

    var
        UserSetup: Record "User Setup";
        CanDel: Boolean;
        PurchHdr: Record "Purchase Header";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    trigger OnAfterGetRecord()
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Can Delete Purchase Order" THEN
            CanDel := TRUE
        ELSE
            CanDel := FALSE;
    end;

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Delete Record", '%1', FALSE);//Aakrista
    end;

    //Unsupported feature: Property Modification (Id) on "SetControlAppearance(PROCEDURE 5).ApprovalsMgmt(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "SetControlAppearance(PROCEDURE 5).WorkflowWebhookManagement(Variable 1001)".


    //Unsupported feature: Property Modification (Id) on "ShowHeader(PROCEDURE 6).CashFlowManagement(Variable 1000)".

}

