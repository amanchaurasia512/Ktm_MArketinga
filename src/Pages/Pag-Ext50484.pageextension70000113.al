pageextension 50484 "pageextension70000113" extends "Accounting Manager Role Center"
{
    actions
    {
        addlast(creation)
        {
            action(BankReceipts)
            {
                Caption = 'Bank Receipts';
                RunObject = Page 50008;
                Visible = false;
            }
            action(BankTransfer)
            {
                Caption = 'Bank Transfer';
                RunObject = Page 50007;
                Visible = false;
            }
        }
    }
}

