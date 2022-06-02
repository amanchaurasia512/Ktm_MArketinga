pageextension 50440 "pageextension70000049" extends "Purchase Order Statistics"
{
    layout
    {
        addlast(content)
        {
            field("TDS Amount"; TotalPurchLine[1]."TDS Amount")
            {
                ApplicationArea = all;
                Caption = 'TDS Amount';
                Editable = false;
            }
        }
    }
}

