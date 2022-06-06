pageextension 50520 "Sales Journal Ext" extends "Sales Journal"
{
    layout
    {

        // Add changes to page layout here
        modify("Document Type")
        {
            Visible = false;
        }
        modify("VAT Amount")
        {
            Visible = true;
            Editable = false;
        }
        addafter("Account No.")
        {
            //already defiened
            // field("Account Name"; "Account Name")
            // {
            //     ApplicationArea = All;
            // }
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Account Type")
        {
            Visible = false;
        }
        modify("Bal. Account No.")
        {
            Visible = false;
        }
        modify("Bill-to/Pay-to No.")
        {
            Editable = false;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = false;
        }
        modify("Applies-to Doc. Type")
        {
            Visible = false;
        }
        addafter(Description)
        {   //already defined in base
            // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            // {
            //     ApplicationArea = All;
            // }
            // field("Debit Amount"; "Debit Amount")
            // {
            //     ApplicationArea = All;
            // }
            // field("Credit Amount"; "Credit Amount")
            // {
            //     ApplicationArea = All;
            // }
            // field("Sales/Purch. (LCY)"; "Sales/Purch. (LCY)")
            // {
            //     ApplicationArea = All;
            // }
            // field("External Document No."; "External Document No.")
            // {
            //     ApplicationArea = All;
            // }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = All;
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = All;
            }
            field("Party Name"; Rec."Party Name")
            {
                ApplicationArea = All;
            }
            // field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            // {
            //     ApplicationArea = All;
            // }

            // field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            // {
            //     ApplicationArea = All;
            // }
            // field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            // {
            //     ApplicationArea = All;
            // }

        }
        addafter("VAT Amount")
        {
            field("TDS Group"; Rec."TDS Group")
            {
                ApplicationArea = All;
            }
            field("TDS%"; Rec."TDS%")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bill-to/Pay-to No.")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
            field("Skip Document Type"; Rec."Skip Document Type")
            {
                ApplicationArea = All;
            }

        }


    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        Rec."Document Type" := Rec."Document Type"::"Credit Memo";  //KMT2016CU5
    end;
}