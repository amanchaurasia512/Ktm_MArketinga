pageextension 50524 "Item Card Ext" extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
            }

        }
        addafter("Base Unit of Measure")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Created From Nonstock Item")
        {
            field("Sub-Category"; Rec."Sub-Category")
            {
                ApplicationArea = All;
            }

        }
        addafter(PreventNegInventoryDefaultNo)
        {       //already defiend
            // field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = All;
            //     Importance = Promoted;
            //     ShowMandatory = true;
            // }
            // field("Inventory Posting Group"; "Inventory Posting Group")
            // {
            //     ApplicationArea = All;
            //     Importance = Promoted;
            //     ShowMandatory = true;
            // }
        }
        addafter("Costing Method")
        {       //already defined
            // field("Sales Unit of Measure"; "Sales Unit of Measure")
            // {
            //     ApplicationArea = All;
            // }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ApplicationArea = All;
            }
            field("Free Item"; Rec."Free Item")
            {
                ApplicationArea = all;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        IsVisible: Boolean;
    begin
        IF Rec."Global Dimension 1 Code" = 'RBI' THEN
            IsVisible := TRUE;
    end;

    var
        myInt: Integer;
}