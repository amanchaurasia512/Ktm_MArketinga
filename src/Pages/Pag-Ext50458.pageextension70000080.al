pageextension 50458 "pageextension70000080" extends "Item Charges"
{
    layout
    {
        addlast(content)
        {
            field("Include in Purchase Amount"; Rec."Include in Purchase Amount")
            {
                ApplicationArea = all;
            }
            field("Exclude PP in VAT Book"; Rec."Exclude PP in VAT Book")
            {
                ApplicationArea = all;
                ToolTip = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
            }
            field("Applicable TDS Posting Groups"; Rec."Applicable TDS Posting Groups")
            {
                ApplicationArea = all;
                ToolTip = 'to define what are tds posting group that can be used for selected item charge in purchase line';
            }
            field("Show in VAT Book"; Rec."Show in VAT Book")
            {
                ApplicationArea = all;
            }
        }
    }
}

