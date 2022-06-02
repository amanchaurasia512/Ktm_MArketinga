page 50009 "Document Correction Tool"
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
            group("Header ")
            {
                field("Purchase Invoice No."; DocumentNo)
                {
                    ApplicationArea = all;
                    TableRelation = "Purch. Inv. Header";
                }
                field("Document Type"; DocumentType)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Correction Type"; CorrectionType)
                {
                    ApplicationArea = all;
                }
            }
            group("Correction Date")
            {
                field("Enter the correct Posting Date"; CorrectDate)
                {
                    ApplicationArea = all;
                    Caption = 'Enter correct Posting Date';
                }
                field("Enter correct Pragayapanpatra"; CorrectPragyapanPatra)
                {
                    ApplicationArea = all;
                    TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST("PragyapanPatra"));
                }
                field("Enter correct VAT Base Amt 13%"; CorrectVATBase1)
                {
                    ApplicationArea = all;
                }
                field("Enter correct Exempt Amount"; CorrectExemptAmt)
                {
                    ApplicationArea = all;
                }
            }
            group("Localized VAT Correction")
            {
                Visible = false;
                field(DocumentNos; DocumentNos)
                {
                    ApplicationArea = all;
                    Caption = 'Document No.';
                    TableRelation = "Purch. Inv. Header";
                }
                field(LocalizedVATidentifier; LocalizedVATidentifier)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(CorrectData)
            {
                Image = ChangeTo;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to proceed?', TRUE) THEN BEGIN
                        CorrectPurchaseDocument(DocumentNo, CorrectionType);
                        MESSAGE('Process completed');
                    END ELSE
                        EXIT;
                end;
            }
            action("Update Localized VAT")
            {
                Caption = 'Update Localized VAT';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to proceed?', TRUE) THEN BEGIN
                        CorrectLoclizedVATIdentifier(DocumentNos, LocalizedVATidentifier);
                        MESSAGE('Process completed');
                    END ELSE
                        EXIT;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DocumentType := DocumentType::Purchase;
    end;

    var
        DocumentNo: Code[20];
        CorrectionType: Option " ","Posting Date",Pragyapanpatra,"VAT Base 1","Exempt Amount";
        DocumentType: Option " ",Purchase,Sales;
        CorrectDate: Date;
        CorrectPragyapanPatra: Code[20];
        CorrectVATBase1: Decimal;
        CorrectExemptAmt: Decimal;
        ChangeLogSetup: Record "Change Log Setup";
        DocumentNos: Text[250];
        LocalizedVATidentifier: Option " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";

    [Scope('Onprem')]
    procedure CorrectPurchaseDocument(DocNo: Code[20]; CorrectionType: Option " ","Posting Date",Pragyapanpatra,"VAT Base 1","Exempt Amount")
    var
        PurchInvHdr: Record "Purch. Inv. Header";
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
    begin
        IF CONFIRM('Do you want to make the changes to the document %1', TRUE, DocNo) THEN BEGIN
            ChangeLogSetup.RESET;
            IF ChangeLogSetup.FINDFIRST THEN BEGIN
                ChangeLogSetup."Change Log Activated" := FALSE;
                ChangeLogSetup.MODIFY;
            END;
            PurchInvHdr.RESET;
            PurchInvHdr.SETRANGE("No.", DocNo);
            IF PurchInvHdr.FINDFIRST THEN BEGIN
                IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                    PurchInvHdr."Posting Date" := CorrectDate;
                    PurchInvHdr."Order Date" := CorrectDate;
                    PurchInvHdr."Document Date" := CorrectDate;
                    PurchInvHdr."Due Date" := CorrectDate;
                    PurchInvHdr.MODIFY;
                END ELSE
                    IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                        PurchInvHdr.PragyapanPatra := CorrectPragyapanPatra;
                        PurchInvHdr.MODIFY;
                    END ELSE
                        IF CorrectionType = CorrectionType::"VAT Base 1" THEN BEGIN
                            PurchInvHdr."VAT Base 1" := CorrectVATBase1;
                            PurchInvHdr.MODIFY;
                        END ELSE
                            IF CorrectionType = CorrectionType::"Exempt Amount" THEN BEGIN
                                PurchInvHdr."Exempt Amount" := CorrectExemptAmt;
                                PurchInvHdr.MODIFY;
                            END;
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", PurchInvHdr."No.");
                IF PurchInvLine.FINDFIRST THEN
                    REPEAT
                        IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                            PurchInvLine."Posting Date" := PurchInvHdr."Posting Date";
                            PurchInvLine."Expected Receipt Date" := PurchInvHdr."Posting Date";
                            PurchInvLine.MODIFY;
                        END ELSE
                            IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                                PurchInvLine.PragyapanPatra := PurchInvLine.PragyapanPatra;
                                PurchInvLine.MODIFY;
                            END ELSE
                                IF (PurchInvLine.Type = PurchInvLine.Type::"G/L Account") AND (CorrectionType = CorrectionType::"VAT Base 1") THEN BEGIN
                                    PurchInvLine."VAT Base 1" := CorrectVATBase1;
                                    PurchInvLine.MODIFY;
                                END ELSE
                                    IF (PurchInvLine.Type = PurchInvLine.Type::"G/L Account") AND (CorrectionType = CorrectionType::"Exempt Amount") THEN BEGIN
                                        PurchInvLine."Exempt Amount" := PurchInvHdr."Exempt Amount";
                                        PurchInvLine.MODIFY;
                                    END;
                    UNTIL PurchInvLine.NEXT = 0;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETRANGE("Order No.", PurchInvHdr."Order No.");
                IF PurchRcptHdr.FINDFIRST THEN BEGIN
                    IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                        PurchRcptHdr."Posting Date" := PurchInvHdr."Posting Date";
                        PurchRcptHdr."Due Date" := PurchInvHdr."Posting Date";
                        PurchRcptHdr."Document Date" := PurchRcptHdr."Posting Date";
                        PurchRcptHdr."Order Date" := PurchRcptHdr."Posting Date";
                        PurchRcptHdr.MODIFY;
                    END ELSE
                        IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                            PurchRcptHdr.PragyapanPatra := PurchInvHdr.PragyapanPatra;
                            PurchRcptHdr.MODIFY;
                        END ELSE
                            IF CorrectionType = CorrectionType::"Exempt Amount" THEN BEGIN
                                PurchRcptHdr."Exempt Amount" := PurchInvHdr."Exempt Amount";
                                PurchRcptHdr.MODIFY;
                            END ELSE
                                IF CorrectionType = CorrectionType::"VAT Base 1" THEN BEGIN
                                    PurchRcptHdr."VAT Base 1" := CorrectVATBase1;
                                    PurchRcptHdr.MODIFY;
                                END;
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                                PurchRcptLine."Posting Date" := PurchInvHdr."Posting Date";
                                PurchRcptLine."Order Date" := PurchRcptHdr."Posting Date";
                                PurchRcptLine.MODIFY;
                            END ELSE
                                IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                                    PurchRcptLine.PragyapanPatra := PurchInvHdr.PragyapanPatra;
                                    PurchRcptLine.MODIFY;
                                END ELSE
                                    IF (CorrectionType = CorrectionType::"Exempt Amount") AND (PurchRcptLine.Type = PurchRcptLine.Type::"G/L Account") THEN BEGIN
                                        PurchRcptLine."Exempt Amount" := PurchInvHdr."Exempt Amount";
                                        PurchRcptLine.MODIFY;
                                    END ELSE
                                        IF (CorrectionType = CorrectionType::"VAT Base 1") AND (PurchRcptLine.Type = PurchRcptLine.Type::"G/L Account") THEN BEGIN
                                            PurchRcptLine."VAT Base 1" := CorrectVATBase1;
                                            PurchRcptLine.MODIFY;
                                        END;
                        UNTIL PurchRcptLine.NEXT = 0;
                END;
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", PurchInvHdr."No.");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                            GLEntry."Posting Date" := PurchInvHdr."Posting Date";
                            GLEntry."Document Date" := PurchInvHdr."Posting Date";
                            GLEntry.MODIFY;
                        END ELSE
                            IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                                GLEntry.PragyapanPatra := PurchInvHdr.PragyapanPatra;
                                GLEntry.MODIFY;
                            END ELSE
                                IF (CorrectionType = CorrectionType::"VAT Base 1") AND (GLEntry."Document Type" = GLEntry."Document Type"::Invoice) THEN BEGIN
                                    GLEntry."VAT Base 1" := CorrectVATBase1;
                                    GLEntry.MODIFY;
                                END ELSE
                                    IF (CorrectionType = CorrectionType::"VAT Base 1") AND (GLEntry."Document Type" = GLEntry."Document Type"::Invoice) THEN BEGIN
                                        GLEntry."Exempt Amount" := PurchInvHdr."Exempt Amount";
                                        GLEntry.MODIFY;
                                    END;
                    UNTIL GLEntry.NEXT = 0;

                VendLedgEntry.RESET;
                VendLedgEntry.SETFILTER("Document No.", PurchInvHdr."No.");
                IF VendLedgEntry.FINDFIRST THEN BEGIN
                    IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                        VendLedgEntry."Posting Date" := PurchInvHdr."Posting Date";
                        VendLedgEntry."Due Date" := PurchInvHdr."Posting Date";
                        VendLedgEntry."Document Date" := PurchInvHdr."Posting Date";
                        VendLedgEntry.MODIFY;
                    END;
                END;

                DetailedVendLedgEntry.RESET;
                DetailedVendLedgEntry.SETFILTER("Document No.", PurchInvHdr."No.");
                IF DetailedVendLedgEntry.FINDFIRST THEN BEGIN
                    IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                        DetailedVendLedgEntry."Posting Date" := PurchInvHdr."Posting Date";
                        DetailedVendLedgEntry.MODIFY;
                    END;
                END;

                ValueEntry.RESET;
                ValueEntry.SETFILTER("Document No.", PurchInvHdr."No.");
                IF ValueEntry.FINDFIRST THEN
                    REPEAT
                        IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                            ValueEntry."Posting Date" := PurchInvHdr."Posting Date";
                            ValueEntry."Document Date" := PurchInvHdr."Posting Date";
                            ValueEntry.MODIFY;
                        END ELSE
                            IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                                ValueEntry.PragyapanPatra := PurchInvHdr.PragyapanPatra;
                                ValueEntry.MODIFY;
                            END;
                        ItemLedgEntry.RESET;
                        ItemLedgEntry.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                        IF ItemLedgEntry.FINDFIRST THEN
                            REPEAT
                                IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                                    ItemLedgEntry."Posting Date" := PurchInvHdr."Posting Date";
                                    ItemLedgEntry."Document Date" := PurchInvHdr."Document Date";
                                    ItemLedgEntry.MODIFY;
                                END ELSE
                                    IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                                        ItemLedgEntry.PragyapanPatra := PurchInvHdr.PragyapanPatra;
                                        ItemLedgEntry.MODIFY;
                                    END;
                            UNTIL ItemLedgEntry.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", PurchInvHdr."No.");
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
                            VATEntry."Posting Date" := PurchInvHdr."Posting Date";
                            VATEntry."Document Date" := PurchInvHdr."Posting Date";
                            VATEntry.MODIFY;
                        END ELSE
                            IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
                                VATEntry.PragyapanPatra := PurchInvHdr.PragyapanPatra;
                                VATEntry.MODIFY;
                            END ELSE
                                IF CorrectionType = CorrectionType::"Exempt Amount" THEN BEGIN
                                    VATEntry."Exempt Amount" := PurchInvHdr."Exempt Amount";
                                    VATEntry.MODIFY;
                                END ELSE
                                    IF CorrectionType = CorrectionType::"VAT Base 1" THEN BEGIN
                                        VATEntry."VAT Base 1" := CorrectVATBase1;
                                        VATEntry.MODIFY;
                                    END;
                    UNTIL VATEntry.NEXT = 0;
                ChangeLogSetup."Change Log Activated" := TRUE;
                ChangeLogSetup.MODIFY;
            END;
        END ELSE
            EXIT;
    end;
    /*
        local procedure InsertDataCorrectionLog(TableID: Integer; DocumentNo: Code[20]; CorrectionType: Option " ","Posting Date",Pragyapanpatra,"VAT Base 1","Exempt Amount"; OldDate: Date; OldPP: Code[20]; OldVATBase13: Decimal; OldExemptAmt: Decimal)
        var
            LastEntryNo: Integer;
        begin
            LastEntryNo := 0;
            DataCorrectionLog.RESET;
            IF NOT DataCorrectionLog.FINDLAST THEN
              LastEntryNo := 1
            ELSE
              LastEntryNo := DataCorrectionLog."Entry No." + 1;

            DataCorrectionLog.INIT;
            DataCorrectionLog."Entry No." := LastEntryNo;
            DataCorrectionLog."Table ID" := TableID;
            DataCorrectionLog.CALCFIELDS("Table Name");
            DataCorrectionLog."Document No." := DocumentNo;
            DataCorrectionLog."Document Type" := DocumentType;
            DataCorrectionLog."Correction Date" := TODAY;
            DataCorrectionLog."Correction Time" := TIME;
            DataCorrectionLog."Correction Type" := CorrectionType;
            IF CorrectionType = CorrectionType::Pragyapanpatra THEN BEGIN
              DataCorrectionLog."Old Pragyapanpatra Value" := OldPP;
              DataCorrectionLog."New Pragyapanpatra Value" := CorrectPragyapanPatra;
            END ELSE IF CorrectionType = CorrectionType::"Posting Date" THEN BEGIN
              DataCorrectionLog."Old Posting Date Value" := OldDate;
              DataCorrectionLog."New Posting Date Value" := CorrectDate;
            END ELSE IF CorrectionType = CorrectionType::"VAT Base 1" THEN BEGIN
              DataCorrectionLog."Old VAT Base 13% Amt." := OldVATBase13;
              DataCorrectionLog."New VAT Base 13% Amt." := CorrectVATBase1;
            END ELSE IF CorrectionType = CorrectionType::"Exempt Amount" THEN BEGIN
              DataCorrectionLog."Old Exempt Amount" := OldExemptAmt;
              DataCorrectionLog."New Exempt Amount" := CorrectExemptAmt;
            END;
            DataCorrectionLog.INSERT;

        end;
    */// this full procedure is commented in ktm marketing
    local procedure CorrectLoclizedVATIdentifier(DocumentNo: Text[250]; LocalizedVATidentifier: Option)
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

        PurchInvHeader.RESET;
        PurchInvHeader.SETFILTER("No.", DocumentNo);
        IF PurchInvHeader.FINDFIRST THEN
            REPEAT
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                IF PurchInvLine.FINDFIRST THEN
                    REPEAT
                        PurchInvLine."Localized VAT Identifier" := LocalizedVATidentifier;
                        PurchInvLine.MODIFY;
                    UNTIL PurchInvLine.NEXT = 0;
                PurchRcptHdr.RESET;
                PurchRcptHdr.SETRANGE("Order No.", PurchInvHeader."Order No.");
                IF PurchRcptHdr.FINDFIRST THEN BEGIN
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHdr."No.");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            PurchRcptLine."Localized VAT Identifier" := LocalizedVATidentifier;
                            PurchRcptLine.MODIFY;
                        UNTIL PurchRcptLine.NEXT = 0;
                END;

                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", PurchInvHeader."No.");
                GLEntry.SETFILTER("Localized VAT Identifier", '<>%1', GLEntry."Localized VAT Identifier"::" ");
                IF GLEntry.FINDFIRST THEN
                    REPEAT
                        GLEntry."Localized VAT Identifier" := LocalizedVATidentifier;
                        IF GLEntry."G/L Account No." = '2262200' THEN
                            GLEntry."G/L Account No." := '2262100';
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;

                VATEntry.RESET;
                VATEntry.SETFILTER("Document No.", PurchInvHeader."No.");
                IF VATEntry.FINDFIRST THEN
                    REPEAT
                        VATEntry."Localized VAT Identifier" := LocalizedVATidentifier;
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0
UNTIL PurchInvHeader.NEXT = 0;

        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
    end;
}

