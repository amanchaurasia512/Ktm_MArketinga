report 50420 "Customer Sales List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerSalesList.rdlc';
    Caption = 'Customer - Sales List';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Date Filter";
            column(CustomerNo; "No.")
            {
            }
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
            column(OriginalExemptAmt; OriginalExemptAmt)
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
            column(BalanceLCY_Customer; "Balance (LCY)")
            {
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
            begin
                ExemptAmt := 0;
                AmtSalesLCY := CalculateAmtOfSaleLCY;
                //KMT2016CU5 >>
                VatEntries.RESET;
                VatEntries.SETRANGE("Bill-to/Pay-to No.", Customer."No.");
                VatEntries.SETRANGE("Localized VAT Identifier", VatEntries."Localized VAT Identifier"::"Non Taxable Sales");
                VatEntries.SETFILTER(Base, '<%1|>%1', MinAmtLCY, MinAmtLCY);
                VatEntries.SETFILTER("Posting Date", Customer.GETFILTER("Date Filter"));
                IF VatEntries.FINDSET THEN
                    REPEAT
                        ExemptAmt += VatEntries.Base;
                    UNTIL VatEntries.NEXT = 0;
                OriginalExemptAmt := -ExemptAmt;
                //ExemptAmt := CalculateExemptAmtOfSaleLCY;
                /*IF AmtSalesLCY = ExemptAmt THEN
                  AmtSalesLCY := 0;*/

                IF (AmtSalesLCY) < MinAmtLCY THEN
                    CurrReport.SKIP;

                //MESSAGE(FORMAT(getrangemax("date filter")));
                CALCFIELDS("Balance (LCY)");

                /*MESSAGE(FORMAT("balance (lcy)"));
                
                //MESSAGE
                CustomerRec.RESET;
                CustomerRec.SETRANGE("No.", "No.");
                CustomerRec.SETFILTER("Date Filter", '..%1', getrangemax("Date Filter"));
                CustomerRec.CALCFIELDS("Balance (LCY)");
                CustomerRec.FINDFIRST;
                MESSAGE(FORMAT(CustomerRec."balance (lcy)"));
                */
                /*IF NOT HideAddress THEN
                  FormatAddr.Customer(CustAddr,Customer);*/
                //KMT2016CU5 <<

            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(AmtSalesLCY);
                //KMT2016CU5 >>
                TradeNameType := 'E';
                "Purchase/Sale" := 'S';
                //KMT2016CU5 <<
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
                    field(HideAddress; HideAddress)
                    {
                        Caption = 'Hide Address Detail';
                        Visible = false;
                    }
                    field("Show Total Amount"; ShowTotalAmount)
                    {
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
        CustFilter := Customer.GETFILTERS;
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
        Customer___Sales_ListCaptionLbl: Label 'Customer - Sales List';
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
        CustomerRec: Record Customer;
        OriginalExemptAmt: Decimal;

    local procedure CalculateAmtOfSaleLCY(): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        WITH CustLedgEntry DO BEGIN
            SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
            SETRANGE("Customer No.", Customer."No.");
            SETFILTER("Posting Date", Customer.GETFILTER("Date Filter"));
            FOR i := 1 TO 2 DO BEGIN
                CASE i OF
                    1:
                        SETRANGE("Document Type", "Document Type"::Invoice);
                    2:
                        SETRANGE("Document Type", "Document Type"::"Credit Memo");
                /*3:
                  SETRANGE("Pass Value to Sales/Purch (LCY",TRUE);   //KMT2016CU5*/
                END;
                CALCSUMS("Sales (LCY)");
                Amt := Amt + "Sales (LCY)";
            END;
            //MESSAGE(FORMAT(Amt));
            EXIT(Amt);
        END;

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

    local procedure CalculateExemptAmtOfSaleLCY() NonTaxAmt: Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        /*NonTaxAmt := 0;
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document Type","Customer No.","Posting Date");
        CustLedgEntry.SETRANGE("Customer No.",Customer."No.");
        CustLedgEntry.SETRANGE("Pass Value to Sales/Purch (LCY",TRUE);
        CustLedgEntry.SETFILTER("Posting Date",Customer.GETFILTER("Date Filter"));
        CustLedgEntry.SETFILTER("Document Type",'%1|%2',CustLedgEntry."Document Type"::"Credit Memo",CustLedgEntry."Document Type"::Invoice);
        IF CustLedgEntry.FINDFIRST THEN REPEAT
          CustLedgEntry.CALCFIELDS("Amount (LCY)");
          IF CustLedgEntry."Amount (LCY)" = CustLedgEntry."Sales (LCY)" THEN
            NonTaxAmt := NonTaxAmt + CustLedgEntry."Sales (LCY)";
        UNTIL CustLedgEntry.NEXT = 0;
        EXIT(NonTaxAmt);*/

    end;
}

