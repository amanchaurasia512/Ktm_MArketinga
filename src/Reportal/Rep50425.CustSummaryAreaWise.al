report 50425 "Cust. Summary Area Wise"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustSummaryAreaWise.rdlc';
    Caption = 'Customer Summary Aging KMT';
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(STRSUBSTNO_Text000_FORMAT_EndDate_; STRSUBSTNO(Text000, FORMAT(EndDate)))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Customer_TABLECAPTION_CustFilter; TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer_Phone_No_; "Phone No.")
            {
            }
            column(CustomerContact; Contact)
            {
            }
            column(EMail; "E-Mail")
            {
            }
            column(City_Customer; Customer.City)
            {
            }
            column(Product_Filter; Product_Filter)
            {
            }
            column(AreaCode_Filter; AreaCode_Filter)
            {
            }
            column(Customer_Detailed_AgingCaption; Customer_Detailed_AgingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Currency Code" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");
                column(Cust_Ledger_Entry_Posting_Date_; FORMAT("Posting Date"))
                {
                }
                column(Cust_Ledger_Entry_Document_No_; "Document No.")
                {
                }
                column(Cust_Ledger_Entry_Description; Description)
                {
                }
                column(Cust_Ledger_Entry_Due_Date_; FORMAT("Due Date"))
                {
                }
                column(OverDueMonths; OverDueMonths)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Cust_Ledger_Entry_Remaining_Amount_; "Remaining Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Cust_Ledger_Entry_Currency_Code_; "Currency Code")
                {
                }
                column(Cust_Ledger_Entry_Remaining_Amt_LCY_; "Remaining Amt. (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(GlobalDimension2Code_CustLedgerEntry; "Cust. Ledger Entry"."Global Dimension 2 Code")
                {
                }
                column(OutstandingDays; OutstandingDays)
                {
                }
                column(DayGroupNo; DayGroupNo)
                {
                }
                column(AmountGroup1; AmountGroup1)
                {
                }
                column(AmountGroup2; AmountGroup2)
                {
                }
                column(AmountGroup3; AmountGroup3)
                {
                }
                column(AmountGroup4; AmountGroup4)
                {
                }
                column(AmountGroup5; AmountGroup5)
                {
                }
                column(GrandAmount1; GrandAmount1)
                {
                }
                column(GrandAmount2; GrandAmount2)
                {
                }
                column(GrandAmount3; GrandAmount3)
                {
                }
                column(GrandAmount4; GrandAmount4)
                {
                }
                column(GrandAmount5; GrandAmount5)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF "Cust. Ledger Entry"."Customer No." = 'C99999' THEN   //hiding the unrealized customer
                        CurrReport.SKIP;
                    /*IF "Due Date" = 0D THEN
                      OverDueMonths := 0
                    ELSE BEGIN
                      OverDueMonths :=
                        (DATE2DMY(EndDate,3) - DATE2DMY("Due Date",3)) * 12 +
                        DATE2DMY(EndDate,2) - DATE2DMY("Due Date",2);
                      IF DATE2DMY(EndDate,1) < DATE2DMY("Due Date",1) THEN
                        OverDueMonths := OverDueMonths - 1;
                    END;*/
                    SETRANGE("Date Filter", 0D, EndDate);
                    CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                    IF "Remaining Amount" = 0 THEN
                        CurrReport.SKIP;
                    CurrencyTotalBuffer.UpdateTotal(
                      "Currency Code", "Remaining Amount", "Remaining Amt. (LCY)", Counter);

                    //KMT2016CU5>>
                    OutstandingDays := EndDate - "Posting Date";
                    IF (OutstandingDays <= 7) AND (OutstandingDays >= 0) THEN BEGIN
                        DayGroupNo := 1;
                        AmountGroup1 += "Remaining Amt. (LCY)";
                        GrandAmount1 += "Remaining Amt. (LCY)";
                    END;
                    IF (OutstandingDays <= 15) AND (OutstandingDays > 7) THEN BEGIN
                        DayGroupNo := 2;
                        AmountGroup2 += "Remaining Amt. (LCY)";
                        GrandAmount2 += "Remaining Amt. (LCY)";
                    END;
                    IF (OutstandingDays <= 21) AND (OutstandingDays > 15) THEN BEGIN
                        DayGroupNo := 3;
                        AmountGroup3 += "Remaining Amt. (LCY)";
                        GrandAmount3 += "Remaining Amt. (LCY)";
                    END;
                    IF (OutstandingDays <= 29) AND (OutstandingDays > 21) THEN BEGIN
                        DayGroupNo := 4;
                        AmountGroup4 += "Remaining Amt. (LCY)";
                        GrandAmount4 += "Remaining Amt. (LCY)";
                    END;
                    IF (OutstandingDays >= 30) THEN BEGIN
                        DayGroupNo := 5;
                        AmountGroup5 += "Remaining Amt. (LCY)";
                        GrandAmount5 += "Remaining Amt. (LCY)";
                    END;
                    //KMT2016CU5 <<

                end;

                trigger OnPreDataItem()
                begin
                    //KMT2016CU5>>
                    IF Product_Filter <> '' THEN
                        SETFILTER("Global Dimension 1 Code", Product_Filter);
                    //KMT2016CU5 <<
                    //"Cust. Ledger Entry".SETRANGE("Document Type","Document Type"::Invoice);

                    IF OnlyOpen THEN BEGIN
                        SETRANGE(Open, TRUE);
                        SETRANGE("Due Date", 0D, EndDate);
                    END ELSE
                        SETRANGE("Due Date", 0D, EndDate);
                    CurrReport.CREATETOTALS("Remaining Amount", "Remaining Amt. (LCY)");
                    //Counter := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //KMT2016CU5 >>
                AmountGroup1 := 0;
                AmountGroup2 := 0;
                AmountGroup3 := 0;
                AmountGroup4 := 0;
                AmountGroup5 := 0;
                //KMT2016CU5 >>
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS("Cust. Ledger Entry"."Remaining Amt. (LCY)");
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
                    field("Ending Date"; EndDate)
                    {
                        Caption = 'Ending Date';
                    }
                    field(ShowOpenEntriesOnly; OnlyOpen)
                    {
                        Caption = 'Show Open Entries Only';
                        Visible = true;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF EndDate = 0D THEN
                EndDate := WORKDATE;
        end;
    }

    labels
    {
        CustomerContactCaption = 'Contact';
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
        Product_Filter := Customer.GETFILTER("Global Dimension 1 Filter");
        AreaCode_Filter := Customer.GETFILTER("Global Dimension 2 Filter");
        GrandAmount1 := 0;
        GrandAmount2 := 0;
        GrandAmount3 := 0;
        GrandAmount4 := 0;
        GrandAmount5 := 0;
        CompanyInfo.GET;
    end;

    var
        Text000: Label 'As of %1';
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        EndDate: Date;
        CustFilter: Text;
        OverDueMonths: Integer;
        OK: Boolean;
        Counter: Integer;
        Counter1: Integer;
        OnlyOpen: Boolean;
        Customer_Detailed_AgingCaptionLbl: Label 'Customer Summary Aging';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Cust_Ledger_Entry_Posting_Date_CaptionLbl: Label 'Posting Date';
        Cust_Ledger_Entry_Due_Date_CaptionLbl: Label 'Due Date';
        OverDueMonthsCaptionLbl: Label 'Months Due';
        TotalCaptionLbl: Label 'Total';
        OutstandingDays: Decimal;
        PeriodStartDate: array[6] of Date;
        i: Integer;
        PeriodLength: DateFormula;
        CustBalanceDue: array[5] of Decimal;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ZeroSeven: Label '0-7';
        EightFifteen: Label '8-15';
        SixteenTwentyTwo: Label '16-22';
        "TwentyThree-Twentynine": Label '23-29';
        GrtrThanThirty: Label '>30';
        DayGroupNo: Integer;
        AmountGroup1: Decimal;
        AmountGroup2: Decimal;
        AmountGroup3: Decimal;
        AmountGroup4: Decimal;
        AmountGroup5: Decimal;
        GrandAmount1: Decimal;
        GrandAmount2: Decimal;
        GrandAmount3: Decimal;
        GrandAmount4: Decimal;
        GrandAmount5: Decimal;
        Product_Filter: Text;
        AreaCode_Filter: Text;
        CompanyInfo: Record "Company Information";

    [Scope('OnPrem')]
    procedure InitializeRequest(SetEndDate: Date; SetOnlyOpen: Boolean)
    begin
        EndDate := SetEndDate;
        OnlyOpen := SetOnlyOpen;
    end;
}

