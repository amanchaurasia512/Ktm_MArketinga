pageextension 50533 "Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //KMT2016CU5 >>
                IF Rec.Type = Rec.Type::Item THEN
                    CompareVatProdPostingGr(Rec);
                //KMT2016CU5 <<
            end;
        }
        addafter(Description)
        {   //already defeined
            // field("Description 2"; "Description 2")
            // {
            //     ApplicationArea = All;
            // }
        }

    }

    actions
    {
        // Add changes to page actions here
    }
    PROCEDURE CompareVatProdPostingGr(SalesLine: Record "Sales Line");
    VAR
        Item: Record Item;
    BEGIN
        Item.RESET;
        SalesLine.SETRANGE("Document Type", Rec."Document Type"::Order);
        SalesLine.SETRANGE("Document No.", SalesLine."Document No.");
        IF SalesLine.FIND('-') THEN BEGIN
            Item.SETRANGE("No.", Rec."No.");
            IF Item.FINDFIRST THEN BEGIN
                IF Item."VAT Prod. Posting Group" <> SalesLine."VAT Prod. Posting Group" THEN
                    ERROR(Text002);
            END;
        END;
    END;

    var
        myInt: Integer;
        Text002: TextConst ENU = 'You must insert the item having same Vat. Prod. Posting Group';
}