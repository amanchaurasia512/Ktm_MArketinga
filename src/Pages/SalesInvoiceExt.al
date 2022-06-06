pageextension 50530 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = true;
        }

        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify("Bill-to Contact No.")
        {
            Visible = false;
        }
        modify("Bill-to Address")
        {
            Visible = false;
        }
        modify("Bill-to City")
        {
            Visible = false;
        }
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        addafter("Sell-to Post Code")
        {
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
            }

        }
        addafter(Status)
        {
            field(Note; Rec.Note)
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Contact")
        {

            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                ApplicationArea = All;
            }
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ToolTip = 'Specifies the value of the Product Code field.';
                ApplicationArea = All;
            }
            field("Customer Price Group"; Rec."Customer Price Group")
            {
                ToolTip = 'Specifies the value of the Customer Price Group field.';
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    ShortcutDimension4CodeOnAfterV;
                end;
            }
        }
        addafter("Bill-to Address")
        {

            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                ApplicationArea = All;
            }
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Preview)
        {
            action("[Preview Confirmation ]")
            {
                CaptionML = ENU = 'Print Confrimation';
                Ellipsis = true;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                Image = Print;
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
    PROCEDURE ShortcutDimension4CodeOnAfterV();
    BEGIN
        CurrPage.UPDATE;
    END;

    var
        myInt: Integer;
        SalesHeader1: Record "Sales Header";
}