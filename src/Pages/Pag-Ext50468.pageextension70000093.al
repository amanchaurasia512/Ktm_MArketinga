pageextension 50468 "pageextension70000093" extends "Serial No. Information Card"
{
    layout
    {
        // modify("Control 4")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            // field("Variant Code"; "Variant Code")
            // {
            //     ApplicationArea = Planning;
            //     ToolTip = 'Specifies the variant of the item on the line.';
            // }
            field("Body Color"; Rec."Body Color")
            {
                ApplicationArea = all;
            }
            field("Engine/Motor No."; Rec."Engine No.")
            {
                ApplicationArea = all;
            }
            field("Make Code"; Rec."Make Code")
            {
                ApplicationArea = all;
            }
            field("Model Code"; Rec."Model Code")
            {
                ApplicationArea = all;
            }
            field("Model Commercial Name"; Rec."Model Commercial Name")
            {
                ApplicationArea = all;
            }
            field("Registration No."; Rec."Registration No.")
            {
                ApplicationArea = all;
            }
            field("VIN/Frame No."; Rec.VIN)
            {
                ApplicationArea = all;
            }
        }
    }
}

