report 50445 "Landed Cost Sheet Test FA"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LandedCostSheetTestFA.rdlc';
    Caption = 'Landed Cost Sheet Test FA';

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = WHERE(PragyapanPatra = FILTER(<> ''));
            RequestFilterFields = "Global Dimension 1 Code", "Posting Date", "Item No.";
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(HideDBMargin; HideDBMargin)
            {
            }
            column(ShowSummary; ShowSummary)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            column(ValueEntryFilters; ValueEntryFilters)
            {
            }
            column(LetterofCreditTelexTrans_ValueEntry; "Value Entry"."Letter of Credit/Telex Trans.")
            {
            }
            column(ItemName_ValueEntry; "Value Entry"."Item Name")
            {
            }
            column(PostingDate_ValueEntry; "Value Entry"."Posting Date")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(Cost_Amount_Actual; "Cost Amount (Actual)")
            {
            }
            column(Invoiced_Quantity; "Invoiced Quantity")
            {
            }
            column(ColumnName; ColumnName)
            {
            }
            column(itemname; itemname)
            {
            }
            column(SalesPriceDB; SalesPriceDB)
            {
            }
            column(MarginPercentage; MarginPercentage)
            {
            }
            column(PragyapanPatra_No; "Value Entry".PragyapanPatra)
            {
            }
            column(CustomValue; TotalCustomAmount)
            {
            }
            column(GrandTotalCustomAmount; GrandTotalCustomAmount)
            {
            }
            column(GrandDifference; GrandDifference)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF (PragyapanPatra = '') THEN
                    CurrReport.SKIP;

                IF ("Entry Type" = "Entry Type"::Rounding) AND ("Document Type" = "Document Type"::"Purchase Invoice") THEN
                    CurrReport.SKIP;
                //IF ABS("Cost Amount (Actual)") < 1 THEN //pram
                // CurrReport.SKIP;

                IF "Item Charge No." = '' THEN
                    ColumnName := Text1001
                ELSE
                    ColumnName := "Item Charge No.";

                item.SETRANGE("No.", "Item No.");
                IF item.FINDFIRST THEN
                    itemname := item.Description;

                //KMT2016CU5 >>
                SalesPriceDB := 0;
                MarginPercentage := 0;
                SalesPrice.RESET;
                SalesPrice.SETRANGE("Item No.", "Item No.");
                SalesPrice.SETFILTER("Sales Code", 'DV');
                SalesPrice.SETFILTER("Ending Date", '%1', 0D);
                IF DateFilter <> '' THEN BEGIN
                    SalesPrice.SETFILTER("Starting Date", DateFilter);
                    IF NOT SalesPrice.FINDFIRST THEN BEGIN
                        SalesPrice.SETFILTER("Starting Date", '<%1', "Value Entry".GETRANGEMIN("Posting Date"));
                        IF SalesPrice.FINDFIRST THEN BEGIN
                            SalesPriceDB := SalesPrice."Unit Price";
                            IF "Value Entry"."Cost per Unit" <> 0 THEN BEGIN
                                MarginPercentage := (SalesPrice."Unit Price" - "Value Entry"."Cost per Unit") / "Value Entry"."Cost per Unit" * 100;
                            END;
                        END;
                    END
                    ELSE BEGIN
                        SalesPriceDB := SalesPrice."Unit Price";
                        IF "Value Entry"."Cost per Unit" <> 0 THEN BEGIN
                            MarginPercentage := (SalesPrice."Unit Price" - "Value Entry"."Cost per Unit") / "Value Entry"."Cost per Unit" * 100;
                        END;
                    END;
                END;
                TotalCustomAmount := 0;
                VATEntries.RESET;
                VATEntries.SETRANGE(PragyapanPatra, PragyapanPatra);
                VATEntries.SETRANGE("VAT Prod. Posting Group", 'VATCUSTOM');
                IF VATEntries.FINDFIRST THEN
                    TotalCustomAmount := VATEntries."VAT Base 1" + VATEntries."Exempt Amount";
                //KMT2016CU5 <<
                //pram
                IF LastPragyapan <> PragyapanPatra THEN BEGIN
                    LastPragyapan := PragyapanPatra;
                    GrandTotalCustomAmount += TotalCustomAmount;
                END;
                TotalActual += "Cost Amount (Actual)";
                GrandDifference := GrandTotalCustomAmount - TotalActual;
                //end
            end;

            trigger OnPreDataItem()
            begin
                IF pragyapan <> '' THEN
                    "Value Entry".SETRANGE("Value Entry".PragyapanPatra, pragyapan);
                IF DateFilter <> '' THEN
                    "Value Entry".SETFILTER("Posting Date", DateFilter);

                SETCURRENTKEY(PragyapanPatra);
            end;
        }
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = WHERE(Type = CONST("Fixed Asset"),
                                      PragyapanPatra = FILTER(<> ''));
            column(FANo; Description)
            {
            }
            column(PragyapanPatra; PragyapanPatra)
            {
            }
            column(LetterofCreditTelexTrans_PurchInvLine; "Purch. Inv. Line"."Letter of Credit/Telex Trans.")
            {
            }
            column(LineAmount_PurchInvLine; "Purch. Inv. Line"."Line Amount")
            {
            }
            column(FAItemCharge_PurchInvLine; "Purch. Inv. Line"."FA Item Charge")
            {
            }
            column(ColumnName2; ColumnName)
            {
            }
            column(PostingDate_PurchInvLine; FORMAT("Purch. Inv. Line"."Posting Date"))
            {
            }
            column(Quantity_PurchInvLine; FAInvQty)
            {
            }
            column(CustomValue2; TotalCustomAmount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "FA Item Charge" = '' THEN
                    ColumnName := Text1001
                ELSE
                    ColumnName := "FA Item Charge";

                IF "Purch. Inv. Line"."FA Item Charge" <> '' THEN
                    FAInvQty := 0
                ELSE
                    FAInvQty := "Purch. Inv. Line".Quantity;

                TotalCustomAmount := 0;
                FALedgEntry.RESET;
                FALedgEntry.SETRANGE(PragyapanPatra, PragyapanPatra);
                FALedgEntry.SETRANGE("FA Item Charge", "FA Item Charge");
                IF FALedgEntry.FINDFIRST THEN
                    IF FALedgEntry."FA Item Charge" <> '' THEN
                        TotalCustomAmount := FALedgEntry.Amount;
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("Posting Date", "Value Entry".GETFILTER("Posting Date"));
                IF pragyapan <> '' THEN
                    SETRANGE(PragyapanPatra, pragyapan);
                SETCURRENTKEY(PragyapanPatra);
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
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Purchase Consignment';
                        Visible = false;
                    }
                    field(pragyapan; pragyapan)
                    {
                        CaptionClass = 'Pragyapanpatra No.';
                        Lookup = true;
                        TableRelation = "Document Class Master"."Doc. Class No." WHERE("Doc. Class Type" = CONST(PragyapanPatra));
                        Visible = true;
                    }
                    field(HideDBMargin; HideDBMargin)
                    {
                        Caption = 'Hide DV Price and Margin';
                    }
                    field(ShowSummary; ShowSummary)
                    {
                        Caption = 'Show Summary Only';
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

    trigger OnInitReport()
    begin
        CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
        CompanyInfo.GET;
    end;

    trigger OnPreReport()
    begin
        DateFilter := "Value Entry".GETFILTER("Posting Date");
        ValueEntryFilters := "Value Entry".GETFILTERS;
        IF DateFilter <> '' THEN BEGIN
            StartDateNep := '';
            EndDateNep := '';
            StartEngDate := 0D;
            EndEngDate := 0D;
            StartEngDate := "Value Entry".GETRANGEMIN("Posting Date");
            EndEngDate := "Value Entry".GETRANGEMAX("Posting Date");
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
        PurchaseConsignmentFilter: Text;
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        ColumnName: Code[20];
        Text1001: Label '1.Purchase Amt(NRS)';
        itemname: Text[100];
        itemledgentry: Record "Item Ledger Entry";
        pragyapan: Code[10];
        item: Record Item;
        CompanyInfo: Record "Company Information";
        DateFilter: Text[30];
        AllFilters: Text;
        ValueEntryFilters: Text;
        SalesPriceDB: Decimal;
        SalesPrice: Record "Sales Price";
        MarginPercentage: Decimal;
        HideDBMargin: Boolean;
        ShowSummary: Boolean;
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        VATEntries: Record "VAT Entry";
        TotalCustomAmount: Decimal;
        GrandTotalCustomAmount: Decimal;
        LastPragyapan: Text;
        GrandDifference: Decimal;
        TotalActual: Decimal;
        FALedgEntry: Record "FA Ledger Entry";
        FAInvQty: Decimal;
        FAPurchAmt: Decimal;

    [Scope('OnPrem')]
    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintReversedEntries: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        //ExcludeBalanceOnly := NewExcludeBalanceOnly;
        //PrintReversedEntries := NewPrintReversedEntries;
    end;
}

