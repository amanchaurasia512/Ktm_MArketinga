report 50051 "TR Detail Trial Bal."
{
    DefaultLayout = RDLC;
    RDLCLayout = './TRDetailTrialBal.rdlc';

    dataset
    {
        dataitem("Document Class Master";"Document Class Master")
        {
            DataItemTableView = SORTING ("Doc. Class Type", "Doc. Class No.");
            PrintOnlyIfDetail = true;
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
            column(DocClassNo_DocumentClassMaster; "Document Class Master"."Doc. Class No.")
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            column(Balance; StartBalance)
            {
            }
            column(OpeningBal; OpeningBalance)
            {
            }
            column(AllFilters; DocClassFilter)
            {
            }
            column(ReportHeading; ReportHeading)
            {
            }
            column(OpeningBalDrCr; OpeningBalDrCr)
            {
            }
            column(Summary; Summary)
            {
            }
            dataitem("G/L Entry";"G/L Entry")
            {
                DataItemLink = Loan = FIELD ("Doc. Class No."),
                               "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                               "G/L Account No."=FIELD("G/L Account Filter");
                DataItemTableView = WHERE(Loan=FILTER(<>''));
                RequestFilterFields = "G/L Account No.","Posting Date",Loan,"Source Type","Source No.";
                column(Loan_GLEntry;"G/L Entry".Loan)
                {
                }
                column(PostingDate_GLEntry;"G/L Entry"."Posting Date")
                {
                }
                column(ExternalDocumentNo_GLEntry;"G/L Entry"."External Document No.")
                {
                }
                column(DocumentNo_GLEntry;"G/L Entry"."Document No.")
                {
                }
                column(Description_GLEntry;"G/L Entry".Description)
                {
                }
                column(DebitAmount_GLEntry;"G/L Entry"."Debit Amount")
                {
                }
                column(CreditAmount_GLEntry;"G/L Entry"."Credit Amount")
                {
                }
                column(RunningBalance;RunningBalance)
                {
                }
                column(SourceName;SourceName)
                {
                }
                column(DrCrIndication;DrCrIndication)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RunningBalance := RunningBalance + Amount;
                    SourceName := '';
                    IF "Source Type" = "G/L Entry"."Source Type" :: Vendor THEN BEGIN
                      Vendor.RESET;
                      Vendor.SETRANGE("No.","Source No.");
                      IF Vendor.FINDFIRST THEN
                        SourceName := Vendor.Name;
                    END
                    ELSE IF "G/L Entry"."Source Type" = "G/L Entry"."Source Type"::"Bank Account" THEN BEGIN
                      BankAcc.RESET;
                      BankAcc.SETRANGE("No.","Source No.");
                      IF BankAcc.FINDFIRST THEN
                        SourceName := BankAcc.Name;
                    END;
                    IF RunningBalance > 0 THEN
                      DrCrIndication := 'Dr.'
                    ELSE
                      DrCrIndication := 'Cr.';
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("G/L Account No.",GLAccFilter);
                    SETCURRENTKEY(Loan, "Posting Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RunningBalance := 0;
                StartBalance := 0;
                OpeningBalance := 0;
                GLEntry.RESET;
                GLEntry.SETFILTER(Loan,"Doc. Class No.");
                GLEntry.SETFILTER("G/L Account No.",GLAccFilter);
                GLEntry.SETFILTER("Posting Date",'<%1',StartEngDate);
                IF GLEntry.FINDSET THEN REPEAT
                  StartBalance += GLEntry.Amount;
                UNTIL GLEntry.NEXT = 0;

                OpeningBalance := StartBalance;
                RunningBalance := StartBalance;
                IF OpeningBalance < 0 THEN
                  OpeningBalDrCr := 'Cr.';
                IF OpeningBalance > 0 THEN
                  OpeningBalDrCr := 'Dr.';
                IF OpeningBalance = 0 THEN
                  OpeningBalDrCr := '';
            end;

            trigger OnPreDataItem()
            begin
                RESET;
                SETRANGE("Doc. Class Type","Doc. Class Type"::"T/R");
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
                group(Option)
                {
                    field(Summary;Summary)
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
        DocClassFilter := "G/L Entry".GETFILTERS; //"Document Class Master".GETFILTERS;
        DateFilter := "G/L Entry".GETFILTER("Posting Date");
        GLAccFilter := '3211100';
        IF DateFilter <> '' THEN BEGIN
          StartDateNep := '';
          EndDateNep := '';
          StartEngDate := 0D;
          EndEngDate := 0D;
          StartEngDate := "G/L Entry".GETRANGEMIN("Posting Date");
          EndEngDate := "G/L Entry".GETRANGEMAX("Posting Date");
          NepaliCal.RESET;
          NepaliCal.SETRANGE("English Date",StartEngDate);
          IF NepaliCal.FINDFIRST THEN
              StartDateNep := NepaliCal."Nepali Date";

          NepaliCal.RESET;
          NepaliCal.SETRANGE("English Date",EndEngDate);
          IF NepaliCal.FINDFIRST THEN
            EndDateNep := NepaliCal."Nepali Date";
        END;
        CompanyInfo.GET;
    end;

    var
        LCBoolean: Boolean;
        TRBoolean: Boolean;
        GLEntry: Record "G/L Entry";
        OpeningBalance: Decimal;
        StartDateNep: Code[20];
        EndDateNep: Code[20];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        CompanyInfo: Record "Company Information";
        DateFilter: Text;
        DocClassFilter: Text;
        StartBalance: Decimal;
        ReportTitle: Text;
        CurrReport_PAGENOCaption: Label 'Page';
        SourceName: Text;
        Vendor: Record Vendor;
        RunningBalance: Decimal;
        BankAcc: Record "Bank Account";
        ReportHeading: Label 'TR Detail Trial Bal.';
        ShowSummary: Boolean;
        DrCrIndication: Text;
        OpeningBalDrCr: Text;
        GLAccFilter: Code[20];
        Summary: Boolean;
}

