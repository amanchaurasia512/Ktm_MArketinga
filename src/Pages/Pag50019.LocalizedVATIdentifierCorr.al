page 50019 "Localized VAT Identifier Corr."
{
    PageType = Card;
    Permissions = TableData 17 = rm,
                  TableData 21 = rm,
                  TableData 25 = rm,
                  TableData 32 = rm,
                  TableData 110 = rm,
                  TableData 111 = rm,
                  TableData 112 = rm,
                  TableData 113 = rm,
                  TableData 114 = rm,
                  TableData 115 = rm,
                  TableData 120 = rm,
                  TableData 121 = rm,
                  TableData 122 = rm,
                  TableData 123 = rm,
                  TableData 124 = rm,
                  TableData 125 = rm,
                  TableData 254 = rm,
                  TableData 379 = rm,
                  TableData 380 = rm,
                  TableData 5802 = rm;

    layout
    {
        area(content)
        {
            group(Correction)
            {
                Caption = 'Correction';
                field(DocumentNos; DocumentNos)
                {
                    ApplicationArea = all;
                    Caption = 'Document No.';
                    TableRelation = "Purch. Inv. Header";
                }
                field(LocalizedVATidentifier; LocalizedVATidentifier)
                {
                    ApplicationArea = all;
                    Caption = 'LocalizedVATidentifier';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Update)
            {
                Caption = 'Update';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to proceed?', TRUE) THEN BEGIN
                        CorrectLoclizedVATIdentifier(DocumentNos);
                        MESSAGE('Process completed');
                    END ELSE
                        EXIT;

                end;
            }
            action("Correct All VAT")
            {

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to proceed?', TRUE) THEN BEGIN
                        VATcorrection(DocumentNos);
                        MESSAGE('Process completed');
                    END ELSE
                        EXIT;
                end;
            }
        }
    }

    var
        DocumentNos: Text[250];
        PurchInvLine: Record "Purch. Inv. Line";
        VATPostingSetup: Record "VAT Posting Setup";
        LocalizedVATidentifier: Option " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";

    local procedure CorrectLoclizedVATIdentifier(DocumentNo: Text[250])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
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

        IF (DocumentNo = '') THEN
            ERROR('DocumentNo Cannot be blank');
        PurchInvHeader.RESET;
        PurchInvHeader.SETFILTER("No.", DocumentNo);
        IF PurchInvHeader.FINDFIRST THEN
            REPEAT
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                IF PurchInvLine.FINDFIRST THEN
                    REPEAT
                        PurchInvLine."Localized VAT Identifier" := PurchInvLine."Localized VAT Identifier"::"Taxable Local Purchase";
                        PurchInvLine.MODIFY;
                    UNTIL PurchInvLine.NEXT = 0;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
                IF PurchRcptHdr.FINDFIRST THEN BEGIN
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            PurchRcptLine."Localized VAT Identifier" := PurchRcptLine."Localized VAT Identifier"::"Taxable Local Purchase";
                            PurchRcptLine.MODIFY;
                        UNTIL PurchRcptLine.NEXT = 0;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
                GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        GLEntry."Localized VAT Identifier" := GLEntry."Localized VAT Identifier"::"Taxable Local Purchase";
                        IF GLEntry."G/L Account No." = '2262200' THEN
                            GLEntry."G/L Account No." := '2262100';
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        VATEntry."Localized VAT Identifier" := VATEntry."Localized VAT Identifier"::"Taxable Local Purchase";
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0
UNTIL PurchInvHeader.NEXT = 0;

        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
    end;

    local procedure VATcorrection(DocumentNo: Text[250])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
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
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Document No.", 'PPI73/74-00002');
        IF PurchInvLine.FINDFIRST THEN
            REPEAT
                VATPostingSetup.RESET;
                VATPostingSetup.SETRANGE("VAT Prod. Posting Group", PurchInvLine."VAT Prod. Posting Group");
                VATPostingSetup.SETRANGE("VAT Bus. Posting Group", PurchInvLine."VAT Bus. Posting Group");
                VATPostingSetup.SETRANGE("VAT Identifier", PurchInvLine."VAT Identifier");
                IF VATPostingSetup.FINDFIRST THEN BEGIN
                    PurchInvLine."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
                    PurchInvLine.MODIFY;
                END;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETRANGE("Order No.", PurchInvLine."Document No.");
                IF PurchRcptHdr.FINDFIRST THEN BEGIN
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            PurchRcptLine."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
                            PurchRcptLine.MODIFY;
                        UNTIL PurchRcptLine.NEXT = 0;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", PurchInvLine."Document No.");
                GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        GLEntry."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
                        IF GLEntry."G/L Account No." = '2262200' THEN
                            GLEntry."G/L Account No." := '2262100';
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", PurchInvLine."Document No.");
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        VATEntry."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0
UNTIL PurchInvLine.NEXT = 0;
    end;
}

