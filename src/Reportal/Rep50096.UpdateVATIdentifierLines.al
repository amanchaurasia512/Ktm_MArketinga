report 50096 "Update VAT Identifier Lines"
{
    Permissions = TableData 17 = rim,
                  TableData 121 = rim,
                  TableData 123 = rim,
                  TableData 254 = rim;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purch. Inv. Line";"Purch. Inv. Line")
        {

            trigger OnAfterGetRecord()
            begin
                CorrectLoclizedVATIdentifier(LocalizedVATidentifier, "Document No.", "Line No.");
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

    local procedure CorrectLoclizedVATIdentifier(VATidentifier: Option " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales"; DocumentNo: Code[20]; LineNo: Integer)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record  "Purch. Inv. Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
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
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Document No.", DocumentNo);
        PurchInvLine.SETRANGE("Line No.", LineNo);
        IF PurchInvLine.FINDFIRST THEN BEGIN
            PurchInvLine."Localized VAT Identifier" := VATidentifier;
            PurchInvLine."VAT Prod. Posting Group" := 'VAT00';
            PurchInvLine.MODIFY;
        END;
        MESSAGE('Executed Successfully');
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
    end;
}

