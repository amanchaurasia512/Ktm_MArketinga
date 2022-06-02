pageextension 50460 "pageextension70000084" extends "Purch. Receipt Lines"
{
    layout
    {
        addlast(content)
        {
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = all;
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = all;
            }
            field(TotalCost; TotalCost)
            {
                ApplicationArea = all;
                Caption = 'Total Cost';
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ApplicationArea = all;
            }
        }

    }

    var
        TotalCost: Decimal;
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntries: Record "Value Entry";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DocumentNoHideValue := FALSE;
    DocumentNoOnFormat;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    DocumentNoHideValue := FALSE;
    DocumentNoOnFormat;
    TotalCost := Quantity * "Unit Cost"; //KMT2016CU5
    */
    //end;
}

