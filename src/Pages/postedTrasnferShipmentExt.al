pageextension 50539 "Posted trans Shipment Ext" extends "Posted Transfer Shipments"
{
    layout
    {
        // Add changes to page layout here
        addafter("Receipt Date")
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

    var
        myInt: Integer;
}