pageextension 50413 "pageextension70000005" extends "General Ledger Setup"
{
    layout
    {

        //Unsupported feature: Property Insertion (Name) on "Control 67".

        // modify("Control 10")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            // field("Bank Account Nos."; "Bank Account Nos.")
            // {
            //     ApplicationArea = Basic, Suite;  // already defined filed 
            //     ToolTip = 'Specifies the code for the number series that will be used to assign numbers to bank accounts.';
            // }

            field("VAT Lock Date"; Rec."VAT Lock Date")
            {
                ToolTip = 'The setup is to control back date vat entries for purchase entered from journal if the vat is already booked';
                ApplicationArea = all;
            }
        }

    }
}

