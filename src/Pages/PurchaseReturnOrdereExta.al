pageextension 50543 "Purchase return Order Ext" extends "Purchase Return Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("VAT Bus. Posting Group")
        {

            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ToolTip = 'Specifies the value of the Letter of Credit/Telex Trans. field.';
                ApplicationArea = All;
            }
            field("Party Type"; Rec."Party Type")
            {
                ToolTip = 'Specifies the value of the Party Type field.';
                ApplicationArea = All;
            }
            field("Party No."; Rec."Party No.")
            {
                ToolTip = 'Specifies the value of the Party No. field.';
                ApplicationArea = All;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ToolTip = 'Specifies the value of the Nepali Date field.';
                ApplicationArea = All;
            }
        }
        addafter("Area")
        {
            group(IRD)
            {
                CaptionML = ENU = 'Purchase bundling';

                field(PragyapanPatra; Rec.PragyapanPatra)
                {
                    ToolTip = 'Specifies the value of the PragyapanPatra field.';
                    ApplicationArea = All;
                }
                field("Purchase Consignment No."; Rec."Purchase Consignment No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Consignment No. field.';
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