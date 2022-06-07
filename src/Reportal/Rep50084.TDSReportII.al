report 50084 "TDS Report II"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TDSReportII.rdlc';

    dataset
    {
        dataitem(DataItem1; Table17)
        {
            DataItemTableView = WHERE (TDS Group=FILTER(<>''),
                                      G/L Account No.=FILTER(<>2262100&<>2262200));
            RequestFilterFields = "Posting Date","G/L Account No.";
            column(AllFilters;AllFilters)
            {
            }
            column(HideDetail;HideDetail)
            {
            }
            column(BalAccountNo_GLEntry;"G/L Entry"."Bal. Account No.")
            {
            }
            column(GLAccountName_GLEntry;"G/L Entry"."G/L Account Name")
            {
            }
            column(GLAccountNo_GLEntry;"G/L Entry"."G/L Account No.")
            {
            }
            column(TDSGroup_GLEntry;"G/L Entry"."TDS Group")
            {
            }
            column(TDS_GLEntry;"G/L Entry"."TDS%")
            {
            }
            column(TDSType_GLEntry;"G/L Entry"."TDS Type")
            {
            }
            column(TDSAmount_GLEntry;"G/L Entry"."TDS Amount")
            {
            }
            column(TDSBaseAmount_GLEntry;"G/L Entry"."TDS Base Amount")
            {
            }
            column(DocumentNo_GLEntry;"G/L Entry"."Document No.")
            {
            }
            column(VendorNo;VendorNo)
            {
            }
            column(VendorName;VendorName)
            {
            }
            column(PANNo;PANNo )
            {
            }
            column(IRDDate;FORMAT(IRDDate))
            {
            }
            column(IRDNo;IRDNo)
            {
            }
            column(GLEntry_PostingDate;FORMAT("G/L Entry"."Posting Date"))
            {
            }
            column(DebitAmount;DebitAmount)
            {
            }
            column(CreditAmount;CreditAmount)
            {
            }
            column(OpeningAmount;OpeningAmount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                VendorNo := '';
                VendorName := '';
                PANNo := '';
                TDSRec.RESET;
                TDSRec.SETRANGE("Transaction No.","Transaction No.");
                IF TDSRec.FINDFIRST THEN BEGIN
                  IF VendorRec.GET(TDSRec."Bill-to/Pay-to No.") THEN BEGIN
                    VendorNo := TDSRec."Bill-to/Pay-to No.";
                    IF VendorName = '' THEN
                      VendorName := VendorRec.Name;
                    PANNo := VendorRec."VAT Registration No.";
                  END;
                  IRDNo := TDSRec."IRD Voucher No.";
                  IRDDate := TDSRec."IRD Voucher Date";
                END;

                IF LastVendor <> "Party No." THEN BEGIN
                  LastVendor := "Party No.";
                  DebitAmount :=0;
                  CreditAmount := 0;

                  TDSRec.RESET;
                  TDSRec.SETFILTER("Posting Date", '<%1', "G/L Entry".GETRANGEMIN("Posting Date"));
                  TDSRec.SETRANGE(Closed, FALSE);
                  TDSRec.SETRANGE("Bill-to/Pay-to No.","Party No.");
                  TDSRec.CALCSUMS("TDS Amount");
                  OpeningAmount := TDSRec."TDS Amount";

                //  TDSRec.RESET;
                //  TDSRec.SETFILTER("Posting Date", '<%1', "G/L Entry".GETRANGEMIN("Posting Date"));
                //  TDSRec.SETRANGE(Closed, FALSE);
                //  TDSRec.CALCSUMS("TDS Amount");
                //  OpeningAmount -= TDSRec."TDS Amount";
                END;

                IF TDSRec.Closed THEN
                  DebitAmount := Amount;

                CreditAmount := Amount;
            end;

            trigger OnPreDataItem()
            begin
                SETCURRENTKEY("TDS Group","Party No.");
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
                    field("Hide Detail";HideDetail)
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
        AllFilters := "G/L Entry".GETFILTERS;
    end;

    var
        AllFilters: Text;
        VendorNo: Code[20];
        VendorName: Text[50];
        IRDNo: Code[50];
        IRDDate: Date;
        VendorRec: Record "23";
        TDSRec: Record "50009";
        PANNo: Text;
        [InDataSet]
        HideDetail: Boolean;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        LastVendor: Code[20];
        OpeningAmount: Decimal;
}

