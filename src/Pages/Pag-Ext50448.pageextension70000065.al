pageextension 50448 "pageextension70000065" extends "Purchase Lines"
{
    layout
    {
        addlast(content)
        {
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = all;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = all;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = all;
            }
        }
    }
}

