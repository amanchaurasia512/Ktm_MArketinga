report 50083 "TDS Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TDSLedger.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("TDS Entry";"TDS Entry")
        {
            RequestFilterFields = "Posting Date";
            column(TDS_Posting_Group; "TDS Entry"."TDS Posting Group")
            {
            }
            column(TDS_Base; "TDS Entry".Base)
            {
            }
            column(TDS_Amount; "TDS Entry"."TDS Amount")
            {
            }
            column(TDS_Vendor_No; "TDS Entry"."Bill-to/Pay-to No.")
            {
            }
            column(Vend_VAT_Reg; Vendor."VAT Registration No.")
            {
            }
            column(VendorName; VendorName)
            {
            }
            column(TDSPostingGroupName; TDSPostingGroupName)
            {
            }
            column(Comapnay_Name; CompanyInfo.Name)
            {
            }
            column(Report_Title; Report_Title)
            {
            }
            column("Filter"; Filter)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(VendorName);
                Vendor.RESET;
                Vendor.SETRANGE("No.", "TDS Entry"."Bill-to/Pay-to No.");
                IF Vendor.FINDFIRST THEN
                    VendorName := Vendor.Name;

                CLEAR(TDSPostingGroupName);
                TDSPostingGroup.RESET;
                TDSPostingGroup.SETRANGE(TDSPostingGroup.Code, "TDS Entry"."TDS Posting Group");
                IF TDSPostingGroup.FINDFIRST THEN
                    TDSPostingGroupName := TDSPostingGroup.Description;
            end;

            trigger OnPreDataItem()
            begin
                Filter := "TDS Entry".GETFILTERS;
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
    end;

    var
        Vendor: Record Vendor;
        VendorName: Text[50];
        TDSPostingGroup: Record "TDS Posting Group";
        TDSPostingGroupName: Text[100];
        CompanyInfo: Record "Company Information";
        Report_Title: Label 'TDS Ledger';
        "Filter": Text[100];
}

