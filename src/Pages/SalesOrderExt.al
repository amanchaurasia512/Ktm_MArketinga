pageextension 50529 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        modify("No. of Archived Versions")
        {
            Editable = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Bill-to Contact No.")
        {
            Visible = false;
        }
        modify("Bill-to Name")
        {
            Visible = false;
        }
        modify("Bill-to Address 2")
        {
            Visible = false;
        }
        modify("Bill-to Post Code")
        {
            Visible = false;
        }
        modify("Bill-to Contact")
        {
            Visible = false;
        }

        addafter("Sell-to Contact")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ToolTip = 'Specifies the value of the Product Code field.';
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                ApplicationArea = All;
            }
            field("Customer Price Group"; Rec."Customer Price Group")
            {
                ToolTip = 'Specifies the value of the Customer Price Group field.';
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
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //ASPL Apr 6th 2021 >>
        SalesSetup.GET;
        IF SalesSetup."Populate Damage Location" AND (Rec."Document Type" = Rec."Document Type"::Order) THEN BEGIN
            SalesSetup.TESTFIELD("Damage Location");
            Rec."Location Code" := SalesSetup."Damage Location";
        END;
        //ASPl Apr 6th 2021 <<
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
}