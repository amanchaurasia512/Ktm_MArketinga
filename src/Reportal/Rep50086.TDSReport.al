report 50086 "TDS Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TDSReport.rdlc';

    dataset
    {
        dataitem(DataItem1; Table50009)
        {
            RequestFilterFields = "Source Type", "Bill-to/Pay-to No.", "TDS Posting Group", "Posting Date";
            column(DocumentNo_TDSEntry; "TDS Entry"."Document No.")
            {
            }
            column(SourceType_TDSEntry; "TDS Entry"."Source Type")
            {
            }
            column(BilltoPaytoNo_TDSEntry; "TDS Entry"."Bill-to/Pay-to No.")
            {
            }
            column(TDSPostingGroup_TDSEntry; "TDS Entry"."TDS Posting Group")
            {
            }
            column(TDSPercen_TDSEntry; "TDS Entry"."TDS%")
            {
            }
            column(PaymentAmount; "TDS Entry".Base)
            {
            }
            column(TDSAmount_TDSEntry; "TDS Entry"."TDS Amount")
            {
            }
            column(GLAccount_TDSEntry; "TDS Entry"."GL Account")
            {
            }
            column(VendorName_TDSEntry; "TDS Entry"."Source Name")
            {
            }
            column(GLAccountName_TDSEntry; "TDS Entry"."GL Account Name")
            {
            }
            column(TaxRevenueCode; TDSPostingGr."Tax Revenue Code")
            {
            }
            column(PANNo; PANNo)
            {
            }
            column(SourceName; SourceName)
            {
            }
            column(AllFilter; AllFilter)
            {
            }
            column(ShowSummary; ShowSummary)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF TDSPostingGr.GET("TDS Entry"."TDS Posting Group") THEN;

                IF MainGLAccount.GET("TDS Entry"."Main G/L Account") THEN;


                SourceName := '';
                PANNo := '';
                IF "TDS Entry"."Source Type" = "TDS Entry"."Source Type"::Customer THEN BEGIN
                    Cust.GET("TDS Entry"."Bill-to/Pay-to No.");
                    SourceName := Cust.Name;
                    PANNo := Cust."VAT Registration No.";
                END ELSE
                    IF "TDS Entry"."Source Type" = "TDS Entry"."Source Type"::Vendor THEN BEGIN
                        Vend.GET("TDS Entry"."Bill-to/Pay-to No.");
                        SourceName := Vend.Name;
                        PANNo := Vend."VAT Registration No.";
                    END;
            end;

            trigger OnPreDataItem()
            begin
                IF "TDS Entry".GETFILTER("Source Type") = '' THEN
                    ERROR('%1 must have a value', "TDS Entry".FIELDCAPTION("Source Type"));
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ShowSummary; ShowSummary)
                {
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
        AllFilter := "TDS Entry".GETFILTERS;
    end;

    var
        Allfilters: Text;
        PANNo: Code[30];
        SourceName: Text;
        Cust: Record "18";
        Vend: Record "23";
        TDSPostingGr: Record "50008";
        MainGLAccount: Record "15";
        AllFilter: Text;
        ShowSummary: Boolean;
}

