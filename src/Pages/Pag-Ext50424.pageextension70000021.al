pageextension 50424 "pageextension70000021" extends "Posted Sales Invoices"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Posted Sales Invoices"(Page 143)".


    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Sales Invoices"(Page 143)".


    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Invoices"(Page 143)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Sales Invoices"(Page 143)".

    layout
    {
        modify(IncomingDocAttachFactBox)
        {
            Visible = true;
        }
        // modify("Control 22")
        // {
        //     Visible = false;
        // }
        // modify("Control 109")
        // {
        //     Visible = false;
        // }
        addfirst(content)
        {
            field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
            {
                ApplicationArea = all;
            }
            // field("Posting Date"; "Posting Date")  //allready defined 
            // {
            // }
            // field("Remaining Amount"; "Remaining Amount") //allready defined
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
            // }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
            field("Transport No."; TransportNo)
            {
                ApplicationArea = all;
            }
            field("Transport Name"; TransportName)
            {
                ApplicationArea = all;
            }
            field("Bilty No."; BiltyNo)
            {
                ApplicationArea = all;
            }
            field("Booking Date"; BookingDate)
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        modify(CorrectInvoice)
        {
            trigger OnAfterAction()
            begin
                SalesInvoicehdr.RESET;
                SalesInvoicehdr.SETRANGE("No.", Rec."No.");
                IF SalesInvoicehdr.FINDFIRST THEN
                    REPORT.RUN(50098, TRUE, TRUE, SalesInvoicehdr);
            end;
        }
        addafter(IncomingDoc)
        {
            action("Reset No. Of Print")
            {
                AccessByPermission = TableData 112 = RM;
                Image = ReOpen;
                Promoted = false;

                trigger OnAction()
                var
                    ResetPrintNo: Codeunit "Reset No. of Print";
                begin
                    ResetPrintNo.ResetPrint(Rec);  //KMT2016CU5
                end;
            }
            action(UpdateDimensionOnInvMatView)
            {
                Caption = 'Update Dimension on Mat. View';
                Image = UpdateXML;

                trigger OnAction()
                var
                    TempCode: Codeunit "TempCode SRT";
                begin
                    IF CONFIRM('Do you want to update?') THEN
                        TempCode.UpdateDimensionsonInvMatView;
                end;
            }
        }
    }


    //Unsupported feature: Property Modification (Id) on "ApplicationAreaMgmtFacade(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApplicationAreaMgmtFacade : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApplicationAreaMgmtFacade : 1984;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DocExchStatusStyle(Variable 1111)".

    //var
    //>>>> ORIGINAL VALUE:
    //DocExchStatusStyle : 1111;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DocExchStatusStyle : 1985;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CRMIntegrationEnabled(Variable 1222)".

    //var
    //>>>> ORIGINAL VALUE:
    //CRMIntegrationEnabled : 1222;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CRMIntegrationEnabled : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CRMIsCoupledToRecord(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //CRMIsCoupledToRecord : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CRMIsCoupledToRecord : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DocExchStatusVisible(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //DocExchStatusVisible : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DocExchStatusVisible : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsOfficeAddin(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsOfficeAddin : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsOfficeAddin : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "HasPostedSalesInvoices(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //HasPostedSalesInvoices : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //HasPostedSalesInvoices : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsFoundationEnabled(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsFoundationEnabled : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsFoundationEnabled : 1991;
    //Variable type has not been exported.

    var
        "--ASPL--": Integer;
        DeliveryDetails: Record "Tax Area";
        TransportNo: Code[20];
        TransportName: Text[50];
        BiltyNo: Code[20];
        BookingDate: Date;
        SalesInvoicehdr: Record "Sales Invoice Header";


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    HasPostedSalesInvoices := TRUE;
    CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    CRMIsCoupledToRecord := CRMIntegrationEnabled;
    IF CRMIsCoupledToRecord THEN
      CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    //CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
    GetDeliveryDetails; //ASPL April 21st 2021
    */

    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF DocExchStatusVisible THEN
      DocExchStatusStyle := GetDocExchStatusStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF DocExchStatusVisible THEN
      DocExchStatusStyle := GetDocExchStatusStyle;
    GetDeliveryDetails; //ASPL April 21st 2021
    */
    //end;

    local procedure GetDeliveryDetails()
    begin
        DeliveryDetails.RESET;
        DeliveryDetails.SETRANGE(Code, Rec."No.");
        IF DeliveryDetails.FINDLAST THEN BEGIN
            TransportNo := DeliveryDetails."Transport No.";
            TransportName := DeliveryDetails."Transport Name";
            BiltyNo := DeliveryDetails."Bilty No.";
            BookingDate := DeliveryDetails."Booking Date";
        END ELSE BEGIN
            TransportNo := '';
            TransportName := '';
            BiltyNo := '';

            BookingDate := 0D;
        END;
    end;

    //Unsupported feature: Property Modification (Id) on "DoDrillDown(PROCEDURE 3).SalesInvoiceHeader(Variable 1000)".

}

