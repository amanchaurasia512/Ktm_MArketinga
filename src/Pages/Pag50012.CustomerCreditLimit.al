page 50012 "Customer Credit Limit"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Customer Credit Limit Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field("Skip Credit Limit Control"; Rec."Skip Credit Limit Control")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

