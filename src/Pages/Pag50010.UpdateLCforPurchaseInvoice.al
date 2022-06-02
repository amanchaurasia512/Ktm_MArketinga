page 50010 "Update LC for Purchase Invoice"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData 17 = rimd,
                  TableData 25 = rimd,
                  TableData 32 = rimd,
                  TableData 120 = rimd,
                  TableData 121 = rimd,
                  TableData 122 = rimd,
                  TableData 123 = rimd,
                  TableData 254 = rimd,
                  TableData 380 = rimd,
                  TableData 5802 = rimd;
    SourceTable = "Purch. Inv. Header";

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
                    begin
                        PurchInvLine.RESET;
                        PurchInvLine.SETRANGE("Document No.", Rec."No.");
                        IF PurchInvLine.FINDFIRST THEN
                            REPEAT
                                PurchInvLine."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                PurchInvLine.MODIFY;
                            UNTIL PurchInvLine.NEXT = 0;

                        GLEntry.RESET;
                        GLEntry.SETRANGE("Document No.", Rec."No.");
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
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

                        PurchRcptHdr.RESET;
                        PurchRcptHdr.SETRANGE("Order No.", Rec."Order No.");
                        IF PurchRcptHdr.FINDFIRST THEN
                            REPEAT
                                PurchRcptHdr."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                PurchRcptHdr.MODIFY;
                                PurchRcptLine.RESET;
                                PurchRcptLine.SETRANGE("No.", PurchRcptHdr."No.");
                                IF PurchRcptLine.FINDFIRST THEN
                                    REPEAT
                                        PurchRcptLine."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                        PurchRcptLine.MODIFY;
                                    UNTIL PurchRcptLine.NEXT = 0;

                                ItemLedgerEntry.RESET;
                                ItemLedgerEntry.SETRANGE("Document No.", PurchRcptHdr."No.");
                                IF ItemLedgerEntry.FINDFIRST THEN
                                    REPEAT
                                        ItemLedgerEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                        ItemLedgerEntry.MODIFY;

                                    UNTIL ItemLedgerEntry.NEXT = 0;

                                ValueEntry.RESET;
                                ValueEntry.SETRANGE("Document No.", PurchRcptHdr."No.");
                                IF ValueEntry.FINDFIRST THEN
                                    REPEAT
                                        ValueEntry."Letter of Credit/Telex Trans." := Rec."Letter of Credit/Telex Trans.";
                                        ValueEntry.MODIFY;
                                    UNTIL ValueEntry.NEXT = 0;
                            UNTIL PurchRcptHdr.NEXT = 0;

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
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

