pageextension 50456 "pageextension70000077" extends "Posted Transfer Shipment"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Transfer Shipment"(Page 5743)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Transfer Shipment"(Page 5743)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 3".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 3".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 3".


        //Unsupported feature: Property Deletion (Editable) on "Control 3".

        addlast(content)
        {
            field("DirectTransfer"; Rec."Direct Transfer")
            {
                ApplicationArea = Location;
                Editable = false;
                ToolTip = 'Specifies that the transfer does not use an in-transit location.';
            }
        }
        //moveafter("Control 6"; "Control 31")
    }
}

