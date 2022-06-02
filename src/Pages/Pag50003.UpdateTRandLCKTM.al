/// <summary>
/// Page Update TR and LC (ID 50003).
/// </summary>
page 50003 "Update TR and LC"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData 17 = rimd;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
                {
                    ApplicationArea = all;
                }
                field(Loan; Rec.Loan)
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

