pageextension 50423 "pageextension70000020" extends "Posted Sales Shipments"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Posted Sales Shipments"(Page 142)".


    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Shipments"(Page 142)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Sales Shipments"(Page 142)".

    layout
    {
        addlast(content)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
        }
    }
}

