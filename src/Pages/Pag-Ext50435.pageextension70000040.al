pageextension 50435 "pageextension70000040" extends "Vendor Ledger Entries"
{
    Editable = false;

    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Vendor Ledger Entries"(Page 29)".

    layout
    {
        // modify("Control 21")
        // {
        //     Visible = false;
        // }
        // modify("Control 23")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
            }

            field(PragyapanPatra; Rec.PragyapanPatra)
            {
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
            }
            // field("Debit Amount (LCY)"; "Debit Amount (LCY)")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the total of the ledger entries that represent debits, expressed in LCY.';
            //     Visible = DebitCreditVisible;
            // }
            //  field("Credit Amount (LCY)"; "Credit Amount (LCY)")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the total of the ledger entries that represent credits, expressed in LCY.';
            //     Visible = DebitCreditVisible;
            // }
            field("Purchase (LCY)"; Rec."Purchase (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(ReverseTransaction)
        {
            Visible = false;
        }
        addafter(ReverseTransaction)
        {
            action("Credit Note ")
            {
                Caption = 'Credit Note';
                Image = ValueLedger;
                Promoted = false;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Document No.");
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUN(50024, TRUE, FALSE, GLEntry);
                end;
            }
            action("Debit Note")
            {
                Caption = 'Debit Note';
                Image = ValueLedger;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("Document No.");
                    GLEntry.SETRANGE("Document No.", Rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN
                        REPORT.RUN(50025, TRUE, FALSE, GLEntry);
                end;
            }
        }
    }
}

