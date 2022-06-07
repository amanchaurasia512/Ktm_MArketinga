report 50449 "LC Detail Trial Balance Under"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LCDetailTrialBalanceUnder.rdlc';

    dataset
    {
        dataitem("Document Class Master"; "Document Class Master")
        {
            DataItemTableView = SORTING("Doc. Class Type", "Doc. Class No.")
                                WHERE("Doc. Class Type" = CONST("Letter of Credit/Telex Transfer"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Doc. Class Type", "Doc. Class No.", "Date Filter";
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
            column(OpeningBalDrCr; OpeningBalDrCr)
            {
            }
            column(AllFilters; DocClassFilter)
            {
            }
            column(ReportHeading; ReportHeading)
            {
            }
            column(Summary; Summary)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Letter of Credit/Telex Trans." = FIELD("Doc. Class No."),
                               "Posting Date" = FIELD("Date Filter"),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter");
                DataItemTableView = WHERE("Letter of Credit/Telex Trans." = FILTER(<> ''));
                column(PostingDate_GLEntry; FORMAT("G/L Entry"."Posting Date"))
                {
                }
                column(ExternalDocumentNo_GLEntry; "G/L Entry"."External Document No.")
                {
                }
                column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
                {
                }
                column(Description_GLEntry; "G/L Entry".Description)
                {
                }
                column(DebitAmount_GLEntry; "G/L Entry"."Debit Amount")
                {
                }
                column(CreditAmount_GLEntry; "G/L Entry"."Credit Amount")
                {
                }
                column(RunningBalance; RunningBalance)
                {
                }
                column(SourceName; SourceName)
                {
                }
                column(DrCrIndication; DrCrIndication)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    SourceName := '';
                    IF "Source Type" = "G/L Entry"."Source Type"::Vendor THEN BEGIN
                        Vendor.RESET;
                        Vendor.SETRANGE("No.", "Source No.");
                        //Vendor.SETRANGE("Gen. Bus. Posting Group", 'IMPORT'); //pram
                        IF Vendor.FINDFIRST THEN
                            SourceName := Vendor.Name
                    END ELSE
                        IF "G/L Entry"."Source Type" = "G/L Entry"."Source Type"::"Bank Account" THEN BEGIN
                            BankAcc.RESET;
                            BankAcc.SETRANGE("No.", "Source No.");
                            IF BankAcc.FINDFIRST THEN
                                SourceName := BankAcc.Name;
                        END;

                    RunningBalance := RunningBalance + Amount;
                    IF RunningBalance > 0 THEN
                        DrCrIndication := 'Dr.'
                    ELSE
                        DrCrIndication := 'Cr.';
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("G/L Account No.", GLAccFilter);
                    //SETCURRENTKEY("Posting Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RunningBalance := 0;
                StartBalance := 0;
                OpeningBalance := 0;
                GLEntry.RESET;
                GLEntry.SETFILTER("Letter of Credit/Telex Trans.", "Doc. Class No.");
                GLEntry.SETFILTER("G/L Account No.", GLAccFilter);
                GLEntry.SETFILTER("Posting Date", '<%1', StartEngDate);
                GLEntry.CALCSUMS(Amount);
                StartBalance := GLEntry.Amount;
                /*IF GLEntry.FINDSET THEN REPEAT
                  StartBalance += GLEntry.Amount;
                UNTIL GLEntry.NEXT = 0;*/

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
                //RESET;
                //SETRANGE("Doc. Class Type","Doc. Class Type"::"Letter of Credit/Telex Transfer");
                //"Document Class Master".SETCURRENTKEY("Document Class Master"."Doc. Class No.");
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
                    field(Summary; Summary)
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
        DocClassFilter := "Document Class Master".GETFILTERS; //"G/L Entry".GETFILTERS;
        DateFilter := "Document Class Master".GETFILTER("Date Filter"); //"G/L Entry".GETFILTER("Posting Date");
        GLAccFilter := '3214100|3213100';
        CompanyInfo.GET;
        IF DateFilter <> '' THEN BEGIN
            StartDateNep := '';
            EndDateNep := '';
            StartEngDate := 0D;
            EndEngDate := 0D;

            StartEngDate := "G/L Entry".GETRANGEMIN("Posting Date");
            EndEngDate := "G/L Entry".GETRANGEMAX("Posting Date");
            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", StartEngDate);
            IF NepaliCal.FINDFIRST THEN
                StartDateNep := NepaliCal."Nepali Date";

            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", EndEngDate);
            IF NepaliCal.FINDFIRST THEN
                EndDateNep := NepaliCal."Nepali Date";
        END;
    end;

    var
        LCBoolean: Boolean;
        TRBoolean: Boolean;
        GLEntry: Record "G/L Entry";
        OpeningBalance: Decimal;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        CompanyInfo: Record "Company Information";
        DateFilter: Text;
        DocClassFilter: Text;
        StartBalance: Decimal;
        ReportHeading: Label 'LC Detail Trial Bal.';
        ReportTitle: Text;
        CurrReport_PAGENOCaption: Label 'Page';
        SourceName: Text;
        Vendor: Record Vendor;
        RunningBalance: Decimal;
        BankAcc: Record "Bank Account";
        DrCrIndication: Text;
        OpeningBalDrCr: Text;
        GLAccFilter: Code[20];
        Summary: Boolean;
}

