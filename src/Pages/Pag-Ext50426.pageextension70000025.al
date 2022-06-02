pageextension 50426 "pageextension70000025" extends "Posted Purchase Credit Memos"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Purchase Credit Memos"(Page 147)".


    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Purchase Credit Memos"(Page 147)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Purchase Credit Memos"(Page 147)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 7".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 7".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 7".

        addlast(content)
        {
            // field("Due Date"; "Due Date") //already defined filed
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies when the credit memo is due. The program calculates the date using the Payment Terms Code and Posting Date fields on the purchase header.';
            // }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
        }

        // moveafter("Control 35"; "Control 13")
    }
}

