report 50426 "Cust-Vend Detail Trial"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustVendDetailTrial.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = WHERE("Also Vendor"=CONST(true));
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter";
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            column(OpeningBal; OpeningBal)
            {
            }
            column(RunningBalance; RunningBalance)
            {
            }
            column(CumulativeBal; CumulativeBal)
            {
            }
            column(AllFilters; AllFilters)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(ReportCaption; ReportCaption)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            column(DateFilter; DateFilter)
            {
            }
            column(NepaliDate; NepaliDate)
            {
            }
            dataitem("Cust-Vend Ledger";"Cust-Vend Ledger")
            {
                DataItemLink = "Party Name"=FIELD(Name),
                               "Posting Date"=FIELD("Date Filter"),
                              "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter");
                DataItemTableView = SORTING("Party Name","Posting Date");
                column(PartyNo_CustVendLedger;"Cust-Vend Ledger"."Party No.")
                {
                }
                column(PostingDate_CustVendLedger;FORMAT("Cust-Vend Ledger"."Posting Date"))
                {
                }
                column(DocumentType_CustVendLedger;"Cust-Vend Ledger"."Document Type")
                {
                }
                column(DocumentNo_CustVendLedger;"Cust-Vend Ledger"."Document No.")
                {
                }
                column(Description_CustVendLedger;"Cust-Vend Ledger".Description)
                {
                }
                column(Amount_CustVendLedger;"Cust-Vend Ledger".Amount)
                {
                }
                column(AmountLCY_CustVendLedger;"Cust-Vend Ledger"."Amount (LCY)")
                {
                }
                column(GlobalDimension1Code_CustVendLedger;"Cust-Vend Ledger"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_CustVendLedger;"Cust-Vend Ledger"."Global Dimension 2 Code")
                {
                }
                column(DebitAmount_CustVendLedger;"Cust-Vend Ledger"."Debit Amount")
                {
                }
                column(CreditAmount_CustVendLedger;"Cust-Vend Ledger"."Credit Amount")
                {
                }
                column(DebitAmountLCY_CustVendLedger;"Cust-Vend Ledger"."Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY_CustVendLedger;"Cust-Vend Ledger"."Credit Amount (LCY)")
                {
                }
                column(DocumentDate_CustVendLedger;"Cust-Vend Ledger"."Document Date")
                {
                }
                column(ExternalDocumentNo_CustVendLedger;"Cust-Vend Ledger"."External Document No.")
                {
                }
                column(PartyName_CustVendLedger;"Cust-Vend Ledger"."Party Name")
                {
                }
                column(DrCrIndicator;DrCrIndicator)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DrCrIndicator := '';
                    CumulativeBal += Amount;
                    NepaliDate := '';
                    NepaliCalendar.RESET;
                    NepaliCalendar.SETRANGE("English Date","Posting Date");
                    IF NepaliCalendar.FINDFIRST THEN
                      NepaliDate := NepaliCalendar."Nepali Date";
                    IF CumulativeBal > 0 THEN
                      DrCrIndicator := Debit
                    ELSE
                      DrCrIndicator := Credit;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpeningBal := 0;
                RunningBalance := 0;
                CustVendLedger.RESET;
                CustVendLedger.SETRANGE("Party Name",Customer.Name);
                CustVendLedger.SETFILTER("Posting Date",'<%1',StartEngDate);
                IF ProductFilter <> '' THEN
                  CustVendLedger.SETFILTER("Global Dimension 1 Code",ProductFilter);
                IF CustVendLedger.FINDFIRST THEN REPEAT
                  OpeningBal += CustVendLedger.Amount;
                UNTIL CustVendLedger.NEXT = 0;
                RunningBalance := OpeningBal;
                CumulativeBal := OpeningBal;
            end;
        }
    }

    requestpage
    {

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
        AllFilters := Customer.GETFILTERS;
        DateFilter := Customer.GETFILTER("Date Filter");
        ProductFilter := Customer.GETFILTER("Global Dimension 1 Filter");

        //KMT2016CU5 >>
        IF DateFilter <> '' THEN BEGIN
          StartDateNep := '';
          EndDateNep := '';
          StartEngDate := 0D;
          EndEngDate := 0D;
          CompanyInfo.GET;
          StartEngDate := Customer.GETRANGEMIN("Date Filter");
          EndEngDate := Customer.GETRANGEMAX("Date Filter");
          NepaliCal.RESET;
          NepaliCal.SETRANGE("English Date",StartEngDate);
          IF NepaliCal.FINDFIRST THEN
              StartDateNep := NepaliCal."Nepali Date";

          NepaliCal.RESET;
          NepaliCal.SETRANGE("English Date",EndEngDate);
          IF NepaliCal.FINDFIRST THEN
            EndDateNep := NepaliCal."Nepali Date";
        END;
        //KMT2016CU5 <<
    end;

    var
        AllFilters: Text;
        CompanyInfo: Record "Company Information";
        PageNoCaptionLbl: Label 'Page';
        ReportCaption: Label 'Customer-Vendor Detail Trial';
        CustVendLedger: Record "Cust-Vend Ledger";
        OpeningBal: Decimal;
        RunningBalance: Decimal;
        DateFilter: Text;
        ProductFilter: Text;
        NepaliDate: Code[20];
        NepaliCalendar: Record "English-Nepali Date";
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        CumulativeBal: Decimal;
        DrCrIndicator: Text;
        Debit: Label 'Dr.';
        Credit: Label 'Cr.';
}

