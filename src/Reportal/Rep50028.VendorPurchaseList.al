report 50028 "Vendor Purchase List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VendorPurchaseList.rdlc';
    Caption = 'Vendor - Purchase List';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Date Filter";
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(MinAmtLCY; MinAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(HideAddr; HideAddr)
            {
            }
            column(TableCaptVendFilter; TABLECAPTION + ': ' + VendFilter)
            {
            }
            column(VendFilter; VendFilter)
            {
            }
            column(VendNo; "No.")
            {
                IncludeCaption = true;
            }
            column(VendName; Name)
            {
                IncludeCaption = true;
            }
            column(VendVATRegNo; "VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(AmtPurchLCY; AmtPurchLCY)
            {
                AutoFormatType = 1;
            }
            column(VendAddr2; VendorAddr[2])
            {
            }
            column(VendAddr3; VendorAddr[3])
            {
            }
            column(VendAddr4; VendorAddr[4])
            {
            }
            column(VendAddr5; VendorAddr[5])
            {
            }
            column(VendAddr6; VendorAddr[6])
            {
            }
            column(VendAddr7; VendorAddr[7])
            {
            }
            column(VendAddr8; VendorAddr[8])
            {
            }
            column(VendPurchListCapt; VendPurchListCaptLbl)
            {
            }
            column(CurrRptPageNoCapt; CurrRptPageNoCaptLbl)
            {
            }
            column(MinAmtLCYCapt; MinAmtLCYCaptLbl)
            {
            }
            column(AmtPurchLCYCapt; AmtPurchLCYCaptLbl)
            {
            }
            column(TotRptedAmtofPurchLCYCapt; TotRptedAmtofPurchLCYCaptLbl)
            {
            }
            column(TradeNameType; TradeNameType)
            {
            }
            column(PurchaseOrSale; "Purchase/Sale")
            {
            }
            column(ExemptAmt; ExemptAmt)
            {
            }
            column(TaxableAmt; TaxableAmt)
            {
            }
            column(TotalPurchAmt; TotalPurchAmt)
            {
            }
            column(ShowTotalAmt; ShowTotalAmt)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
            begin
                TaxableAmt := 0;
                ExemptAmt := 0;
                TotalPurchAmt := 0;
                //AmtPurchLCY := CalculateAmtOfPurchaseLCY;
                //KMT2016CU5 >>
                VATEntries.RESET;
                VATEntries.SETRANGE("Bill-to/Pay-to No.", Vendor."No.");
                VATEntries.SETFILTER("VAT Bus. Posting Group", 'PUR-LOCAL');
                VATEntries.SETFILTER("Posting Date", Vendor.GETFILTER("Date Filter"));
                IF VATEntries.FINDSET THEN BEGIN
                    REPEAT
                        TotalPurchAmt += VATEntries.Base;
                    UNTIL VATEntries.NEXT = 0;
                    VATEntries1.RESET;
                    VATEntries1.SETRANGE("Bill-to/Pay-to No.", VATEntries."Bill-to/Pay-to No.");
                    VATEntries1.SETFILTER("Localized VAT Identifier", '%1|%2',
                                           VATEntries1."Localized VAT Identifier"::"Taxable Local Purchase", VATEntries1."Localized VAT Identifier"::"Taxable Capex Purchase");
                    VATEntries1.SETFILTER("Posting Date", Vendor.GETFILTER("Date Filter"));
                    IF VATEntries1.FINDSET THEN
                        REPEAT
                            TaxableAmt += VATEntries1.Base;
                        UNTIL VATEntries1.NEXT = 0;

                    VATEntries2.RESET;
                    VATEntries2.SETRANGE("Bill-to/Pay-to No.", VATEntries."Bill-to/Pay-to No.");
                    VATEntries2.SETRANGE("Localized VAT Identifier", VATEntries2."Localized VAT Identifier"::"Exempt Purchase");
                    VATEntries2.SETRANGE("VAT Bus. Posting Group", VATEntries."VAT Bus. Posting Group");
                    VATEntries2.SETFILTER("Posting Date", Vendor.GETFILTER("Date Filter"));
                    IF VATEntries2.FINDSET THEN
                        REPEAT
                            ExemptAmt += VATEntries2.Base;
                        UNTIL VATEntries2.NEXT = 0;
                END;

                IF ((TaxableAmt + ExemptAmt) < MinAmtLCY) /*OR (Vendor."VAT Bus. Posting Group" <> 'PUR-LOCAL')*/ THEN
                    CurrReport.SKIP;
                //KMT2016CU5 <<

            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(AmtPurchLCY);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(MinAmtLCY; MinAmtLCY)
                    {
                        AutoFormatType = 1;
                        Caption = 'Amounts (LCY) Greater Than';
                    }
                    field(HideAddr; HideAddr)
                    {
                        Caption = 'Hide Address Detail';
                        Visible = false;
                    }
                    field(ShowTotalAmt; ShowTotalAmt)
                    {
                        Caption = 'Show Total Amount Coloumn';
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
        VendFilter := Vendor.GETFILTERS;
        //KMT2016CU5 >>
        StartDateNep := '';
        EndDateNep := '';
        StartEngDate := 0D;
        EndEngDate := 0D;
        StartEngDate := Vendor.GETRANGEMIN("Date Filter");
        EndEngDate := Vendor.GETRANGEMAX("Date Filter");
        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", StartEngDate);
        IF NepaliCal.FINDFIRST THEN
            StartDateNep := NepaliCal."Nepali Date";

        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", EndEngDate);
        IF NepaliCal.FINDFIRST THEN
            EndDateNep := NepaliCal."Nepali Date";
        CompanyInfo.GET;
        TradeNameType := 'E';
        "Purchase/Sale" := 'P';
        //KMT2016CU5 <<
    end;

    var
        MinAmtLCY: Decimal;
        HideAddr: Boolean;
        AmtPurchLCY: Decimal;
        VendorAddr: array[8] of Text[50];
        VendFilter: Text;
        VendPurchListCaptLbl: Label 'Vendor - Purchase List';
        CurrRptPageNoCaptLbl: Label 'Page';
        MinAmtLCYCaptLbl: Label 'Amounts (LCY) greater than';
        AmtPurchLCYCaptLbl: Label 'Amount of Purchase (LCY)';
        TotRptedAmtofPurchLCYCaptLbl: Label 'Total Reported Amount of Purchase (LCY)';
        CompanyInfo: Record "Company Information";
        TradeNameType: Code[10];
        "Purchase/Sale": Code[10];
        VATEntries: Record  "VAT Entry";
        ExemptAmt: Decimal;
        TaxableAmt: Decimal;
        TotalPurchAmt: Decimal;
        VATEntries1: Record "VAT Entry";
        VATEntries2: Record "VAT Entry";
        ShowTotalAmt: Boolean;
        ShowCustomVendor: Boolean;
        DateFilter: Text;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;

    local procedure CalculateAmtOfPurchaseLCY(): Decimal
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        WITH VendorLedgEntry DO BEGIN
            SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date");
            SETRANGE("Vendor No.", Vendor."No.");
            SETFILTER("Posting Date", Vendor.GETFILTER("Date Filter"));
            FOR i := 1 TO 3 DO BEGIN
                CASE i OF
                    1:
                        SETRANGE("Document Type", "Document Type"::Invoice);
                    2:
                        SETRANGE("Document Type", "Document Type"::"Credit Memo");
                    3:
                        SETRANGE("Document Type", "Document Type"::Refund);
                END;
                CALCSUMS("Purchase (LCY)");
                Amt := Amt + "Purchase (LCY)";
            END;
            EXIT(-Amt);
        END;
    end;

    [Scope('Internal')]
    procedure InitializeRequest(NewMinAmtLCY: Decimal; NewHideAddress: Boolean)
    begin
        MinAmtLCY := NewMinAmtLCY;
        HideAddr := NewHideAddress;
    end;
}

