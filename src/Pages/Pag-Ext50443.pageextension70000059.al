pageextension 50443 "pageextension70000059" extends "VAT Posting Setup"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 7".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 7".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 7".

        addlast(content)
        {
            // field(Description; Description)
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies a description of the VAT posting setup';
            // }
            field("Localized VAT Identifier2"; Rec."Localized VAT Identifier2")
            {
            }
        }
        //moveafter("Control 4"; "Control 20")
    }
}

