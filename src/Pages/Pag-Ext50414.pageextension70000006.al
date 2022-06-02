pageextension 50414 "pageextension70000006" extends "User Setup"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 5".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 5".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 5".

        addlast(content)
        {
            // field("Salespers./Purch. Code"; "Salespers./Purch. Code")  //allready defined
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the code for the salesperson or purchaser for the user.';
            // }
        }
        addafter(Email)
        {
            field("Can Manage Template"; Rec."Can Manage Template")
            {
                ApplicationArea = all;
            }
            field("Allow TDS A/C Direct Posting"; Rec."Allow TDS A/C Direct Posting")
            {
                ApplicationArea = all;
            }
            field("Blank IRD Voucher No."; Rec."Blank IRD Voucher No.")
            {
                ApplicationArea = all;
            }
            field("Can Delete Purchase Order"; Rec."Can Delete Purchase Order")
            {
                ApplicationArea = all;
            }
            field("Skip Diff Product Segment Code"; Rec."Skip Diff Product Segment Code")
            {
                ApplicationArea = all;
            }
        }
        //moveafter("Control 8"; "Control 15")
    }
}

