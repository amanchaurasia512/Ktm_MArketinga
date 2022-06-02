pageextension 50449 "pageextension70000067" extends "Employee Card"
{
    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 13".


        //Unsupported feature: Property Modification (ControlType) on "Control 13".


        //Unsupported feature: Property Insertion (SourceExpr) on "Control 13".


        //Unsupported feature: Property Modification (Level) on "Control 29".


        //Unsupported feature: Property Modification (Level) on "Control 82".


        //Unsupported feature: Property Modification (Level) on "ShowMap(Control 5)".


        //Unsupported feature: Property Deletion (GroupType) on "Control 13".

        addafter(Address)
        {
            field("Blood Group"; Rec."Blood Group")
            {
                ApplicationArea = all;
            }
            field("Marital Status"; Rec."Marital Status")
            {
                ApplicationArea = all;
            }
            field("Employement Start Date"; Rec."Employement Start Date")
            {
                ApplicationArea = all;
            }
            field("Employement End Date"; Rec."Employement End Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(content)
        {
            field("Vehicle Company Name"; Rec."Vehicle Company Name")
            {
                ApplicationArea = all;
            }
            field("Driving License No."; Rec."Driving License No.")
            {
                ApplicationArea = all;
            }
        }
        //moveafter("Control 1902768601"; Address)
    }
}

