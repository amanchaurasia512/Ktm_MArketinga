pageextension 50510 "Posted Sales Invoice ext" extends "Posted Sales Invoice"
{
    Editable = false;

    layout
    {
        addafter("Document Date")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addafter("No. Printed")
        {
            field(Note; Rec.Note)
            {
                ApplicationArea = All;
            }

        }


        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(ChangePaymentService)
        {
            action("Reset No. Of Print")
            {
                AccessByPermission = TableData 112 = RM;
                Image = ReOpen;
                Promoted = false;
                ApplicationArea = all;
                trigger OnAction()
                var
                    ResetPrintNo: Codeunit "Reset No. of Print";
                begin
                    ResetPrintNo.ResetPrint(Rec);  //KMT2016CU5
                end;

            }
            action("Delivery Details")
            {
                RunObject = Page 50016;
                RunPageLink = Code = FIELD("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = ItemLines;
                PromotedCategory = Process;
            }
        }
        addafter("&Navigate")
        {
            action("OldPrint")
            {
                CaptionML = ENU = 'OldPrint';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesInvoicehdr: Record "Sales Invoice Header";
                begin
                    SalesInvoicehdr.RESET;
                    SalesInvoicehdr.SETRANGE("No.", Rec."No.");
                    IF SalesInvoicehdr.FINDFIRST THEN
                        REPORT.RUN(50098, TRUE, TRUE, SalesInvoicehdr);
                end;

            }
        }

    }

    trigger OnOpenPage()
    begin
        SetControlProperty; //ASPL April 22nd 2021
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlProperty; //ASPL April 22nd 2021
    end;

    procedure SetControlProperty();
    var
        DeliveryExistVisible: Boolean;
        DeliveryDetails: Record "Tax Area";
        SalesInvoicehdr: Record "Sales Invoice Header";
    BEGIN
        DeliveryDetails.RESET;
        DeliveryDetails.SETRANGE("Source No.", Rec."No.");
        IF DeliveryDetails.FINDFIRST THEN
            DeliveryExistVisible := TRUE
        ELSE
            DeliveryExistVisible := FALSE;
    END;

    var
        myInt: Integer;
}