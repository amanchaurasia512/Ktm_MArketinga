pageextension 50433 "pageextension70000039" extends "Vendor List"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 32".

        // modify("Control 32.OnDrillDown")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 32".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 32".

        // modify("Control 34")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            // field("Balance (LCY)"; "Balance (LCY)")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.';

            //     trigger OnDrillDown()
            //     begin
            //         OpenVendorLedgerEntries(FALSE);
            //     end;
            // }
            // field("Balance Due (LCY)"; "Balance Due (LCY)")      //already defined
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all open purchase invoices and credit memos.';

            //     trigger OnDrillDown()
            //     begin
            //         OpenVendorLedgerEntries(TRUE);
            //     end;
            // }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = all;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = all;
            }
            field("Balance Due"; Rec."Balance Due")
            {
                ApplicationArea = all;
            }
        }
        //moveafter("Control 1102601012"; "Control 61")
    }
}

