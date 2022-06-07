report 50413 "Closing Stock Report Bank"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ClosingStockReportBank.rdlc';
    Caption = 'Closing Stock Report Bank';
    EnableHyperlinks = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Inventory Posting Group")
                                WHERE(Type = CONST(Inventory));
            RequestFilterFields = "No.", "Inventory Posting Group", "Sub-Category";
            column(BoM_Text; BoM_TextLbl)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_; STRSUBSTNO('%1: %2', TABLECAPTION, ItemFilter))
            {
            }
            column(STRSUBSTNO_Text005_StartDateText_; STRSUBSTNO(Text005, StartDateText))
            {
            }
            column(STRSUBSTNO_Text005_FORMAT_EndDate__; STRSUBSTNO(Text005, FORMAT(EndDate)))
            {
            }
            column(ShowExpected; ShowExpected)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(Inventory_ValuationCaption; Inventory_ValuationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_report_includes_entries_that_have_been_posted_with_expected_costs_Caption; This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl)
            {
            }
            column(ItemNoCaption; ValueEntry.FIELDCAPTION("Item No."))
            {
            }
            column(ItemDescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(IncreaseInvoicedQtyCaption; IncreaseInvoicedQtyCaptionLbl)
            {
            }
            column(DecreaseInvoicedQtyCaption; DecreaseInvoicedQtyCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(ValueCaption; ValueCaptionLbl)
            {
            }
            column(QuantityCaption_Control31; QuantityCaption_Control31Lbl)
            {
            }
            column(QuantityCaption_Control40; QuantityCaption_Control40Lbl)
            {
            }
            column(InvCostPostedToGL_Control53Caption; InvCostPostedToGL_Control53CaptionLbl)
            {
            }
            column(QuantityCaption_Control58; QuantityCaption_Control58Lbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Expected_Cost_IncludedCaption; Expected_Cost_IncludedCaptionLbl)
            {
            }
            column(Expected_Cost_Included_TotalCaption; Expected_Cost_Included_TotalCaptionLbl)
            {
            }
            column(Expected_Cost_TotalCaption; Expected_Cost_TotalCaptionLbl)
            {
            }
            column(GetUrlForReportDrilldown; GetUrlForReportDrilldown("No."))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(ItemDescription; Description)
            {
            }
            column(ItemBaseUnitofMeasure; "Base Unit of Measure")
            {
            }
            column(Item_Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            column(StartingInvoicedValue; StartingInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingInvoicedQty; StartingInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(StartingExpectedValue; StartingExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingExpectedQty; StartingExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseInvoicedValue; IncreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseInvoicedQty; IncreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseExpectedValuerr; IncreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseExpectedQty; IncreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseInvoicedValue; DecreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseInvoicedQty; DecreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseExpectedValue; DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseExpectedQty; DecreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(EndingInvoicedValue; StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue)
            {
            }
            column(EndingInvoicedQty; StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty)
            {
            }
            column(EndingExpectedValue; StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(EndingExpectedQty; StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty)
            {
            }
            column(CostPostedToGL; CostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(InvCostPostedToGL; InvCostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(ExpCostPostedToGL; ExpCostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(EndDate; FORMAT(EndDate))
            {
            }
            column(StartDate; FORMAT(StartDate))
            {
            }
            column(RBIProductCode_Item; Item."RBI Product Code")
            {
            }
            column(ItemSalesPrice; ItemSalesPrice)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(RoundingAmount; RoundingAmount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF EndDate = 0D THEN
                    EndDate := 99991231D;

                StartingInvoicedValue := 0;
                StartingExpectedValue := 0;
                StartingInvoicedQty := 0;
                StartingExpectedQty := 0;
                IncreaseInvoicedValue := 0;
                IncreaseExpectedValue := 0;
                IncreaseInvoicedQty := 0;
                IncreaseExpectedQty := 0;
                DecreaseInvoicedValue := 0;
                DecreaseExpectedValue := 0;
                DecreaseInvoicedQty := 0;
                DecreaseExpectedQty := 0;
                InvCostPostedToGL := 0;
                CostPostedToGL := 0;
                ExpCostPostedToGL := 0;
                ProcessingCount += 1;
                IsEmptyLine := TRUE;

                ILE.RESET;
                ILE.SETRANGE("Item No.", "No.");
                ILE.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
                ILE.SETFILTER("Location Code", GETFILTER("Location Filter"));
                ILE.SETFILTER("Global Dimension 1 Code", GETFILTER("Global Dimension 1 Filter"));
                ILE.SETFILTER("Global Dimension 2 Code", GETFILTER("Global Dimension 2 Filter"));

                IF StartDate > 0D THEN BEGIN
                    ILE.SETRANGE("Posting Date", 0D, CALCDATE('<-1D>', StartDate));
                    IF ILE.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            ILE.CALCFIELDS("Cost Amount (Actual)");
                            ILE.CALCFIELDS("Cost Amount (Expected)");
                            AssignAmounts(ILE, StartingInvoicedValue, StartingInvoicedValue, StartingExpectedValue, StartingExpectedQty, 1);
                        UNTIL ILE.NEXT = 0;
                    IsEmptyLine := IsEmptyLine AND ((StartingExpectedValue = 0) AND (StartingExpectedQty = 0));
                    IsEmptyLine := IsEmptyLine AND ((StartingInvoicedValue = 0) AND (StartingInvoicedQty = 0));
                END;

                ILE.SETRANGE("Posting Date", StartDate, EndDate);
                ILE.SETFILTER("Entry Type", '%1|%2', ILE."Entry Type"::Purchase, ILE."Entry Type"::"Positive Adjmt.");
                IF ILE.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        AssignAmounts(ILE, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);
                    UNTIL ILE.NEXT = 0;

                ILE.SETRANGE("Posting Date", StartDate, EndDate);
                ILE.SETFILTER("Entry Type", '%1|%2', ILE."Entry Type"::Sale, ILE."Entry Type"::"Negative Adjmt.");
                IF ILE.FINDFIRST THEN
                    REPEAT
                        AssignAmounts(ILE, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1);
                    UNTIL ILE.NEXT = 0;


                ILE.SETRANGE("Posting Date", StartDate, EndDate);
                ILE.SETRANGE("Entry Type", ILE."Entry Type"::Transfer);
                IF ILE.FINDSET THEN
                    REPEAT
                        IF TRUE IN [ILE."Invoiced Quantity" < 0, NOT GetOutboundItemEntry(ILE."Entry No.")] THEN
                            AssignAmounts(ILE, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1)
                        ELSE
                            AssignAmounts(ILE, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);
                    UNTIL ILE.NEXT = 0;
                //Standard Code Commented
                IsEmptyLine := IsEmptyLine AND ((IncreaseInvoicedValue = 0) AND (IncreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine AND ((DecreaseInvoicedValue = 0) AND (DecreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine AND ((IncreaseExpectedValue = 0) AND (IncreaseExpectedQty = 0));
                IsEmptyLine := IsEmptyLine AND ((DecreaseExpectedValue = 0) AND (DecreaseExpectedQty = 0));
                IF ShowExpected THEN BEGIN
                    IsEmptyLine := IsEmptyLine AND ((IncreaseExpectedValue = 0) AND (IncreaseExpectedQty = 0));
                    IsEmptyLine := IsEmptyLine AND ((DecreaseExpectedValue = 0) AND (DecreaseExpectedQty = 0));
                END;


                ValueEntry.SETRANGE("Posting Date", 0D, EndDate);
                ValueEntry.SETRANGE("Item Ledger Entry Type", ILE."Entry Type");
                ValueEntry.CALCSUMS("Cost Posted to G/L", "Expected Cost Posted to G/L");
                ExpCostPostedToGL += ValueEntry."Expected Cost Posted to G/L";
                InvCostPostedToGL += ValueEntry."Cost Posted to G/L";

                StartingExpectedValue += StartingInvoicedValue;
                IncreaseExpectedValue += IncreaseInvoicedValue;
                DecreaseExpectedValue += DecreaseInvoicedValue;
                CostPostedToGL := ExpCostPostedToGL + InvCostPostedToGL;

                IF IsEmptyLine THEN
                    CurrReport.SKIP;


                //KMT2016CU5 >>
                IF (StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue) = 0 THEN BEGIN
                    ItemSalesPrice := 0;
                    SalesPrice.RESET;
                    SalesPrice.SETRANGE("Item No.", Item."No.");
                    SalesPrice.SETFILTER("Ending Date", '');
                    IF SalesPrice.FINDFIRST THEN
                        ItemSalesPrice := SalesPrice."Unit Price";
                END;
                //MESSAGE(FORMAT(StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty));
                IF (StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty = 0) THEN BEGIN
                    RoundingAmount += (StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue);
                    //to add the rounding amount to last item as per anish dai
                    IF ProcessingCount = TotalCount THEN
                        StartingExpectedQty += RoundingAmount;
                    CurrReport.SKIP;
                END;

                IF ((StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty) = 0) AND
                    ((StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue) = 0) AND
                    ((StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue) = 0) THEN BEGIN
                    CurrReport.SKIP;
                END;
                //KMT2016CU5 <<
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(
                  StartingExpectedQty, IncreaseExpectedQty, DecreaseExpectedQty,
                  StartingInvoicedQty, IncreaseInvoicedQty, DecreaseInvoicedQty);
                CurrReport.CREATETOTALS(
                  StartingExpectedValue, IncreaseExpectedValue, DecreaseExpectedValue,
                  StartingInvoicedValue, IncreaseInvoicedValue, DecreaseInvoicedValue,
                  CostPostedToGL, ExpCostPostedToGL, InvCostPostedToGL);
                TotalCount := Item.COUNT;
                ProcessingCount := 0;
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
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; StartDate)
                    {
                        Caption = 'Starting Date';
                        Visible = false;
                    }
                    field(EndingDate; EndDate)
                    {
                        Caption = 'Ending Date';
                    }
                    field(IncludeExpectedCost; ShowExpected)
                    {
                        Caption = 'Include Expected Cost';
                        Visible = true;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF (StartDate = 0D) AND (EndDate = 0D) THEN
                EndDate := WORKDATE;
        end;
    }

    labels
    {
        Inventory_Posting_Group_NameCaption = 'Inventory Posting Group Name';
        Expected_CostCaption = 'Expected Cost';
    }

    trigger OnInitReport()
    begin
        //StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        IF (StartDate = 0D) AND (EndDate = 0D) THEN
            EndDate := WORKDATE;

        IF StartDate IN [0D, 00000101D] THEN
            StartDateText := ''
        ELSE
            StartDateText := FORMAT(StartDate - 1);
        ItemFilter := Item.GETFILTERS;
        //KMT2016CU5 >>
        StartDateNep := '';
        NepaliCal.RESET;
        NepaliCal.SETRANGE("English Date", EndDate);
        IF NepaliCal.FINDFIRST THEN
            StartDateNep := NepaliCal."Nepali Date";
        //KMT2016CU5 <<
    end;

    var
        Text005: Label 'As of %1';
        ValueEntry: Record "Value Entry";
        StartDate: Date;
        EndDate: Date;
        ShowExpected: Boolean;
        ItemFilter: Text;
        StartDateText: Text[10];
        StartingInvoicedValue: Decimal;
        StartingExpectedValue: Decimal;
        StartingInvoicedQty: Decimal;
        StartingExpectedQty: Decimal;
        IncreaseInvoicedValue: Decimal;
        IncreaseExpectedValue: Decimal;
        IncreaseInvoicedQty: Decimal;
        IncreaseExpectedQty: Decimal;
        DecreaseInvoicedValue: Decimal;
        DecreaseExpectedValue: Decimal;
        DecreaseInvoicedQty: Decimal;
        DecreaseExpectedQty: Decimal;
        BoM_TextLbl: Label 'Base UoM';
        Inventory_ValuationCaptionLbl: Label 'Closing Stock Report';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl: Label 'This report includes entries that have been posted with expected costs.';
        IncreaseInvoicedQtyCaptionLbl: Label 'Increases (LCY)';
        DecreaseInvoicedQtyCaptionLbl: Label 'Decreases (LCY)';
        QuantityCaptionLbl: Label 'Quantity';
        ValueCaptionLbl: Label 'Value';
        QuantityCaption_Control31Lbl: Label 'Quantity';
        QuantityCaption_Control40Lbl: Label 'Quantity';
        InvCostPostedToGL_Control53CaptionLbl: Label 'Cost Posted to G/L';
        QuantityCaption_Control58Lbl: Label 'Quantity';
        TotalCaptionLbl: Label 'Total';
        Expected_Cost_Included_TotalCaptionLbl: Label 'Expected Cost Included Total';
        Expected_Cost_TotalCaptionLbl: Label 'Expected Cost Total';
        Expected_Cost_IncludedCaptionLbl: Label 'Expected Cost Included';
        InvCostPostedToGL: Decimal;
        CostPostedToGL: Decimal;
        ExpCostPostedToGL: Decimal;
        IsEmptyLine: Boolean;
        CompanyInfo: Record "Company Information";
        ItemSalesPrice: Decimal;
        SalesPrice: Record "Sales Price";
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        NepaliCal: Record "English-Nepali Date";
        StartEngDate: Date;
        EndEngDate: Date;
        RoundingAmount: Decimal;
        ProcessingCount: Integer;
        TotalCount: Integer;
        ILE: Record "Item Ledger Entry";

    local procedure AssignAmounts(ILE: Record "Item Ledger Entry"; var InvoicedValue: Decimal; var InvoicedQty: Decimal; var ExpectedValue: Decimal; var ExpectedQty: Decimal; Sign: Decimal)
    begin
        ILE.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
        InvoicedValue += ILE."Cost Amount (Actual)" * Sign;
        InvoicedQty += ILE."Invoiced Quantity" * Sign;
        ExpectedValue += ILE."Cost Amount (Expected)" * Sign;
        ExpectedQty += ILE."Invoiced Quantity" * Sign;
    end;

    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ItemApplnEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
        IF NOT ItemApplnEntry.FINDFIRST THEN
            EXIT(TRUE);

        ItemLedgEntry.SETRANGE("Item No.", Item."No.");
        ItemLedgEntry.SETFILTER("Variant Code", Item.GETFILTER("Variant Filter"));
        ItemLedgEntry.SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
        ItemLedgEntry.SETFILTER("Global Dimension 1 Code", Item.GETFILTER("Global Dimension 1 Filter"));
        ItemLedgEntry.SETFILTER("Global Dimension 2 Code", Item.GETFILTER("Global Dimension 2 Filter"));
        ItemLedgEntry."Entry No." := ItemApplnEntry."Outbound Item Entry No.";
        EXIT(NOT ItemLedgEntry.FIND);
    end;

    [Scope('Internal')]
    procedure SetStartDate(DateValue: Date)
    begin
        StartDate := DateValue;
    end;

    [Scope('Internal')]
    procedure SetEndDate(DateValue: Date)
    begin
        EndDate := DateValue;
    end;

    [Scope('Internal')]
    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewShowExpected: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        ShowExpected := NewShowExpected;
    end;

    local procedure GetUrlForReportDrilldown(ItemNumber: Code[20]): Text
    begin
        // Generates a URL to the report which sets tab "Item" and field "Field1" on the request page, such as
        // dynamicsnav://hostname:port/instance/company/runreport?report=5801<&Tenant=tenantId>&filter=Item.Field1:1100.
        // TODO
        // Eventually leverage parameters 5 and 6 of GETURL by adding ",Item,TRUE)" and
        // use filter Item.SETFILTER("No.",'=%1',ItemNumber);.
        EXIT(GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Report, REPORT::"Invt. Valuation - Cost Spec.") +
          STRSUBSTNO('&filter=Item.Field1:%1', ItemNumber));
    end;
}

