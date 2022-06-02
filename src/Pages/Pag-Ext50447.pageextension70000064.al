pageextension 50447 "pageextension70000064" extends "Purchase Order Archive"
{
    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 3".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 3".


        //Unsupported feature: Property Modification (Level) on "Control 5".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 5".


        //Unsupported feature: Property Modification (Level) on "Control 7".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 7".


        //Unsupported feature: Property Modification (Level) on "Control 9".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 9".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 3".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 3".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 3".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 5".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 5".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 5".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 7".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 7".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 7".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 9".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 9".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 9".

        addlast(content)
        {
            // field("Buy-from County"; "Buy-from County")
            // {
            //     ApplicationArea = Advanced;
            //     Caption = 'County';
            //     ToolTip = 'Specifies the county of your vendor.';
            // }
            // field("Pay-to County"; "Pay-to County")
            // {
            //     ApplicationArea = Advanced;
            //     Caption = 'County';
            //     ToolTip = 'Specifies the county of the vendor on the purchase document.';
            // }
            // field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
            // {
            //     ApplicationArea = Suite;
            //     Caption = 'Country/Region';
            //     ToolTip = 'Specifies the country or region of the vendor on the purchase document.';
            // }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
            }
        }
        // addafter("Control 12") 
        // {
        //     field("Buy-from Country/Region Code"; "Buy-from Country/Region Code") // allready defined
        //     {
        //         ApplicationArea = Suite;
        //         Caption = 'Country/Region';
        //         ToolTip = 'Specifies the country or region of your vendor.';
        //     }
        // }


        // moveafter("Control 23"; "Control 12")
        // moveafter("Control 12"; "Control 14")
        // moveafter("Control 27"; "Control 44")
        // moveafter("Control 44"; "Control 46")
        // moveafter("Control 62"; "Control 5")
        // moveafter("Control 5"; "Control 9")
        // moveafter("Control 9"; "Control 7")
    }
}

