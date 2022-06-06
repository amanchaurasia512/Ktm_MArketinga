pageextension 50537 "Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {

            field("Source Document No."; Rec."Source Document No.")
            {
                ToolTip = 'Specifies the value of the Source Document No. field.';
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
        IF SalesSetup."Default Transfer-from Code" <> '' THEN
            Rec."Transfer-from Code" := SalesSetup."Default Transfer-from Code";

        IF SalesSetup."Default Transfer-to Code" <> '' THEN BEGIN
            Rec."Transfer-to Code" := SalesSetup."Default Transfer-to Code";
            Rec."In-Transit Code" := 'INTRANSIT';
        END;
        //ASPL Apr 6th 2021 <<
    end;

    var
        myInt: Integer;
        SalesSetup: Record "Sales & Receivables Setup";
}