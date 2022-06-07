report 50436 "Item Charge - Detail Trial"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ItemChargeDetailTrial.rdlc';

    dataset
    {
        dataitem("Item Charge"; "Item Charge")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(AllFilters; AllFilters)
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyOneLineAddress; CompanyOneLineAddress)
            {
            }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress)
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo.FIELDCAPTION("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.")
            {
            }
            column(No_ItemCharge; "Item Charge"."No.")
            {
            }
            column(Description_ItemCharge; "Item Charge".Description)
            {
            }
            column(ShowSummary; ShowSummary)
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Charge No." = FIELD("No."),
                               "Posting Date" = FIELD("Date Filter");
                DataItemTableView = SORTING("Posting Date")
                                    WHERE("Item Charge No." = FILTER(<> ''));
                RequestFilterFields = "Posting Date", "Item Charge No.", "Source Type", "Source No.";
                column(PostingDate_ValueEntry; FORMAT("Value Entry"."Posting Date"))
                {
                }
                column(ItemLedgerEntryType_ValueEntry; "Value Entry"."Item Ledger Entry Type")
                {
                }
                column(DocumentNo_ValueEntry; "Value Entry"."Document No.")
                {
                }
                column(Description_ValueEntry; "Value Entry".Description)
                {
                }
                column(CostperUnit_ValueEntry; "Value Entry"."Cost per Unit")
                {
                }
                column(PragyapanPatra_ValueEntry; "Value Entry".PragyapanPatra)
                {
                }
                column(LetterofCreditTelexTrans_ValueEntry; "Value Entry"."Letter of Credit/Telex Trans.")
                {
                }
                column(PurchaseAmountActual_ValueEntry; "Value Entry"."Purchase Amount (Actual)")
                {
                }
                column(PurchaseAmountExpected_ValueEntry; "Value Entry"."Purchase Amount (Expected)")
                {
                }
                column(CostAmountActual_ValueEntry; "Value Entry"."Cost Amount (Actual)")
                {
                }
                column(CostAmountExpected_ValueEntry; "Value Entry"."Cost Amount (Expected)")
                {
                }
                column(DrAmt; DrAmt)
                {
                }
                column(CrAmt; CrAmt)
                {
                }
                column(RunningBal; RunningBal)
                {
                }
                column(NepalliDate; NepalliDate)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DrAmt := 0;
                    CrAmt := 0;
                    IF "Cost Amount (Actual)" < 0 THEN
                        CrAmt := "Cost Amount (Actual)"
                    ELSE
                        IF "Value Entry"."Cost Amount (Actual)" > 0 THEN
                            DrAmt := "Cost Amount (Actual)";
                    RunningBal += "Cost Amount (Actual)";
                    NepalliDate := IRDMgt.getNepaliDate("Value Entry"."Posting Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RunningBal := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Show Summary"; ShowSummary)
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

    trigger OnInitReport()
    begin
        "Value Entry"."Source Type" := "Value Entry"."Source Type"::Vendor;
        "Value Entry".SETRANGE("Source Type", "Value Entry"."Source Type"::Vendor);
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;
        IF "Value Entry".GETFILTER("Source No.") <> '' THEN
            IF Vendor.GET("Value Entry".GETFILTER("Source No.")) THEN
                AllFilters += Vendor.Name + ', ';

        AllFilters += "Item Charge".GETFILTERS + "Value Entry".GETFILTERS;
    end;

    var
        CompanyInfo: Record "Company Information";
        AllFilters: Text;
        ReportTitle: Label 'Item Charges Details';
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        CompanyAddr: array[8] of Text[50];
        IRDMgt: Codeunit "IRD Mgt.";
        FormatAddr: Codeunit "Format Address";
        DrAmt: Decimal;
        CrAmt: Decimal;
        RunningBal: Decimal;
        ShowSummary: Boolean;
        Vendor: Record Vendor;
        NepalliDate: Code[20];

    local procedure GetCompanyOneLineAddress()
    begin
        CompanyAddr[1] := CompanyInfo.Name;
        IF CompanyInfo."Phone No." <> '' THEN
            CompanyOneLineAddress := IRDMgt.OneLineAddress(CompanyAddr) + ', ' + CompanyInfo.FIELDCAPTION("Phone No.") + ' : ' + CompanyInfo."Phone No."
        ELSE
            CompanyOneLineAddress := IRDMgt.OneLineAddress(CompanyAddr);

        IF CompanyInfo."Fax No." <> '' THEN
            CompanyCommunicationAddress := CompanyInfo.FIELDCAPTION("Fax No.") + ' : ' + CompanyInfo."Fax No.";
        IF (CompanyCommunicationAddress <> '') AND (CompanyInfo."E-Mail" <> '') THEN
            CompanyCommunicationAddress += ', ' + CompanyInfo.FIELDCAPTION("E-Mail") + ' : ' + CompanyInfo."E-Mail";
    end;
}

