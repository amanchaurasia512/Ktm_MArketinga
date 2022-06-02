page 50023 "Updt LC for Purch Credit Memo"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData 17 = rim,
                  TableData 25 = rim,
                  TableData 124 = rim,
                  TableData 125 = rim,
                  TableData 254 = rim,
                  TableData 380 = rim,
                  TableData 5802 = rim;
    SourceTable = "Purch. Cr. Memo Hdr.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = all;
                }
                field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                        GLEntry: Record "G/L Entry";
                        ValueEntry: Record "Value Entry";
                        PurchRcptHdr: Record "Purch. Rcpt. Header";
                        PurchRcptLine: Record "Purch. Rcpt. Line";
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        PurchInvLine: Record "Purch. Inv. Line";
                        VatEntry: Record "VAT Entry";
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                        DetailVendorLedger: Record "Detailed Vendor Ledg. Entry";
                        PurchMemoLine: Record "Purch. Cr. Memo Line";
                    begin
                        PurchMemoLine.RESET;
                        PurchMemoLine.SETRANGE("Document No.", Rec."No.");
                        IF PurchMemoLine.FINDFIRST THEN
                            REPEAT
                                PurchMemoLine."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                PurchMemoLine.MODIFY;
                            UNTIL PurchMemoLine.NEXT = 0;

                        GLEntry.RESET;
                        GLEntry.SETRANGE("Document No.", Rec."No.");
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::"Credit Memo");
                        IF GLEntry.FINDFIRST THEN
                            REPEAT
                                GLEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                GLEntry.MODIFY;
                            UNTIL GLEntry.NEXT = 0;

                        ValueEntry.RESET;
                        ValueEntry.SETRANGE("Document No.", Rec."No.");
                        IF ValueEntry.FINDFIRST THEN
                            REPEAT
                                ValueEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                ValueEntry.MODIFY;
                            UNTIL ValueEntry.NEXT = 0;

                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE("Document No.", Rec."No.");
                        IF ItemLedgerEntry.FINDFIRST THEN
                            REPEAT
                                ItemLedgerEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                ItemLedgerEntry.MODIFY;
                            UNTIL ItemLedgerEntry.NEXT = 0;

                        VatEntry.RESET;
                        VatEntry.SETRANGE("Document No.", Rec."No.");
                        IF VatEntry.FINDFIRST THEN
                            REPEAT
                                VatEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                VatEntry.MODIFY;
                            UNTIL VatEntry.NEXT = 0;

                        VendorLedgerEntry.RESET;
                        VendorLedgerEntry.SETRANGE("Document No.", Rec."No.");
                        IF VendorLedgerEntry.FINDFIRST THEN
                            REPEAT
                                VendorLedgerEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                VendorLedgerEntry.MODIFY;
                            UNTIL VendorLedgerEntry.NEXT = 0;

                        DetailVendorLedger.RESET;
                        DetailVendorLedger.SETRANGE("Document No.", Rec."No.");
                        IF DetailVendorLedger.FINDFIRST THEN
                            REPEAT
                                DetailVendorLedger."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                DetailVendorLedger.MODIFY;
                            UNTIL DetailVendorLedger.NEXT = 0;
                        MESSAGE('%1 of No. %2', Text001, Rec."Letter of Credit/Telex Trans.");
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'The LC number updated sucessfully.';
}

