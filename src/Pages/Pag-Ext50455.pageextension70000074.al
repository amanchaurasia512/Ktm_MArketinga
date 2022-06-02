pageextension 50455 "pageextension70000074" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 3".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 5".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 3".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 3".


        //Unsupported feature: Property Deletion (Visible) on "Control 3".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 5".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 5".


        //Unsupported feature: Property Deletion (Visible) on "Control 5".

        addlast(content)
        {
            field("DebitAmount"; Rec."Debit Amount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                //Visible = DebitCreditVisible;
            }
            field("CreditAmount"; Rec."Credit Amount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                //Visible = DebitCreditVisible;
            }
        }
        // moveafter("Control 16"; "Control 7")
        // moveafter("Control 7"; "Control 9")
    }
}

