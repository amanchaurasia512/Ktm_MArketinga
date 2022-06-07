report 50433 "Employee Dimension Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EmployeeDimensionDetail.rdlc';
    Caption = 'Employee Detail Trial';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            RequestFilterFields = "G/L Account Filter", "Date Filter";
            column(AllFilters; AllFilters)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyVATNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            column(OpeningBal; OpeningBalance)
            {
            }
            column(OpeningBalDrCr; OpeningBalDrCr)
            {
            }
            column(ReportHeading; ReportHeading)
            {
            }
            column(Code_DimensionValue; "Dimension Value".Code)
            {
            }
            column(Name_DimensionValue; "Dimension Value".Name)
            {
            }
            column(ShowSummary; ShowSummary)
            {
            }
            column(GLAccFilter; GLAccFilter)
            {
            }
            column(TotalBalance; TotalBalance)
            {
            }
            column(HasDetail; HasDetail)
            {
            }
            column(TotalOpening; TotalOpening)
            {
            }
            dataitem("G/L Entry";"G/L Entry")
            {
                DataItemLink = "Employee Code"=FIELD(Code),
                              "Posting Date"=FIELD("Date Filter"),
                               "G/L Account No."=FIELD("G/L Account Filter");
                DataItemTableView = SORTING("Posting Date");
                column(DebitAmount_GLEntry;"G/L Entry"."Debit Amount")
                {
                }
                column(CreditAmount_GLEntry;"G/L Entry"."Credit Amount")
                {
                }
                column(PostingDate_GLEntry;FORMAT("G/L Entry"."Posting Date"))
                {
                }
                column(DocumentNo_GLEntry;"G/L Entry"."Document No.")
                {
                }
                column(Description_GLEntry;"G/L Entry".Description)
                {
                }
                column(DrCrIndication;DrCrIndication)
                {
                }
                column(Balance;RunningBalance)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DrCrIndication := '';
                    RunningBalance += Amount;
                    TotalBalance += Amount;
                    IF RunningBalance > 0 THEN
                      DrCrIndication := 'Dr.'
                    ELSE
                      DrCrIndication := 'Cr.';
                end;

                trigger OnPreDataItem()
                begin
                    //SETFILTER("Employee Code",'<>%1','')

                    SETFILTER("G/L Account No.", GLAccFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpeningBalDrCr := '';
                OpeningBalance := 0;
                RunningBalance := 0;
                GLEntry.RESET;
                GLEntry.SETRANGE("Employee Code",Code);
                GLEntry.SETFILTER("G/L Account No.",GLAccFilter);
                GLEntry.SETFILTER("Posting Date",'<%1',StartEngDate);
                IF GLEntry.FINDFIRST THEN REPEAT
                  OpeningBalance += GLEntry.Amount;
                UNTIL GLEntry.NEXT = 0;
                RunningBalance := OpeningBalance;
                IF OpeningBalance < 0 THEN
                  OpeningBalDrCr := 'Cr.'
                ELSE IF OpeningBalance > 0 THEN
                  OpeningBalDrCr := 'Dr.'
                ELSE IF OpeningBalance = 0 THEN
                  OpeningBalDrCr := '';


                GLEntry.RESET;
                GLEntry.SETRANGE("Employee Code",Code);
                GLEntry.SETFILTER("G/L Account No.",GLAccFilter);
                GLEntry.SETRANGE("Posting Date",StartEngDate, EndEngDate);

                IF (OpeningBalance = 0) AND (GLEntry.COUNT = 0 ) THEN
                  CurrReport.SKIP;

                TotalOpening += OpeningBalance;
                TotalBalance += OpeningBalance;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Dimension Code",'EMPLOYEE');
                IF EmployeeFilter <> '' THEN
                  SETFILTER(Code,EmployeeFilter);

                TotalBalance := 0;
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
                field("Employee Filter";EmployeeFilter)
                {
                    TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
                }
                field("G/L Account Filter";GLAccFilter)
                {
                    Visible = false;
                }
                field("Show Summary";ShowSummary)
                {
                    Caption = 'Show Summary';
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
    var
        SelectedDim: Record "Selected Dimension";
    begin
        AllFilters := "Dimension Value".GETFILTERS;
        DateFilter := "Dimension Value".GETFILTER("Date Filter");
        GLAccFilter := "Dimension Value".GETFILTER("G/L Account Filter");
        IF GLAccFilter = '' THEN
          GLAccFilter := '2231000..2231999';

        CompanyInfo.GET;
        IF DateFilter <> '' THEN BEGIN
          StartDateNep := '';
          EndDateNep := '';
          StartEngDate := 0D;
          EndEngDate := 0D;
          CompanyInfo.GET;

          StartEngDate := "Dimension Value".GETRANGEMIN("Date Filter");
          EndEngDate := "Dimension Value".GETRANGEMAX("Date Filter");
          NepaliCal.RESET;
          NepaliCal.SETRANGE("English Date",StartEngDate);
          IF NepaliCal.FINDFIRST THEN
              StartDateNep := NepaliCal."Nepali Date";

          NepaliCal.RESET;
          NepaliCal.SETRANGE("English Date",EndEngDate);
          IF NepaliCal.FINDFIRST THEN
            EndDateNep := NepaliCal."Nepali Date";
        END;
    end;

    var
        AllFilters: Text;
        OpeningBalance: Decimal;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        CompanyInfo: Record "Company Information";
        DateFilter: Text;
        RunningBalance: Decimal;
        ReportHeading: Label 'Employee Detail Trial';
        CurrReport_PAGENOCaption: Label 'Page';
        GLEntry: Record "G/L Entry";
        EmployeeFilter: Code[20];
        ShowSummary: Boolean;
        GLAccFilter: Text[250];
        DrCrIndication: Text;
        OpeningBalDrCr: Text;
        TotalBalance: Decimal;
        HasDetail: Boolean;
        TotalOpening: Decimal;
}

