pageextension 50415 "pageextension70000007" extends "Cust. Ledg. Entries Preview"
{
    layout
    {
        addlast(content)
        {
            field("Sales (LCY)"; Rec."Sales (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}

