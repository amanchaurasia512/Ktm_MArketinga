pageextension 50419 "pageextension70000014" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 3".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 7".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 5".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 3".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 3".


        //Unsupported feature: Property Deletion (Visible) on "Control 3".

        // modify("Control 52")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 7".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 7".


        //Unsupported feature: Property Deletion (Visible) on "Control 7".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 5".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 5".


        //Unsupported feature: Property Deletion (Visible) on "Control 5".

        addlast(content)
        {
            // field("Job Task No."; "Job Task No.")   //already define
            // {
            //     ApplicationArea = Jobs;
            //     ToolTip = 'Specifies the number of the related job task.';
            //     Visible = false;
            // }
            // field(Correction; Correction)
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.';
            //     Visible = false;
            // }
            // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            // {
            //     ApplicationArea = Dimensions;
            //     ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            //     Visible = DimVisible1;
            // }
            // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
            // {
            //     ApplicationArea = Dimensions;
            //     ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            //     Visible = DimVisible2;
            // }
        }

        // moveafter("Control 32"; "Control 22")
        // moveafter("Control 34"; "Control 19")
        // moveafter("Control 3"; "Control 5")
    }
}

