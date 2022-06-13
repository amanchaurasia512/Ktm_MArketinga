report 50092 "Update Localized VAT identifie"
{
    Permissions = TableData 17 = rim,
                  TableData 121 = rim,
                  TableData 123 = rim,
                  TableData 254 = rim;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purch. Inv. Header";"Purch. Inv. Header")
        {

            trigger OnAfterGetRecord()
            begin
                CorrectLoclizedVATIdentifier(LocalizedVATidentifier, "No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(LocalizedVATidentifier; LocalizedVATidentifier)
                {
                    Caption = 'LocalizedVATidentifier';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF LocalizedVATidentifier = LocalizedVATidentifier::" " THEN
            ERROR('Please select Localized VAT Identifier.');
    end;

    var
        LocalizedVATidentifier: Option " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";

    local procedure CorrectLoclizedVATIdentifier(VATidentifier: Option " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales"; DocumentNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record  "VAT Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        AlLCustVendLedger: Record "Cust-Vend Ledger";
        Correctvendor: Record Vendor;
        ChangeLogSetup: Record "Change Log Setup";
    begin
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        PurchInvHeader.RESET;
        PurchInvHeader.SETFILTER("No.", DocumentNo);
        IF PurchInvHeader.FINDFIRST THEN
            REPEAT
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", DocumentNo);
                IF PurchInvLine.FINDFIRST THEN
                    REPEAT
                        PurchInvLine."Localized VAT Identifier" := VATidentifier;
                        PurchInvLine.MODIFY;
                    UNTIL PurchInvLine.NEXT = 0;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
                IF PurchRcptHdr.FINDFIRST THEN BEGIN
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            PurchRcptLine."Localized VAT Identifier" := VATidentifier;
                            PurchRcptLine.MODIFY;
                        UNTIL PurchRcptLine.NEXT = 0;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", DocumentNo);
                GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        GLEntry."Localized VAT Identifier" := VATidentifier;
                        IF GLEntry."G/L Account No." = '2262200' THEN
                            GLEntry."G/L Account No." := '2262100';
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", DocumentNo);
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        VATEntry."Localized VAT Identifier" := VATidentifier;
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0;

                MESSAGE('Executed Successfully');
            UNTIL PurchInvHeader.NEXT = 0;

        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
    end;
}

