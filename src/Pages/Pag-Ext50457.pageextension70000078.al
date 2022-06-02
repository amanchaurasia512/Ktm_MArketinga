pageextension 50457 "pageextension70000078" extends "Posted Transfer Receipt"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Transfer Receipt"(Page 5745)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Transfer Receipt"(Page 5745)".

    layout
    {
        // modify("Control 3")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            field("Direct Transfer_ktm"; Rec."Direct Transfer")
            {
                ApplicationArea = Location;
                Editable = false;
                ToolTip = 'Specifies that the transfer does not use an in-transit location.';
            }
            field("Source Document No."; Rec."Source Document No.")
            {
            }
        }

    }
    actions
    {
        addlast(Creation)
        {
            action("Send to Item Journal")
            {

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to send to item Journal?') THEN
                        EXIT;
                    //IRDMgt.CreateItemJnlAfterTransferReceive(Rec, TRUE);
                end;
            }
        }
    }


    //Unsupported feature: Property Modification (Id) on "FormatAddress(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //FormatAddress : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //FormatAddress : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsFromCountyVisible(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsFromCountyVisible : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsFromCountyVisible : 1997;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsToCountyVisible(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsToCountyVisible : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsToCountyVisible : 1998;
    //Variable type has not been exported.

    var
        IRDMgt: Codeunit "IRD Mgt.";
}

