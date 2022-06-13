report 50082 "Vendor TDS Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VendorTDSLedger.rdlc';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", "Date Filter", "TDS Entry Closed Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(Company_Name; CompInfo.Name)
            {
            }
            column(Company_Address; CompInfo.Address)
            {
            }
            column(Company_Phone_No; CompInfo."Phone No.")
            {
            }
            column(No_Vendor; Vendor."No.")
            {
            }
            column(Name_Vendor; Vendor.Name)
            {
            }
            column(TDSEntryClosedFilter_Vendor; Vendor."TDS Entry Closed Filter")
            {
            }
            column(TDSBalance_Vendor; Vendor."TDS Balance")
            {
            }
            column(DateFilter_Vendor; Vendor."Date Filter")
            {
            }
            column(Vend_VAT_Reg; Vendor."VAT Registration No.")
            {
            }
            column(Opening_Amount; OpeningAmount)
            {
            }
            column(FilterText; FilterText)
            {
            }
            dataitem("TDS Entry"; "TDS Entry")
            {
                DataItemLink = "Bill-to/Pay-to No." = FIELD("No."),
                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = WHERE("TDS Type" = CONST("Purchase TDS"));
                column(Doc_No; "TDS Entry"."Document No.")
                {
                }
                column(Posting_Date; FORMAT("TDS Entry"."Posting Date"))
                {
                }
                column(TDSAmount_TDSEntry; "TDS Entry"."TDS Amount")
                {
                }
                column(Base_TDSEntry; "TDS Entry".Base)
                {
                }
                column(TDSPostingGroup_TDSEntry; "TDS Entry"."TDS Posting Group")
                {
                }
                column(Closed; "TDS Entry".Closed)
                {
                }
                column(Description; Description)
                {
                }
                column(Running_Amount; RunningAmount)
                {
                }
                column(BaseAmountDr; BaseAmountDr)
                {
                }
                column(BaseAmountCr; BaseAmountCr)
                {
                }
                column(TDSAmountDr; TDSAmountDr)
                {
                }
                column(TDSAmountCr; TDSAmountCr)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    BaseAmountCr := 0;
                    BaseAmountDr := 0;
                    TDSAmountCr := 0;
                    TDSAmountDr := 0;

                    TDSPostingGroup.RESET;
                    TDSPostingGroup.SETRANGE(Code, "TDS Posting Group");
                    IF TDSPostingGroup.FINDFIRST THEN
                        Description := TDSPostingGroup.Description;

                    RunningAmount += "TDS Entry"."TDS Amount";

                    IF Base > 0 THEN
                        BaseAmountDr := Base
                    ELSE
                        BaseAmountCr := Base * -1;

                    IF "TDS Amount" > 0 THEN
                        TDSAmountCr := "TDS Amount"
                    ELSE
                        TDSAmountDr := "TDS Amount" * -1;
                end;

                trigger OnPreDataItem()
                begin
                    FilterText += ', ' + "TDS Entry".GETFILTERS;
                    RunningAmount := 0;

                    IF NOT ShowClosedEntries THEN
                        SETRANGE(Closed, FALSE);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpeningAmount := 0;
                IF VendDateFilter <> '' THEN BEGIN
                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("TDS Balance");
                        OpeningAmount := "TDS Balance";
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                FilterText := Vendor.GETFILTERS;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Show Closed Entries"; ShowClosedEntries)
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
        CompInfo.GET;
        VendFilter := Vendor.GETFILTERS;
        VendDateFilter := Vendor.GETFILTER("Date Filter");
    end;

    var
        TDSPostingGroup: Record "TDS Posting Group";
        Description: Text[100];
        CompInfo: Record "Company Information";
        OpeningAmount: Decimal;
        VendFilter: Text;
        VendDateFilter: Text[30];
        FilterText: Text;
        RunningAmount: Decimal;
        BaseAmountDr: Decimal;
        BaseAmountCr: Decimal;
        TDSAmountDr: Decimal;
        TDSAmountCr: Decimal;
        ShowClosedEntries: Boolean;
}

