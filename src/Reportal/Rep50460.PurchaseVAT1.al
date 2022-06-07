report 50460 "Purchase VAT 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseVAT1.rdlc';

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = WHERE(Type = CONST(Purchase));
            RequestFilterFields = "Posting Date", PragyapanPatra;
            column(EntryNo_VATEntry; "VAT Entry"."Entry No.")
            {
            }
            column(GenBusPostingGroup_VATEntry; "VAT Entry"."Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup_VATEntry; "VAT Entry"."Gen. Prod. Posting Group")
            {
            }
            column(PostingDate_VATEntry; "VAT Entry"."Posting Date")
            {
            }
            column(DocumentNo_VATEntry; "VAT Entry"."Document No.")
            {
            }
            column(DocumentType_VATEntry; "VAT Entry"."Document Type")
            {
            }
            column(Type_VATEntry; "VAT Entry".Type)
            {
            }
            column(Base_VATEntry; "VAT Entry".Base)
            {
            }
            column(Amount_VATEntry; "VAT Entry".Amount)
            {
            }
            column(ExternalDocumentNo_VATEntry; "VAT Entry"."External Document No.")
            {
            }
            column(DocumentDate_VATEntry; "VAT Entry"."Document Date")
            {
            }
            column(VATRegistrationNo_VATEntry; VATRegNo)
            {
            }
            column(PragyapanPatra_VATEntry; "VAT Entry".PragyapanPatra)
            {
            }
            column(NepaliDate_VATEntry; NepaliDate)
            {
            }
            column(LocalizedVATIdentifier_VATEntry; "VAT Entry"."Localized VAT Identifier")
            {
            }
            column(ExemptAmount_VATEntry; "VAT Entry"."Exempt Amount")
            {
            }
            column(VATBase1_VATEntry; "VAT Entry"."VAT Base 1")
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(SupplierName; SupplierName)
            {
            }
            column(ImportPurchAmount; ImportPurchAmount)
            {
            }
            column(ImportPurchVATAmount; ImportPurchVATAmount)
            {
            }
            column(CAPEXPurchAmount; CAPEXPurchAmount)
            {
            }
            column(CAPEXPurchVATAmount; CAPEXPurchVATAmount)
            {
            }
            column(LocalPurchAmount; LocalPurchAmount)
            {
            }
            column(LocalPurchVATAmount; LocalPurchVATAmount)
            {
            }
            column(ExemptPurchAmount; ExemptPurchAmount)
            {
            }
            column(ExemptPurchVATAmount; ExemptPurchVATAmount)
            {
            }
            column(CompanyInfo_VAT_Registration_No; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(TotalPurchaseAmount; TotalPurchaseAmount)
            {
            }
            column(TotalImportPurchAmount; TotalImportPurchAmount)
            {
            }
            column(ExemptPurchaseAmt; ExemptPurchaseAmt)
            {
            }
            column(CustomPostingDate; CustomPostingDate)
            {
            }
            column(GroupingText; GroupingText)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(DocNo);
                CLEAR(SupplierName);
                DocNo := "VAT Entry"."External Document No.";
                IF PragyapanPatra <> '' THEN
                    DocNo := PragyapanPatra
                ELSE
                    DocNo := "VAT Entry"."External Document No.";
                IF ("VAT Entry"."VAT Bus. Posting Group" = 'PUR-LOCAL') AND ("VAT Entry"."VAT Prod. Posting Group" = 'VAT00') THEN //aakrista
                    DocNo := "VAT Entry"."External Document No.";
                IF "VAT Entry".PragyapanPatra = '' THEN
                    GroupingText := "VAT Entry"."Bill-to/Pay-to No." + "VAT Entry"."Document No."
                ELSE
                    IF "VAT Entry"."Exclude PP in VAT Book" THEN  //SRT Sept 3rd 2019
                        GroupingText := "VAT Entry"."External Document No."
                    ELSE BEGIN
                        GroupingText := PragyapanPatra + "VAT Entry"."External Document No.";
                    END;

                IF ("VAT Entry".PragyapanPatra <> '') AND
                   ("Localized VAT Identifier" = "Localized VAT Identifier"::"Taxable Local Purchase") THEN
                    DocNo := "VAT Entry"."External Document No.";

                GroupingText := DocNo; //aakrista
                Vendor.RESET;
                Vendor.SETRANGE("No.", "Bill-to/Pay-to No.");
                IF Vendor.FINDFIRST THEN BEGIN
                    SupplierName := Vendor.Name;
                    VATRegNo := Vendor."VAT Registration No.";
                END;

                IF "VAT Entry"."Free Item Vendor No." <> '' THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", "VAT Entry"."Free Item Vendor No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        SupplierName := Vendor.Name;
                        VATRegNo := Vendor."VAT Registration No.";
                    END;
                END;
                //KMT2016CU5 >>
                //IF "VAT Entry".PragyapanPatra = '17BHW-M82039' THEN BEGIN
                IF "VAT Entry"."VAT Bus. Posting Group" = 'PUR-CUSTOM' THEN BEGIN
                    ValueEntry.RESET;
                    ValueEntry.SETRANGE("Document No.", "Document No.");
                    IF ValueEntry.FINDFIRST THEN BEGIN
                        ILE.RESET;
                        ILE.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                        IF ILE.FINDFIRST THEN BEGIN
                            Vendor.GET(ILE."Source No.");
                            SupplierName := Vendor.Name;
                            VATRegNo := Vendor."VAT Registration No.";
                        END;
                    END;
                END;
                //SRT Sept 3rd 2019 >>
                //IF "VAT Entry"."Exclude PP in VAT Book" OR (("VAT Entry".PragyapanPatra <> '') AND ("VAT Entry"."VAT Bus. Posting Group" = 'PUR-LOCAL')) THEN BEGIN
                IF "VAT Entry"."Exclude PP in VAT Book" THEN BEGIN
                    DocNo := "VAT Entry"."External Document No.";
                    Vendor.RESET;
                    Vendor.SETRANGE("No.", "Bill-to/Pay-to No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        SupplierName := Vendor.Name;
                        VATRegNo := Vendor."VAT Registration No.";
                    END;
                END;
                //SRT Sept 3rd 2019 <<
                //KMT2016CU5 <<
                CLEAR(ImportPurchAmount);
                CLEAR(ImportPurchVATAmount);
                CLEAR(ExemptPurchAmount);
                CLEAR(ExemptPurchVATAmount);
                CLEAR(CAPEXPurchAmount);
                CLEAR(CAPEXPurchVATAmount);
                CLEAR(LocalPurchAmount);
                CLEAR(LocalPurchVATAmount);
                CLEAR(ExemptPurchaseAmt);

                IF "Localized VAT Identifier" = "Localized VAT Identifier"::"Taxable Import Purchase" THEN BEGIN
                    /*IF ImportPurchaseVATBase THEN  BEGIN
                      ImportPurchAmount := "VAT Entry"."VAT Base 1";
                      ImportPurchVATAmount := "VAT Entry".Amount;
                      IF "VAT Entry"."Exempt Amount" > 0 THEN
                        ExemptPurchAmount := "VAT Entry"."Exempt Amount";
                    END ELSE BEGIN
                    */

                    IF (Amount > 0) AND ("VAT Entry"."VAT Calculation Type" <> "VAT Entry"."VAT Calculation Type"::"Full VAT") THEN BEGIN
                        ImportPurchAmount := "VAT Entry"."VAT Base 1";
                        ImportPurchVATAmount := "VAT Entry".Amount;
                        //IF "VAT Entry"."VAT Calculation Type" <> "VAT Entry"."VAT Calculation Type"::"Full VAT" > 0 THEN
                        //ExemptPurchAmount := "VAT Entry"."Exempt Amount";
                    END ELSE

                        IF "VAT Entry"."VAT Calculation Type" = "VAT Entry"."VAT Calculation Type"::"Full VAT" THEN BEGIN
                            ImportPurchAmount := "VAT Entry"."VAT Base 1";
                            ImportPurchVATAmount := "VAT Entry".Amount;
                            IF "VAT Entry"."Exempt Amount" > 0 THEN
                                ExemptPurchAmount := "VAT Entry"."Exempt Amount";
                        END;
                    //TotalPurchaseAmount := ImportPurchAmount + ExemptPurchAmount;
                END ELSE
                    IF "Localized VAT Identifier" = "Localized VAT Identifier"::"Exempt Purchase" THEN BEGIN
                        IF ("VAT Entry".PragyapanPatra = '') OR (("VAT Entry"."VAT Bus. Posting Group" = 'PUR-LOCAL') AND ("VAT Entry"."VAT Prod. Posting Group" = 'VAT00')) THEN BEGIN
                            ExemptPurchAmount := "VAT Entry".Base;
                            ExemptPurchVATAmount := "VAT Entry".Amount;
                        END

                    END ELSE
                        IF "Localized VAT Identifier" = "Localized VAT Identifier"::"Taxable Local Purchase" THEN BEGIN
                            LocalPurchAmount := "VAT Entry".Base;
                            LocalPurchVATAmount := "VAT Entry".Amount;
                        END ELSE
                            IF "Localized VAT Identifier" = "Localized VAT Identifier"::"Taxable Capex Purchase" THEN BEGIN
                                CAPEXPurchAmount := "VAT Entry".Base;
                                CAPEXPurchVATAmount := "VAT Entry".Amount;
                            END;
                TotalPurchaseAmount := ImportPurchAmount + CAPEXPurchAmount + LocalPurchAmount + ExemptPurchAmount;
                NepaliDate := SystemManagement.getNepaliDate("Posting Date");

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Import Purchase VAT Base"; ImportPurchaseVATBase)
                    {
                        Caption = 'Import Purchase VAT Base (13%)';
                        Visible = true;
                    }
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
        CompanyInfo.GET;
        CLEAR(PostingDate);
        PostingDate := "VAT Entry".GETFILTER("Posting Date");
        //KMT2016CU5 >>
        StartDateNep := '';
        EndDateNep := '';
        StartEngDate := 0D;
        EndEngDate := 0D;
        IF PostingDate <> '' THEN BEGIN
            StartEngDate := "VAT Entry".GETRANGEMIN("Posting Date");
            EndEngDate := "VAT Entry".GETRANGEMAX("Posting Date");
            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", StartEngDate);
            IF NepaliCal.FINDFIRST THEN
                StartDateNep := NepaliCal."Nepali Date";

            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", EndEngDate);
            IF NepaliCal.FINDFIRST THEN
                EndDateNep := NepaliCal."Nepali Date";
        END;
        //KMT2016CU5 <<
    end;

    var
        DocNo: Code[100];
        Vendor: Record Vendor;
        SupplierName: Text[100];
        ImportPurchAmount: Decimal;
        ImportPurchVATAmount: Decimal;
        CAPEXPurchAmount: Decimal;
        CAPEXPurchVATAmount: Decimal;
        LocalPurchAmount: Decimal;
        LocalPurchVATAmount: Decimal;
        ExemptPurchAmount: Decimal;
        ExemptPurchVATAmount: Decimal;
        CompanyInfo: Record "Company Information";
        PostingDate: Text[100];
        ImportPurchaseVATBase: Boolean;
        TotalPurchaseAmount: Decimal;
        NepaliDate: Text;
        SystemManagement: Codeunit "IRD Mgt.";
        ExemptPurchaseAmt: Decimal;
        TotalImportPurchAmount: Decimal;
        CustomPostingDate: Date;
        GroupingText: Text;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        ValueEntry: Record "Value Entry";
        ILE: Record "Item Ledger Entry";
        VATRegNo: Code[30];
}

