report 50062 "Vendor Total Purchase"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VendorTotalPurchase.rdlc';
    Caption = 'Vendor Total Purchase';

    dataset
    {
        dataitem(DataItem6836; Table23)
        {
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(MinAmtLCY; MinAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(TABLECAPTION__________CustFilter; TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Vendor__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(AmtPurchaseLCY; AmtPurchaseLCY)
            {
                AutoFormatType = 1;
            }
            column(OriginalAmtPurchaseLCY; OriginalAmtPurchaseLCY)
            {
            }
            column(CustAddr_2_; CustAddr[2])
            {
            }
            column(CustAddr_3_; CustAddr[3])
            {
            }
            column(CustAddr_4_; CustAddr[4])
            {
            }
            column(CustAddr_5_; CustAddr[5])
            {
            }
            column(CustAddr_6_; CustAddr[6])
            {
            }
            column(CustAddr_7_; CustAddr[7])
            {
            }
            column(CustAddr_8_; CustAddr[8])
            {
            }
            column(Vendor___Purchase_ListCaption; Vendor___Purchase_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(MinAmtLCYCaption; MinAmtLCYCaptionLbl)
            {
            }
            column(Vendor__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Vendor_NameCaption; FIELDCAPTION(Name))
            {
            }
            column(Vendor__VAT_Registration_No__Caption; FIELDCAPTION("VAT Registration No."))
            {
            }
            column(AmtPurchaseLCYCaption; AmtPurchaseLCYCaptionLbl)
            {
            }
            column(Total_Reported_Amount_of_Purchase__LCY_Caption; Total_Reported_Amount_of_Sales__LCY_CaptionLbl)
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
            column(ShowTotalAmount; ShowTotalAmount)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            column(TaxablePurchase; TaxablePurchase)
            {
            }
            column(NonTaxablePurchase; NonTaxablePurchase)
            {
            }
            column(VatAmount; VatAmount)
            {
            }
            column(TotalTaxablePurchase; TotalTaxablePurchase)
            {
            }
            column(TotalNonTaxablePurchase; TotalNonTaxablePurchase)
            {
            }
            column(TotalVatAmount; TotalVatAmount)
            {
            }
            column(Balance; VendorBalanceLCY)
            {
            }
            column(TotalBalance; TotalBalance)
            {
            }
            column(BeginBalance; BeginBalance)
            {
            }
            dataitem(DataItem31; Table25)
            {
                DataItemLink = Vendor No.=FIELD(No.),
                               Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                               Global Dimension 2 Code=FIELD(Global Dimension 2 Filter);
                column(EntryNo_CustLedgerEntry;"Vendor Ledger Entry"."Entry No.")
                {
                }

                trigger OnPreDataItem()
                begin
                    SETCURRENTKEY("Document Type","Vendor No.","Posting Date");
                    SETFILTER("Document Type",'%1|%2',"Document Type"::Invoice,"Document Type"::"Credit Memo");
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "365";
            begin
                ExemptAmt := 0;
                VatAmount :=0;
                TaxablePurchase := 0;
                NonTaxablePurchase := 0;

                //KMT2016CU5 >>
                IF Vendor."Hide in Trial Balance Report" THEN
                  CurrReport.SKIP;
                //KMT2016CU5 <<

                VatEntries.RESET;
                VatEntries.SETRANGE("Bill-to/Pay-to No.",Vendor."No.");
                VatEntries.SETFILTER("Localized VAT Identifier",'%1|%2|%3|%4',
                          VatEntries."Localized VAT Identifier"::"Taxable Capex Purchase",
                          VatEntries."Localized VAT Identifier"::"Exempt Purchase",
                          VatEntries."Localized VAT Identifier"::"Taxable Local Purchase",
                          VatEntries."Localized VAT Identifier"::"Taxable Import Purchase");
                VatEntries.SETFILTER("Posting Date",Vendor.GETFILTER("Date Filter"));
                VatEntries.CALCSUMS(Amount);
                VatAmount := VatEntries.Amount;
                TotalVatAmount += VatAmount;

                VatEntries.RESET;
                VatEntries.SETRANGE("Bill-to/Pay-to No.",Vendor."No.");
                VatEntries.SETRANGE("Localized VAT Identifier",VatEntries."Localized VAT Identifier"::"Exempt Purchase");
                VatEntries.SETFILTER("Posting Date",Vendor.GETFILTER("Date Filter"));
                VatEntries.CALCSUMS(Base);
                ExemptAmt := VatEntries.Base;


                VatEntries.RESET;
                VatEntries.SETRANGE("Bill-to/Pay-to No.",Vendor."No.");
                VatEntries.SETFILTER("Localized VAT Identifier",'%1|%2|%3',
                                     VatEntries."Localized VAT Identifier"::"Taxable Capex Purchase",
                                      VatEntries."Localized VAT Identifier"::"Taxable Local Purchase",
                                      VatEntries."Localized VAT Identifier"::"Taxable Import Purchase");
                VatEntries.SETFILTER("Posting Date",Vendor.GETFILTER("Date Filter"));
                VatEntries.CALCSUMS(Base);
                TaxablePurchase := VatEntries.Base;


                //TaxablePurchase := CalculateAmtOfPurchaseLCY + ExemptAmt;
                NonTaxablePurchase := ExemptAmt;
                TotalNonTaxablePurchase += NonTaxablePurchase;
                TotalTaxablePurchase += TaxablePurchase;

                VendorCopy.COPY(Vendor);
                VendorCopy.SETRANGE("Date Filter",0D,StartEngDate - 1);
                VendorCopy.CALCFIELDS("Net Change (LCY)");
                BeginBalance := VendorCopy."Net Change (LCY)";

                VendorBalanceLCY := 0;
                DetailVendorLedger.RESET;
                DetailVendorLedger.SETRANGE("Vendor No.",Vendor."No.");
                DetailVendorLedger.SETFILTER("Posting Date",'..'+FORMAT(EndEngDate));
                IF DetailVendorLedger.FINDFIRST THEN REPEAT
                  DetailVendorLedger.CALCFIELDS("Amount (LCY)");
                  VendorBalanceLCY += DetailVendorLedger."Amount (LCY)";
                UNTIL DetailVendorLedger.NEXT = 0;
                TotalBalance += VendorBalanceLCY;
                //MESSAGE('Taxable Purchase %1\Non-Taxable Purchase %2\VAT Amount %3',TaxablePurchase,NonTaxablePurchase,VatAmount);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(AmtPurchaseLCY);

                //KMT2016CU5 >>
                TradeNameType := 'E';
                "Purchase/Sale" := 'S';
                //KMT2016CU5 <<

                TotalNonTaxablePurchase := 0;
                TotalTaxablePurchase := 0;
                TotalVatAmount := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
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
        CustFilter := Vendor.GETFILTERS;
        ShowTotalAmount := TRUE;
        MinAmtLCY := 0;

        //KMT2016CU5 >>
        StartDateNep := '';
        EndDateNep := '';
        StartEngDate := 0D;
        EndEngDate := 0D;
        StartEngDate := Vendor.GETRANGEMIN("Date Filter");
        EndEngDate := Vendor.GETRANGEMAX("Date Filter");
        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date",StartEngDate);
        IF NepaliCal.FINDFIRST THEN
            StartDateNep := NepaliCal."Nepali Date";

        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date",EndEngDate);
        IF NepaliCal.FINDFIRST THEN
          EndDateNep := NepaliCal."Nepali Date";
        CompanyInfo.GET;
        //KMT2016CU5 <<
    end;

    var
        MinAmtLCY: Decimal;
        HideAddress: Boolean;
        AmtPurchaseLCY: Decimal;
        CustAddr: array [8] of Text[50];
        CustFilter: Text;
        Vendor___Purchase_ListCaptionLbl: Label 'Vendor - Total Purchase List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        MinAmtLCYCaptionLbl: Label 'Amounts (LCY) greater than';
        AmtPurchaseLCYCaptionLbl: Label 'Amount of Purchase (LCY)';
        Total_Reported_Amount_of_Sales__LCY_CaptionLbl: Label 'Total Reported Amount of Purchase (LCY)';
        TradeNameType: Code[10];
        "Purchase/Sale": Code[10];
        VatEntries: Record "254";
        ExemptAmt: Decimal;
        CompanyInfo: Record "79";
        OriginalAmtPurchaseLCY: Decimal;
        ShowTotalAmount: Boolean;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "50000";
        StartEngDate: Date;
        EndEngDate: Date;
        VatAmount: Decimal;
        TaxablePurchase: Decimal;
        NonTaxablePurchase: Decimal;
        TotalTaxablePurchase: Decimal;
        TotalNonTaxablePurchase: Decimal;
        TotalVatAmount: Decimal;
        VendorRec: Record "23";
        TotalBalance: Decimal;
        DetailVendorLedger: Record "25";
        VendorCopy: Record "23";
        BeginBalance: Decimal;
        VendorBalanceLCY: Decimal;

    local procedure CalculateAmtOfPurchaseLCY(): Decimal
    var
        VendLedgEntry: Record "25";
        Amt: Decimal;
        i: Integer;
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETFILTER("Document Type", '%1|%2',VendLedgEntry."Document Type"::Invoice, VendLedgEntry."Document Type"::"Credit Memo");
        VendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
        VendLedgEntry.SETFILTER("Posting Date",Vendor.GETFILTER("Date Filter"));
        VendLedgEntry.CALCSUMS("Purchase (LCY)");
        EXIT(VendLedgEntry."Purchase (LCY)");
    end;

    [Scope('Internal')]
    procedure InitializeRequest(MinimumAmtLCY: Decimal;HideAddressDetails: Boolean)
    begin
        MinAmtLCY := MinimumAmtLCY;
        HideAddress := HideAddressDetails;
    end;

    local procedure CalculateOriginalAmtOfPurchaseLCY(): Decimal
    var
        CustLedgEntry1: Record "25";
        OriginalAmt: Decimal;
        i: Integer;
    begin
        WITH CustLedgEntry1 DO BEGIN
          SETCURRENTKEY("Document Type","Vendor No.","Posting Date");
          SETRANGE("Vendor No.",Vendor."No.");
          SETFILTER("Posting Date",Vendor.GETFILTER("Date Filter"));
          SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
          FOR i := 1 TO 2 DO BEGIN
            CASE i OF
              1:
                SETRANGE("Document Type","Document Type"::Invoice);
              2:
                SETRANGE("Document Type","Document Type"::"Credit Memo");
            END;
            CALCSUMS("Amount (LCY)");
            OriginalAmt := OriginalAmt + "Amount (LCY)";
          END;
          EXIT(OriginalAmt);
        END;
    end;
}

