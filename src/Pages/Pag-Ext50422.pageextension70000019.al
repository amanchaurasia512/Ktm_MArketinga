pageextension 50422 "pageextension70000019" extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 15".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 15".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 15".


        //Unsupported feature: Property Deletion (Visible) on "Control 15".

        addlast(content)
        {
            field("Job Task No._ktm"; Rec."Job Task No.")
            {
                ApplicationArea = Jobs;
                ToolTip = 'Specifies the number of the related job task.';
                Visible = false;
            }
            field("Exmpt. Purchase"; Rec."Exmpt. Purchase")
            {
                ApplicationArea = all;
            }
            field("VAT Base 1"; Rec."VAT Base 1")
            {
                ApplicationArea = all;
            }
        }

        //  moveafter("Control 34"; "Control 62")
    }
}

