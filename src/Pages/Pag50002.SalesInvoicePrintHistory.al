page 50002 "Sales Invoice Print History"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Invoice Print History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Times Printed"; Rec."Times Printed")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Printing Date"; Rec."Printing Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Printed Time"; Rec."Printed Time")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Printed By"; Rec."Printed By")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

