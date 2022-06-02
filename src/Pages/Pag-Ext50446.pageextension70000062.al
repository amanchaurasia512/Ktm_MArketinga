pageextension 50446 "pageextension70000062" extends "Purchase Invoice"
{
    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 64".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 64".


        //Unsupported feature: Property Modification (Level) on "Control 51".


        //Unsupported feature: Property Modification (ControlType) on "Control 51".


        //Unsupported feature: Property Insertion (SourceExpr) on "Control 51".


        //Unsupported feature: Property Modification (Level) on "Control 93".


        //Unsupported feature: Property Modification (Level) on "Control 92".


        //Unsupported feature: Property Modification (Level) on "Control 77".


        //Unsupported feature: Property Modification (Level) on "Control 95".


        //Unsupported feature: Property Modification (Level) on "Control 128".


        //Unsupported feature: Property Modification (ControlType) on "Control 53".


        //Unsupported feature: Property Insertion (SourceExpr) on "Control 53".


        //Unsupported feature: Property Modification (Level) on "Control 36".


        //Unsupported feature: Property Modification (Level) on "Control 38".


        //Unsupported feature: Property Modification (Level) on "Control 40".


        //Unsupported feature: Property Modification (Level) on "Control 42".


        //Unsupported feature: Property Modification (Level) on "Control 94".


        //Unsupported feature: Property Modification (Level) on "Control 83".


        //Unsupported feature: Property Modification (Level) on "Control 44".


        //Unsupported feature: Property Modification (Level) on "Control 82".


        //Unsupported feature: Property Modification (Level) on "Control 99".


        //Unsupported feature: Property Modification (Level) on "Control 130".


        //Unsupported feature: Property Modification (Level) on "Control 26".

        // modify("Control 64.OnValidate")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (CaptionML) on "Control 64".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 64".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 64".


        //Unsupported feature: Property Deletion (NotBlank) on "Control 64".


        //Unsupported feature: Property Deletion (Importance) on "Control 64".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 51".


        //Unsupported feature: Property Deletion (GroupType) on "Control 51".


        //Unsupported feature: Property Deletion (GroupType) on "Control 53".

        addlast(content)
        {
            // field("Buy-from Vendor No."; "Buy-from Vendor No.")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Vendor No.';
            //     Importance = Additional;
            //     NotBlank = true;
            //     ToolTip = 'Specifies the number of the vendor who delivers the products.';

            //     trigger OnValidate()
            //     begin
            //         OnAfterValidateBuyFromVendorNo(Rec, xRec);
            //         CurrPage.UPDATE;
            //     end;
            // }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
            }
            field("<VAT Base Amount>"; Rec."VAT Base 1")
            {
                Caption = 'Vat Base Amt 13%';
                Visible = true;
            }
            field("Free Item Vendor No."; Rec."Free Item Vendor No.")
            {
            }
            field("Free Item Vendor Name"; Rec."Free Item Vendor Name")
            {
            }
            field("Exempt Amount"; Rec."Exempt Amount")
            {
                Visible = false;
            }
            field("Party Type"; Rec."Party Type")
            {
                OptionCaption = ' ,Employee,,,,Party';
            }
        }
        // addafter("Control 90")
        // {
        //     group("Buy-from")
        //     {
        //         Caption = 'Buy-from';
        //     }
        // }

        // addafter("Control 1907468901")
        // {
        //     group(IRD)
        //     {
        //         Caption = 'Purchase Bundling';
        //         Visible = false;
        //     }
        // }
        // moveafter("Control 2"; "Control 6")
        // moveafter("Control 90"; "Control 72")
        // moveafter("Control 1906801201"; "Control 78")
        // moveafter("Control 51"; "Control 81")
    }
}

