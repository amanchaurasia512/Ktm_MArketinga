pageextension 50471 "pageextension70000100" extends "Purchase Return Order Archive"
{
    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 3".


        //Unsupported feature: Property Modification (ControlType) on "Control 3".


        //Unsupported feature: Property Insertion (SourceExpr) on "Control 3".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 9".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 11".


        //Unsupported feature: Property Modification (Level) on "Control 5".


        //Unsupported feature: Property Modification (ControlType) on "Control 5".


        //Unsupported feature: Property Insertion (SourceExpr) on "Control 5".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 3".


        //Unsupported feature: Property Deletion (GroupType) on "Control 3".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 9".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 9".


        //Unsupported feature: Property Deletion (Importance) on "Control 9".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 11".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 11".


        //Unsupported feature: Property Deletion (Importance) on "Control 11".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 5".


        //Unsupported feature: Property Deletion (GroupType) on "Control 5".


        addlast(content)
        {
            // field("Buy-from County"; "Buy-from County")
            // {
            //     ApplicationArea = Advanced;
            //     Caption = 'County';
            //     Importance = Additional;
            // }
            // field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
            // {
            //     ApplicationArea = Advanced;
            //     Caption = 'Country/Region Code';
            //     Importance = Additional;
            // }
            field("Purchase Consignment No."; Rec."Purchase Consignment No.")
            {
                ApplicationArea = all;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
        }

        // addfirst("Control 1906801201")
        // {
        //     group("Ship-to")
        //     {
        //         Caption = 'Ship-to';
        //     }
        // }
        // addafter("Control 68")
        // {

        // }

        // moveafter("Control 6"; "Control 8")
        // moveafter("Control 10"; "Control 12")
        // moveafter("Control 122"; "Control 123")
        // moveafter("Control 1906801201"; "Control 64")
        // moveafter("Control 68"; "Control 11")
        // moveafter("Control 11"; "Control 9")
        // moveafter("Control 9"; "Control 5")
    }
}

