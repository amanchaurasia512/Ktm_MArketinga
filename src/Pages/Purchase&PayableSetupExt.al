pageextension 50534 "Purch & Paybles setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here2
        addafter("Default Qty. to Receive")
        {

            field("Show Description From"; Rec."Show Description From")
            {
                ToolTip = 'Specifies the value of the Show Description From field.';
                ApplicationArea = All;
            }
            field("Item Charge VAT Book"; Rec."Item Charge VAT Book")
            {
                ToolTip = 'Specifies the value of the Item Charge VAT Book field.';
                ApplicationArea = All;
            }
        }
        addafter("Credit Acc. for Non-Item Lines")
        {
            group(IRD)
            {
                field("Purchase Consignment Nos."; Rec."Purchase Consignment Nos.")
                {
                    ApplicationArea = All;
                }

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