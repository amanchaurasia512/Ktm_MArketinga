report 50076 "Total Sales By Customer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TotalSalesByCustomer.rdlc';
    Caption = 'Total Sales By Customer';

    dataset
    {
        dataitem(DataItem6836; Table18)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Global Dimension 1 Filter", "Global Dimension 2 Filter", "Date Filter";
            column(STRSUBSTNO_Text000_PeriodText_; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Value_Entry__TABLECAPTION__________ItemLedgEntryFilter; "Item Ledger Entry".TABLECAPTION + ': ' + ItemLedgEntryFilter)
            {
            }
            column(ItemLedgEntryFilter; ItemLedgEntryFilter)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(VATRegistrationNo_Customer; Customer."VAT Registration No.")
            {
            }
            column(ValueEntryBuffer__Sales_Amount__Actual__; ValueEntryBuffer."Sales Amount (Actual)")
            {
            }
            column(ValueEntryBuffer__Discount_Amount_; -ValueEntryBuffer."Discount Amount")
            {
            }
            column(Profit; Profit)
            {
                AutoFormatType = 1;
            }
            column(ProfitPct; ProfitPct)
            {
                DecimalPlaces = 1 : 1;
            }
            column(Customer_Item_SalesCaption; Customer_Item_SalesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(ValueEntryBuffer__Item_No__Caption; ValueEntryBuffer__Item_No__CaptionLbl)
            {
            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {
            }
            column(ValueEntryBuffer__Invoiced_Quantity_Caption; ValueEntryBuffer__Invoiced_Quantity_CaptionLbl)
            {
            }
            column(Item__Base_Unit_of_Measure_Caption; Item__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            column(ValueEntryBuffer__Sales_Amount__Actual___Control44Caption; ValueEntryBuffer__Sales_Amount__Actual___Control44CaptionLbl)
            {
            }
            column(ValueEntryBuffer__Discount_Amount__Control45Caption; ValueEntryBuffer__Discount_Amount__Control45CaptionLbl)
            {
            }
            column(Profit_Control46Caption; Profit_Control46CaptionLbl)
            {
            }
            column(ProfitPct_Control47Caption; ProfitPct_Control47CaptionLbl)
            {
            }
            column(Customer__Phone_No__Caption; FIELDCAPTION("Phone No."))
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(CustomerCollectionAmount; CustomerCollectionAmount)
            {
            }
            column(ShowCustomerCollection; ShowCustomerCollection)
            {
            }
            column(TotalCustomerCollectionAmount; TotalCustomerCollectionAmount)
            {
            }
            dataitem(DataItem7209; Table32)
            {
                DataItemLink = Source No.=FIELD(No.),
                               Posting Date=FIELD(Date Filter),
                               Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                               Global Dimension 2 Code=FIELD(Global Dimension 2 Filter);
                DataItemTableView = SORTING(Source Type,Source No.,Item No.,Variant Code,Posting Date)
                                    WHERE(Source Type=CONST(Customer));
                RequestFilterFields = "Item No.","Posting Date","Sub-Category";

                trigger OnAfterGetRecord()
                begin
                    ValueEntryBuffer.SETRANGE("Item No.","Item No.");
                    
                    IF NOT ValueEntryBuffer.FIND('-') THEN BEGIN
                      ValueEntryBuffer.INIT;
                      ValueEntryBuffer."Entry No." := NextEntryNo;
                      ValueEntryBuffer."Item No." := "Item No.";
                      ValueEntryBuffer."Document No." := "Document No.";
                      ValueEntryBuffer."Global Dimension 1 Code" := "Item Ledger Entry"."Global Dimension 1 Code";
                      ValueEntryBuffer.INSERT;
                    
                      NextEntryNo := NextEntryNo + 1;
                    END;
                    CALCFIELDS("Sales Amount (Actual)","Cost Amount (Actual)","Cost Amount (Non-Invtbl.)");
                    ValueEntryBuffer."Invoiced Quantity" := ValueEntryBuffer."Invoiced Quantity" + "Invoiced Quantity";
                    //KMT2016CU5 >>
                    Item.RESET;
                    Item.SETRANGE("No.",ValueEntryBuffer."Item No.");
                    IF Item.FINDFIRST THEN BEGIN
                      IF Item."VAT Prod. Posting Group" = 'VAT13' THEN
                        ValueEntryBuffer."Cost Amount (Actual)" := "Sales Amount (Actual)" * 1.13 + ValueEntryBuffer."Sales Amount (Actual)"*1.13
                       ELSE
                        ValueEntryBuffer."Cost Amount (Actual)" := ValueEntryBuffer."Sales Amount (Actual)"+"Sales Amount (Actual)";
                    END;
                    //KMT2016CU5 <<
                    ValueEntryBuffer."Sales Amount (Actual)" := ValueEntryBuffer."Sales Amount (Actual)" + "Sales Amount (Actual)";
                    //ValueEntryBuffer."Cost Amount (Actual)" := ValueEntryBuffer."Cost Amount (Actual)" + "Cost Amount (Actual)";
                    
                    ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
                    ValueEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
                    IF ValueEntry.FINDSET THEN
                      REPEAT
                        ValueEntryBuffer."Discount Amount" := ValueEntryBuffer."Discount Amount" + ValueEntry."Discount Amount";
                      UNTIL ValueEntry.NEXT = 0;
                    
                    ValueEntryBuffer."Cost Amount (Non-Invtbl.)" := ValueEntryBuffer."Cost Amount (Non-Invtbl.)" + "Cost Amount (Non-Invtbl.)";
                    ValueEntryBuffer.MODIFY;
                    
                    /*IF ValueEntryBuffer."Document No." = 'SPCM74/75-0170' THEN
                      MESSAGE('amount %1',ValueEntryBuffer."Sales Amount (Actual)");*/

                end;

                trigger OnPreDataItem()
                begin
                    ValueEntryBuffer.RESET;
                    ValueEntryBuffer.DELETEALL;

                    NextEntryNo := 1;
                    //KMT2016CU5 >>
                    IF AreaCodeFilter <> '' THEN
                      "Item Ledger Entry".SETFILTER("Global Dimension 2 Code",AreaCodeFilter);
                    IF ProductCodeFilter <> '' THEN
                      "Item Ledger Entry".SETFILTER("Global Dimension 1 Code",ProductCodeFilter);
                    //KMT2016CU5 <<
                end;
            }
            dataitem(DataItem5444;Table2000000026)
            {
                DataItemTableView = SORTING(Number);
                column(ValueEntryBuffer__Item_No__;ValueEntryBuffer."Item No.")
                {
                }
                column(Item_Description;Item.Description)
                {
                }
                column(ValueEntryBuffer__Invoiced_Quantity_;-ValueEntryBuffer."Invoiced Quantity")
                {
                    DecimalPlaces = 0:5;
                }
                column(ValueEntryBuffer__Sales_Amount__Actual___Control44;ValueEntryBuffer."Sales Amount (Actual)")
                {
                    AutoFormatType = 1;
                }
                column(ValueEntryBuffer_Sales_Amount_Incl_VAT;ValueEntryBuffer."Cost Amount (Actual)")
                {
                }
                column(ItemLedgEntry_AreaCode;ValueEntryBuffer."Global Dimension 1 Code")
                {
                }
                column(ValueEntryBuffer__Discount_Amount__Control45;-ValueEntryBuffer."Discount Amount")
                {
                    AutoFormatType = 1;
                }
                column(Profit_Control46;Profit)
                {
                    AutoFormatType = 1;
                }
                column(ProfitPct_Control47;ProfitPct)
                {
                    DecimalPlaces = 1:1;
                }
                column(Item__Base_Unit_of_Measure_;Item."Base Unit of Measure")
                {
                }
                column(AmtInclVAT;AmtInclVAT)
                {
                }
                column(TotalAmt;TotalAmt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                      ValueEntryBuffer.FIND('-')
                    ELSE
                      ValueEntryBuffer.NEXT;

                    Profit :=
                      ValueEntryBuffer."Sales Amount (Actual)" +
                      ValueEntryBuffer."Cost Amount (Actual)" +
                      ValueEntryBuffer."Cost Amount (Non-Invtbl.)";

                    IF Item.GET(ValueEntryBuffer."Item No.") THEN ;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS(
                      ValueEntryBuffer."Sales Amount (Actual)",
                      ValueEntryBuffer."Discount Amount",
                      Profit);

                    ValueEntryBuffer.RESET;
                    SETRANGE(Number,1,ValueEntryBuffer.COUNT);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //KMT2016CU5 >>
                CustomerCollectionAmount := 0;
                IF ShowCustomerCollection THEN BEGIN
                  SourceCodeSetup.GET;
                  CustLedgEntry.RESET;
                  CustLedgEntry.SETRANGE("Customer No.","No.");
                  CustLedgEntry.SETRANGE("Source Code",SourceCodeSetup."Cash Receipt Journal");
                  CustLedgEntry.SETFILTER("Global Dimension 1 Code",Customer.GETFILTER("Global Dimension 1 Filter"));
                  CustLedgEntry.SETFILTER("Posting Date",Customer.GETFILTER("Date Filter"));
                  IF CustLedgEntry.FINDFIRST THEN REPEAT
                    CustLedgEntry.CALCFIELDS(Amount);
                    CustomerCollectionAmount += CustLedgEntry.Amount;
                    IF CustLedgEntry.Reversed THEN
                      CustomerCollectionAmount -= CustLedgEntry.Amount;
                  UNTIL CustLedgEntry.NEXT = 0;
                  TotalCustomerCollectionAmount += CustomerCollectionAmount;
                END;
                //KMT2016CU5 <<
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;

                CurrReport.CREATETOTALS(
                  ValueEntryBuffer."Sales Amount (Actual)",
                  ValueEntryBuffer."Discount Amount",
                  Profit);
                TotalCustomerCollectionAmount := 0;
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
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Customer';
                    }
                    field(ShowCustomerCollection;ShowCustomerCollection)
                    {
                        Caption = 'Show Customer Collection Amount';
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
        CustFilter := Customer.GETFILTERS;
        ItemLedgEntryFilter := "Item Ledger Entry".GETFILTERS;
        AreaCodeFilter := Customer.GETFILTER("Global Dimension 2 Filter");
        ProductCodeFilter := Customer.GETFILTER("Global Dimension 1 Filter");
        PeriodText := "Item Ledger Entry".GETFILTER("Posting Date");
        CompanyInfo.GET;  //KMT2016CU5
    end;

    var
        Text000: Label 'Period: %1';
        Item: Record "27";
        ValueEntry: Record "5802";
        ValueEntryBuffer: Record "5802" temporary;
        CustFilter: Text;
        ItemLedgEntryFilter: Text;
        PeriodText: Text[30];
        NextEntryNo: Integer;
        PrintOnlyOnePerPage: Boolean;
        Profit: Decimal;
        ProfitPct: Decimal;
        Customer_Item_SalesCaptionLbl: Label 'Customer Total Sales';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        ValueEntryBuffer__Item_No__CaptionLbl: Label 'Item No.';
        Item_DescriptionCaptionLbl: Label 'Description';
        ValueEntryBuffer__Invoiced_Quantity_CaptionLbl: Label 'Invoiced Quantity';
        Item__Base_Unit_of_Measure_CaptionLbl: Label 'Unit of Measure';
        ValueEntryBuffer__Sales_Amount__Actual___Control44CaptionLbl: Label 'Amount';
        ValueEntryBuffer__Discount_Amount__Control45CaptionLbl: Label 'Discount Amount';
        Profit_Control46CaptionLbl: Label 'Profit';
        ProfitPct_Control47CaptionLbl: Label 'Profit %';
        TotalCaptionLbl: Label 'Total';
        CompanyInfo: Record "79";
        AmtInclVAT: Decimal;
        SalesInvHeader: Record "112";
        TotalAmt: Decimal;
        AreaCodeFilter: Text;
        ProductCodeFilter: Text;
        CustomerCollectionAmount: Decimal;
        CustLedgEntry: Record "21";
        ShowCustomerCollection: Boolean;
        SourceCodeSetup: Record "242";
        TotalCustomerCollectionAmount: Decimal;

    [Scope('Internal')]
    procedure InitializeRequest(NewPagePerCustomer: Boolean)
    begin
        PrintOnlyOnePerPage := NewPagePerCustomer;
    end;
}

