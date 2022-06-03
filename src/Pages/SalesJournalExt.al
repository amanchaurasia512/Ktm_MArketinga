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
            field("Party Type"; "Party Type")
            {
                ApplicationArea = All;
            }
            field("Party No."; "Party No.")
            {
                ApplicationArea = All;
            }
            field("Party Name"; "Party Name")
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
            field("TDS Group"; "TDS Group")
            {
                ApplicationArea = All;
            }
            field("TDS%"; "TDS%")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; "TDS Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bill-to/Pay-to No.")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field(Narration; Narration)
            {
                ApplicationArea = All;
            }
            field("Skip Document Type"; "Skip Document Type")
            {
                ApplicationArea = All;
            }

        }
        addafter("Bal. Account Name")
        { //verify
            group("Debiit Amount")
            {

                field("Debit Amount1"; "Debit Amount")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Debit Amount 1';
                }
                field("Credit Amount1"; "Credit Amount")
                {
                    ApplicationArea = All;
                }


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
        "Document Type" := "Document Type"::"Credit Memo";  //KMT2016CU5
    end;
}