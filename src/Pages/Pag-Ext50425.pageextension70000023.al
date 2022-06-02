pageextension 50425 "pageextension70000023" extends "Posted Purchase Receipts"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Purchase Receipts"(Page 145)".


    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Purchase Receipts"(Page 145)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Purchase Receipts"(Page 145)".

    layout
    {
        addlast(content)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
            field(Delete; Rec.Delete)
            {
                ApplicationArea = all;
            }
        }

    }
}

