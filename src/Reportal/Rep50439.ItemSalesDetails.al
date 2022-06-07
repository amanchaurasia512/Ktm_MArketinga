report 50439 "Item Sales Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ItemSalesDetails.rdlc';
    Caption = 'Item Sales Details';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry Type" = CONST(Sale));
            RequestFilterFields = "Item No.", "Posting Date", "Source Type", "Source No.", "Global Dimension 1 Code", "Salespers./Purch. Code", "Shortcut Dimension 4 Code";
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(Value_Entry__TABLECAPTION__________ItemLedgEntryFilter; "Item Ledger Entry".TABLECAPTION + ': ' + ItemLedgEntryFilter)
            {
            }
            column(ItemLedgEntryFilter; ItemLedgEntryFilter)
            {
            }
            column(ItemNo; "Item No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Item_Description; Item.Description)
            {
            }
            column(ProductCode; Item."RBI Product Code")
            {
            }
            column(UOM; Item."Base Unit of Measure")
            {
            }
            column(ValueEntryBuffer__Invoiced_Quantity_; -"Invoiced Quantity")
            {
                DecimalPlaces = 0 : 5;
            }
            column(Amount; "Sales Amount (Actual)")
            {
                AutoFormatType = 1;
            }
            column(AmountInclVAT; AmountInclVAT)
            {
            }
            column(Item__Base_Unit_of_Measure_; Item."Base Unit of Measure")
            {
            }
            column(DBName; Customer.Name)
            {
            }
            column(Town; Customer."Address 2")
            {
            }
            column(SalesPerson; SalesPerson)
            {
            }
            column(BillDate; FORMAT("Posting Date"))
            {
            }
            column(EnglishMonth; EnglishMonth)
            {
            }
            column(ReturnReasonCode; "Return Reason Code")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(TotalBillingAmt; TotalBillingAmt)
            {
            }
            column(DiscountPercent; DiscPercent)
            {
            }
            column(DiscountValue; DiscValue)
            {
            }
            column(BillingAmount; BillingAmount)
            {
            }
            column(Description2_ItemLedgerEntry; "Item Ledger Entry"."Description 2")
            {
            }
            column(ShortcutDimension4Code_ItemLedgerEntry; "Item Ledger Entry"."Shortcut Dimension 4 Code")
            {
            }
            column(RBISubCategory; Item."Sub-Category")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(Item);
                IF Item.GET("Item No.") THEN;

                IF Customer.GET("Source No.") THEN;
                CALCFIELDS("Sales Amount (Actual)");

                IF Item."VAT Prod. Posting Group" = 'VAT13' THEN
                    AmountInclVAT := "Sales Amount (Actual)" * 1.13
                ELSE
                    AmountInclVAT := "Sales Amount (Actual)";

                IF SalesPersonMaster.GET("Item Ledger Entry"."Salespers./Purch. Code") THEN
                    SalesPerson := SalesPersonMaster.Name
                ELSE
                    SalesPerson := '';

                EnglishMonth := '';
                NepaliCal.RESET;
                NepaliCal.SETRANGE("English Date", "Item Ledger Entry"."Posting Date");
                IF NepaliCal.FINDFIRST THEN
                    EnglishMonth := FORMAT(NepaliCal."English Month");

                TotalBillingAmt := 0;
                DiscPercent := 0;
                DiscValue := 0;
                BillingAmount := 0;

                IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Invoice" THEN BEGIN
                    SalesInvLine.RESET;
                    SalesInvLine.SETRANGE("Document No.", "Item Ledger Entry"."Document No.");
                    SalesInvLine.SETRANGE("Line No.", "Item Ledger Entry"."Document Line No.");
                    IF SalesInvLine.FINDFIRST THEN BEGIN
                        TotalBillingAmt := SalesInvLine.Quantity * SalesInvLine."Unit Price";
                        DiscPercent := SalesInvLine."Line Discount %";
                        DiscValue := SalesInvLine."Line Discount Amount";
                        BillingAmount := TotalBillingAmt + DiscValue;
                    END;
                END;

                IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Credit Memo" THEN BEGIN
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", "Item Ledger Entry"."Document No.");
                    SalesCrMemoLine.SETRANGE("Line No.", "Item Ledger Entry"."Document Line No.");
                    IF SalesCrMemoLine.FINDFIRST THEN BEGIN
                        TotalBillingAmt := SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price" * -1;
                        DiscPercent := SalesCrMemoLine."Line Discount %" * -1;
                        DiscValue := SalesCrMemoLine."Line Discount Amount" * -1;
                        BillingAmount := TotalBillingAmt + DiscValue;
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                NextEntryNo := 1;
                GLSetup.GET;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnPreReport()
    begin
        ItemLedgEntryFilter := "Item Ledger Entry".GETFILTERS;
        CompanyInfo.GET;  //KMT2016CU5
    end;

    var
        Text000: Label 'Period: %1';
        Item: Record Item;
        ValueEntry: Record "Value Entry";
        ValueEntryBuffer: Record "Value Entry" temporary;
        CustFilter: Text;
        ItemLedgEntryFilter: Text;
        NextEntryNo: Integer;
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
        CompanyInfo: Record "Company Information";
        AmountInclVAT: Decimal;
        AreaCodeFilter: Text;
        ProductCodeFilter: Text;
        CustomerCollectionAmount: Decimal;
        CustLedgEntry: Record "Cust. Ledger Entry";
        ShowCustomerCollection: Boolean;
        SourceCodeSetup: Record "Source Code";
        TotalCustomerCollectionAmount: Decimal;
        Customer: Record Customer;
        SalesPerson: Text;
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        NepaliCal: Record "English-Nepali Date";
        EnglishMonth: Text;
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesPersonMaster: Record "Salesperson/Purchaser";
        TotalBillingAmt: Decimal;
        DiscPercent: Decimal;
        DiscValue: Decimal;
        BillingAmount: Decimal;
        SalesInvLine: Record "Sales Invoice Line";
}

