report 50417 "Cust. Detailed Aging 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustDetailedAging1.rdlc';
    Caption = 'Customer Detailed Aging KMT';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

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
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."),
                              "Salesperson Code" = FIELD("Global Dimension 2 Filter"),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                              "Currency Code" = FIELD("Currency Filter"),
                               "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");
                column(Cust_Ledger_Entry_Posting_Date_; FORMAT("Posting Date"))
                {
                }
                column(NepaliDate; NepaliDate)
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
                    IF "Cust. Ledger Entry"."Customer No." = 'C99999' THEN
                        CurrReport.SKIP;

                    SETRANGE("Date Filter", 0D, EndDate);

                    RemAmt := 0;
                    RemAmtLCY := 0;
                    DetailedCustLedgEntry.RESET;
                    DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", "Cust. Ledger Entry"."Entry No.");
                    DetailedCustLedgEntry.SETRANGE("Initial Entry Global Dim. 1", "Cust. Ledger Entry"."Global Dimension 1 Code");
                    DetailedCustLedgEntry.SETRANGE("Posting Date", 0D, EndDate);
                    IF Product_Filter <> '' THEN
                        DetailedCustLedgEntry.SETFILTER("Salesperson Code", AreaCode_Filter);
                    DetailedCustLedgEntry.CALCSUMS(Amount);
                    DetailedCustLedgEntry.CALCSUMS("Amount (LCY)");
                    RemAmt := DetailedCustLedgEntry.Amount;
                    RemAmtLCY := DetailedCustLedgEntry."Amount (LCY)";


                    IF RemAmtLCY = 0 THEN
                        CurrReport.SKIP;
                    CurrencyTotalBuffer.UpdateTotal(
                      "Currency Code", RemAmt, RemAmtLCY, Counter);

                    //KMT2016CU5>>
                    OutstandingDays := EndDate - "Posting Date";
                    IF (OutstandingDays <= 7) AND (OutstandingDays >= 0) THEN BEGIN
                        DayGroupNo := 1;
                        AmountGroup1 += RemAmtLCY;
                        GrandAmount1 += RemAmtLCY; //
                    END;
                    IF (OutstandingDays <= 15) AND (OutstandingDays > 7) THEN BEGIN
                        DayGroupNo := 2;
                        AmountGroup2 += RemAmtLCY;
                        GrandAmount2 += RemAmtLCY;   //
                    END;
                    IF (OutstandingDays <= 21) AND (OutstandingDays > 15) THEN BEGIN
                        DayGroupNo := 3;
                        AmountGroup3 += RemAmtLCY;
                        GrandAmount3 += RemAmtLCY; //
                    END;
                    IF (OutstandingDays <= 29) AND (OutstandingDays > 21) THEN BEGIN
                        DayGroupNo := 4;
                        AmountGroup4 += RemAmtLCY;
                        GrandAmount4 += RemAmtLCY; //
                    END;
                    IF (OutstandingDays >= 30) THEN BEGIN
                        DayGroupNo := 5;
                        AmountGroup5 += RemAmtLCY;
                        GrandAmount5 += RemAmtLCY;  //
                    END;
                    NepaliDate := '';
                    NepaliCalendar.RESET;
                    NepaliCalendar.SETRANGE("English Date", "Cust. Ledger Entry"."Posting Date");
                    IF NepaliCalendar.FINDFIRST THEN
                        NepaliDate := NepaliCalendar."Nepali Date";
                    //KMT2016CU5 <<
                end;

                trigger OnPreDataItem()
                begin

                    //KMT2016CU5>>
                    IF Product_Filter <> '' THEN
                        SETFILTER("Global Dimension 1 Code", Product_Filter);
                    //KMT2016CU5 <<

                    IF OnlyOpen THEN BEGIN
                        SETRANGE(Open, TRUE);
                        SETRANGE("Posting Date", 0D, EndDate);
                    END ELSE
                        SETRANGE("Posting Date", 0D, EndDate);
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
                IF GETFILTER("Customer Posting Group") = '' THEN
                    SETRANGE("Customer Posting Group", 'CUSTOMER');//pram
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
        //KMT2016CU5 >>
        StartDateNep := '';
        EndDateNep := '';
        StartEngDate := 0D;
        EndEngDate := 0D;
        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", EndDate);
        IF NepaliCal.FINDFIRST THEN
            StartDateNep := NepaliCal."Nepali Date";

        CompanyInfo.GET;
        //KMT2016CU5 <<
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
        Customer_Detailed_AgingCaptionLbl: Label 'Customer Detailed Aging';
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
        NepaliDate: Code[20];
        NepaliCalendar: Record "English-Nepali Date";
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        RemAmt: Decimal;
        RemAmtLCY: Decimal;

    [Scope('OnPrem')]
    procedure InitializeRequest(SetEndDate: Date; SetOnlyOpen: Boolean)
    begin
        EndDate := SetEndDate;
        OnlyOpen := SetOnlyOpen;
    end;
}

