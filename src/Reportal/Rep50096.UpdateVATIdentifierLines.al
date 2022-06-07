report 50096 "Update VAT Identifier Lines"
{
    Permissions = TableData 17 = rim,
                  TableData 121 = rim,
                  TableData 123 = rim,
                  TableData 254 = rim;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1; Table123)
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
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        ItemLedgEntry: Record "32";
        ValueEntry: Record "5802";
        CustLedgEntry: Record "21";
        GLEntry: Record "17";
        VATEntry: Record "254";
        VendLedgEntry: Record "25";
        DetailedVendLedgEntry: Record "380";
        PurchRcptHdr: Record "120";
        PurchRcptLine: Record "121";
        AlLCustVendLedger: Record "50004";
        Correctvendor: Record "23";
        ChangeLogSetup: Record "402";
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

