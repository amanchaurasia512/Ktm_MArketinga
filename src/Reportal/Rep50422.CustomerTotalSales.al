report 50422 "Customer Total Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerTotalSales.rdlc';
    Caption = 'Customer Total Sales';

    dataset
    {
        dataitem(Customer; Customer)
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
            column(Customer__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(AmtSalesLCY; AmtSalesLCY)
            {
                AutoFormatType = 1;
            }
            column(OriginalAmtSalesLCY; OriginalAmtSalesLCY)
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
            column(Customer___Sales_ListCaption; Customer___Sales_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(MinAmtLCYCaption; MinAmtLCYCaptionLbl)
            {
            }
            column(Customer__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Customer_NameCaption; FIELDCAPTION(Name))
            {
            }
            column(Customer__VAT_Registration_No__Caption; FIELDCAPTION("VAT Registration No."))
            {
            }
            column(AmtSalesLCYCaption; AmtSalesLCYCaptionLbl)
            {
            }
            column(Total_Reported_Amount_of_Sales__LCY_Caption; Total_Reported_Amount_of_Sales__LCY_CaptionLbl)
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
            column(TaxableSales; TaxableSales)
            {
            }
            column(NonTaxableSales; -NonTaxableSales)
            {
            }
            column(VatAmount; VatAmount)
            {
            }
            column(TotalTaxableSales; TotalTaxableSales)
            {
            }
            column(TotalNonTaxableSales; -TotalNonTaxableSales)
            {
            }
            column(TotalVatAmount; TotalVatAmount)
            {
            }
            column(Balance; Customer.Balance)
            {
            }
            column(TotalBalance; TotalBalance)
            {
            }
            column(BeginBalance; OpeningBalance)
            {
            }
            column(TotalOpeningBalance; TotalOpeningBalance)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                column(EntryNo_CustLedgerEntry; "Cust. Ledger Entry"."Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Customer.balance += amount;
                    /*
                    VatEntries.RESET;
                    VatEntries.SETRANGE("Bill-to/Pay-to No.",Customer."No.");
                    VatEntries.SETFILTER("Localized VAT Identifier",'%1|%2|%3',
                              VatEntries."Localized VAT Identifier"::"Non Taxable Sales",
                              VatEntries."Localized VAT Identifier"::"Exempt Sales",
                              VatEntries."Localized VAT Identifier"::"Taxable Sales");
                    VatEntries.SETFILTER(Base,'<%1|>%1',MinAmtLCY,MinAmtLCY);
                    VatEntries.SETFILTER("Posting Date",Customer.GETFILTER("Date Filter"));
                    VatEntries.SETRANGE("Document No.", "Document No.");
                    
                    IF VatEntries.FINDSET THEN REPEAT
                        VatAmount += VatEntries.Amount;
                        TotalVatAmount += VatEntries.Amount;
                    UNTIL VatEntries.NEXT = 0;
                    
                    
                    VatEntries.RESET;
                    VatEntries.SETRANGE("Bill-to/Pay-to No.",Customer."No.");
                    VatEntries.SETRANGE("Localized VAT Identifier",VatEntries."Localized VAT Identifier"::"Non Taxable Sales");
                    
                    VatEntries.SETFILTER(Base,'<%1|>%1',MinAmtLCY,MinAmtLCY);
                    VatEntries.SETFILTER("Posting Date",Customer.GETFILTER("Date Filter"));
                    VatEntries.SETRANGE("Document No.", "Document No.");
                    IF VatEntries.FINDSET THEN REPEAT
                        ExemptAmt += VatEntries.Base;
                    
                    UNTIL VatEntries.NEXT = 0;
                    
                    TaxableSales += "Sales (LCY)" + ExemptAmt;
                    NonTaxableSales += ExemptAmt;
                    //MESSAGE(FORMAT("sales (lcy)") + ' = ' + FORMAT(VatAmount));
                    TotalNonTaxableSales += ExemptAmt;
                    
                    TotalTaxableSales += "Sales (LCY)" + ExemptAmt;
                    */

                end;

                trigger OnPreDataItem()
                begin
                    SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
                    SETFILTER("Document Type", '%1|%2', "Document Type"::Invoice,
                                   "Document Type"::"Credit Memo");
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "365";
            begin
                ExemptAmt := 0;
                VatAmount := 0;
                TaxableSales := 0;
                NonTaxableSales := 0;
                BeginBalance := 0;
                OpeningBalance := 0;

                //calculate opening
                CustomerCopy.COPY(Customer);
                CustomerCopy.SETRANGE("Date Filter", 0D, StartEngDate - 1);
                CustomerCopy.CALCFIELDS("Net Change (LCY)");
                OpeningBalance := CustomerCopy."Net Change (LCY)";
                CLEAR(CustomerCopy);
                TotalOpeningBalance += OpeningBalance;

                VatEntries.RESET;
                VatEntries.SETRANGE("Bill-to/Pay-to No.", Customer."No.");
                VatEntries.SETFILTER("Localized VAT Identifier", '%1|%2|%3',
                          VatEntries."Localized VAT Identifier"::"Non Taxable Sales",
                          VatEntries."Localized VAT Identifier"::"Exempt Sales",
                          VatEntries."Localized VAT Identifier"::"Taxable Sales");
                VatEntries.SETFILTER(Base, '<%1|>%1', MinAmtLCY, MinAmtLCY);
                VatEntries.SETFILTER("Posting Date", Customer.GETFILTER("Date Filter"));
                IF VatEntries.FINDSET THEN
                    REPEAT
                        VatAmount += VatEntries.Amount;
                        TotalVatAmount += VatEntries.Amount;
                    UNTIL VatEntries.NEXT = 0;


                VatEntries.RESET;
                VatEntries.SETRANGE("Bill-to/Pay-to No.", Customer."No.");
                VatEntries.SETRANGE("Localized VAT Identifier", VatEntries."Localized VAT Identifier"::"Non Taxable Sales");

                VatEntries.SETFILTER(Base, '<%1|>%1', MinAmtLCY, MinAmtLCY);
                VatEntries.SETFILTER("Posting Date", Customer.GETFILTER("Date Filter"));
                IF VatEntries.FINDSET THEN
                    REPEAT
                        ExemptAmt += VatEntries.Base;
                    UNTIL VatEntries.NEXT = 0;

                TaxableSales := CalculateAmtOfSaleLCY + ExemptAmt;
                NonTaxableSales := ExemptAmt;
                TotalNonTaxableSales += NonTaxableSales;
                TotalTaxableSales += CalculateAmtOfSaleLCY + ExemptAmt;

                CustomerCopy.COPY(Customer);
                CustomerCopy.SETRANGE("Date Filter", 0D, EndEngDate - 1);
                CustomerCopy.CALCFIELDS("Net Change (LCY)");
                BeginBalance := CustomerCopy."Net Change (LCY)";

                CustomerRec.COPY(Customer);
                CustomerRec.SETRANGE("Date Filter", 0D, GETRANGEMAX("Date Filter"));
                CustomerRec.CALCFIELDS("Debit Amount (LCY)", "Credit Amount (LCY)");//"Net Change (LCY)");//pram
                Balance := BeginBalance + CustomerRec."Debit Amount (LCY)" - CustomerRec."Credit Amount (LCY)";
                Balance := 0;

                DetailCustomerLedger.RESET;
                DetailCustomerLedger.SETRANGE("Posting Date", 0D, GETRANGEMAX("Date Filter"));
                DetailCustomerLedger.SETRANGE("Customer No.", "No.");
                IF DetailCustomerLedger.FINDFIRST THEN
                    REPEAT
                        DetailCustomerLedger.CALCFIELDS("Amount (LCY)");
                        Balance += DetailCustomerLedger."Amount (LCY)";
                    UNTIL DetailCustomerLedger.NEXT = 0;
                TotalBalance += Balance;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(AmtSalesLCY);
                //KMT2016CU5 >>
                TradeNameType := 'E';
                "Purchase/Sale" := 'S';
                //KMT2016CU5 <<

                TotalNonTaxableSales := 0;
                TotalTaxableSales := 0;
                TotalVatAmount := 0;
                TotalOpeningBalance := 0;
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
        CustFilter := Customer.GETFILTERS;
        ShowTotalAmount := TRUE;
        MinAmtLCY := 0;
        //KMT2016CU5 >>
        StartDateNep := '';
        EndDateNep := '';
        StartEngDate := 0D;
        EndEngDate := 0D;
        StartEngDate := Customer.GETRANGEMIN("Date Filter");
        EndEngDate := Customer.GETRANGEMAX("Date Filter");
        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", StartEngDate);
        IF NepaliCal.FINDFIRST THEN
            StartDateNep := NepaliCal."Nepali Date";

        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", EndEngDate);
        IF NepaliCal.FINDFIRST THEN
            EndDateNep := NepaliCal."Nepali Date";
        CompanyInfo.GET;
        //KMT2016CU5 <<
    end;

    var
        MinAmtLCY: Decimal;
        HideAddress: Boolean;
        AmtSalesLCY: Decimal;
        CustAddr: array[8] of Text[50];
        CustFilter: Text;
        Customer___Sales_ListCaptionLbl: Label 'Customer - Total Sales List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        MinAmtLCYCaptionLbl: Label 'Amounts (LCY) greater than';
        AmtSalesLCYCaptionLbl: Label 'Amount of Sales (LCY)';
        Total_Reported_Amount_of_Sales__LCY_CaptionLbl: Label 'Total Reported Amount of Sales (LCY)';
        TradeNameType: Code[10];
        "Purchase/Sale": Code[10];
        VatEntries: Record "VAT Entry";
        ExemptAmt: Decimal;
        CompanyInfo: Record "Company Information";
        OriginalAmtSalesLCY: Decimal;
        ShowTotalAmount: Boolean;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        VatAmount: Decimal;
        TaxableSales: Decimal;
        NonTaxableSales: Decimal;
        TotalTaxableSales: Decimal;
        TotalNonTaxableSales: Decimal;
        TotalVatAmount: Decimal;
        CustomerRec: Record Customer;
        TotalBalance: Decimal;
        DetailCustomerLedger: Record "Detailed Cust. Ledg. Entry";
        CustomerCopy: Record Customer;
        BeginBalance: Decimal;
        OpeningBalance: Decimal;
        TotalOpeningBalance: Decimal;

    local procedure CalculateAmtOfSaleLCY(): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        /*WITH CustLedgEntry DO BEGIN
          SETCURRENTKEY("Document Type","Customer No.","Posting Date");
          SETRANGE("Customer No.",Customer."No.");
          SETFILTER("Posting Date",Customer.GETFILTER("Date Filter"));
          SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
          FOR i := 1 TO 2 DO BEGIN
            CASE i OF
              1:
                SETRANGE("Document Type","Document Type"::Invoice);
              2:
                SETRANGE("Document Type","Document Type"::"Credit Memo");
            END;
            CALCSUMS("Sales (LCY)");
            Amt := Amt + "Sales (LCY)";
        
          END;
          MESSAGE(FORMAT(Amt));
          EXIT(Amt);
        END;*/

        CustLedgEntry.RESET;
        CustLedgEntry.SETFILTER("Document Type", '%1|%2', CustLedgEntry."Document Type"::Invoice, CustLedgEntry."Document Type"::"Credit Memo");
        CustLedgEntry.SETRANGE("Customer No.", Customer."No.");
        CustLedgEntry.SETFILTER("Posting Date", Customer.GETFILTER("Date Filter"));
        /*IF Customer.GETFILTER("Global Dimension 1 filter") <> '' THEN
          CustLedgEntry.SETFILTER("Global Dimension 1 Code", Customer.GETFILTER("Global Dimension 1 Filter"));
        IF Customer.GETFILTER("Global Dimension 2 Filter") <> '' THEN
          CustLedgEntry.SETFILTER("Global Dimension 2 Code", Customer.GETFILTER("Global Dimension 2 Filter"));
        */
        CustLedgEntry.CALCSUMS("Sales (LCY)");
        EXIT(CustLedgEntry."Sales (LCY)");
        //MESSAGE(FORMAT(CustLedgEntry."Sales (LCY)"));

    end;

    [Scope('OnPrem')]
    procedure InitializeRequest(MinimumAmtLCY: Decimal; HideAddressDetails: Boolean)
    begin
        MinAmtLCY := MinimumAmtLCY;
        HideAddress := HideAddressDetails;
    end;

    local procedure CalculateOriginalAmtOfSaleLCY(): Decimal
    var
        CustLedgEntry1: Record "Cust. Ledger Entry";
        OriginalAmt: Decimal;
        i: Integer;
    begin
        WITH CustLedgEntry1 DO BEGIN
            SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
            SETRANGE("Customer No.", Customer."No.");
            SETFILTER("Posting Date", Customer.GETFILTER("Date Filter"));
            SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
            FOR i := 1 TO 2 DO BEGIN
                CASE i OF
                    1:
                        SETRANGE("Document Type", "Document Type"::Invoice);
                    2:
                        SETRANGE("Document Type", "Document Type"::"Credit Memo");
                END;
                CALCSUMS("Amount (LCY)");
                OriginalAmt := OriginalAmt + "Amount (LCY)";
            END;
            EXIT(OriginalAmt);
        END;
    end;
}

