report 50437 "Item Ledger Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ItemLedgerReport.rdlc';
    Caption = 'Item Ledger Report';

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", Description, "Assembly BOM", "Inventory Posting Group", "Shelf No.", "Statistics Group", "Date Filter";
            column(PeriodItemDateFilter; STRSUBSTNO(Text000, ItemDateFilter))
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(TableCaptionItemFilter; STRSUBSTNO('%1: %2', TABLECAPTION, ItemFilter))
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(No_Item; "No.")
            {
            }
            column(GlobalDimension1Code_Item; Item."Global Dimension 1 Code")
            {
            }
            column(InventoryTransDetailCaption; InventoryTransDetailCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemLedgEntryPostDateCaption; ItemLedgEntryPostDateCaptionLbl)
            {
            }
            column(ItemLedgEntryEntryTypCaption; ItemLedgEntryEntryTypCaptionLbl)
            {
            }
            column(IncreasesQtyCaption; IncreasesQtyCaptionLbl)
            {
            }
            column(DecreasesQtyCaption; DecreasesQtyCaptionLbl)
            {
            }
            column(ItemOnHandCaption; ItemOnHandCaptionLbl)
            {
            }
            column(StartingNepaliDate; StartDateNep)
            {
            }
            column(EndingNepaliDate; EndDateNep)
            {
            }
            dataitem(PageCounter; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(Description_Item; Item.Description)
                {
                }
                column(StartOnHand; StartOnHand)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(RecordNo; RecordNo)
                {
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = FIELD("No."),
                                  "Variant Code" = FIELD("Variant Filter"),
                                  "Posting Date" = FIELD("Date Filter"),
                                   "Location Code" = FIELD("Location Filter"),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Item;
                    DataItemTableView = SORTING("Item No.", "Posting Date")
                                        WHERE("Entry Type" = FILTER(<> Transfer));
                    RequestFilterFields = "Source No.", "Source Type";
                    column(StartOnHandQuantity; StartOnHand + Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(PostingDate_ItemLedgEntry; FORMAT("Posting Date"))
                    {
                    }
                    column(NepaliDate; NepaliDate)
                    {
                    }
                    column(EntryType_ItemLedgEntry; "Entry Type")
                    {
                    }
                    column(DocumentNo_ItemLedgEntry; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_ItemLedgEntry; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(RBIProductCode_ItemLedgerEntry; "Item Ledger Entry"."RBI Product Code")
                    {
                    }
                    column(GlobalDimension1Code_ItemLedgerEntry; "Item Ledger Entry"."Global Dimension 1 Code")
                    {
                    }
                    column(IncreasesQty; IncreasesQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(DecreasesQty; DecreasesQty)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(IncreasesVal; IncreasesVal)
                    {
                    }
                    column(DecreasesVal; DecreasesVal)
                    {
                    }
                    column(ItemOnHand; ItemOnHand)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(ItemOnHandVal; ItemOnHandVal)
                    {
                    }
                    column(StartOnHandVal; StartOnHandVal)
                    {
                    }
                    column(EntryNo_ItemLedgerEntry; "Entry No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_ItemLedgerEntry; Quantity)
                    {
                    }
                    column(ItemDescriptionControl32; Item.Description)
                    {
                    }
                    column(ContinuedCaption; ContinuedCaptionLbl)
                    {
                    }
                    column(CustomerOrVendorName; DescName)
                    {
                    }
                    column(StartingInv; StartingInv)
                    {
                    }
                    column(InvoicedPrice; InvoicedPrice)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DescName := '';
                        ItemOnHand := ItemOnHand + Quantity;
                        //KMT2016CU5 >>
                        IncreasesVal := 0;
                        DecreasesVal := 0;
                        ItemOnHandVal := 0;
                        InvoicedPrice := 0;
                        SalesInvLine.RESET;
                        PurchInvLine.RESET;
                        PurchRcptLine.RESET;
                        SalesCrMemoLine.RESET;
                        IF "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::Sale THEN BEGIN
                            IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Invoice" THEN BEGIN
                                SalesInvLine.SETRANGE("Document No.", "Document No.");
                                SalesInvLine.SETRANGE("No.", "Item Ledger Entry"."Item No.");
                                IF SalesInvLine.FINDFIRST THEN
                                    InvoicedPrice := SalesInvLine."Unit Price";
                            END;
                            IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Credit Memo" THEN BEGIN
                                SalesCrMemoLine.SETRANGE("Document No.", "Document No.");
                                SalesCrMemoLine.SETRANGE("No.", "Item Ledger Entry"."Item No.");
                                IF SalesCrMemoLine.FINDFIRST THEN
                                    InvoicedPrice := SalesCrMemoLine."Unit Price";
                            END;
                            IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Sales Shipment" THEN BEGIN
                                ValueEntries.RESET;
                                ValueEntries.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                                IF ValueEntries.FINDFIRST THEN BEGIN
                                    "Item Ledger Entry"."Document No." := ValueEntries."Document No.";
                                    IF ValueEntries."Invoiced Quantity" <> 0 THEN
                                        InvoicedPrice := ABS(ValueEntries."Sales Amount (Actual)" / ValueEntries."Invoiced Quantity");
                                END;
                            END;
                        END;
                        IF "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::Purchase THEN BEGIN
                            IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Purchase Invoice" THEN BEGIN
                                PurchInvLine.SETRANGE("Document No.", "Document No.");
                                PurchInvLine.SETRANGE("No.", "Item Ledger Entry"."Item No.");
                                IF PurchInvLine.FINDFIRST THEN
                                    InvoicedPrice := PurchInvLine."Unit Cost (LCY)";
                            END;
                            IF "Item Ledger Entry"."Document Type" = "Item Ledger Entry"."Document Type"::"Purchase Receipt" THEN BEGIN
                                PurchRcptLine.SETRANGE("Document No.", "Document No.");
                                PurchRcptLine.SETRANGE("No.", "Item Ledger Entry"."Item No.");
                                IF PurchRcptLine.FINDFIRST THEN
                                    InvoicedPrice := PurchRcptLine."Unit Cost (LCY)";
                            END;
                        END;
                        IF ("Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::"Positive Adjmt.") OR
                              ("Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::"Negative Adjmt.") THEN BEGIN
                            "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)");
                            InvoicedPrice := "Item Ledger Entry"."Cost Amount (Actual)" / "Item Ledger Entry"."Invoiced Quantity";
                        END;
                        //ItemOnHandVal := ItemOnHandVal  * InvoicedPrice;
                        //KMT2016CU5 <<
                        IF Quantity > 0 THEN BEGIN
                            IncreasesQty := Quantity;
                            IncreasesVal := ABS("Item Ledger Entry".Quantity * InvoicedPrice);
                            ItemOnHandVal := ItemOnHand * InvoicedPrice;
                        END
                        ELSE BEGIN
                            DecreasesQty := ABS(Quantity);
                            DecreasesVal := ABS("Item Ledger Entry".Quantity * InvoicedPrice);
                            ItemOnHandVal := ItemOnHand * InvoicedPrice;
                        END;

                        //KMT2016CU5 <<
                        Customer.RESET;
                        Vendor.RESET;
                        IF "Item Ledger Entry"."Source Type" = "Item Ledger Entry"."Source Type"::Customer THEN BEGIN
                            Customer.SETRANGE("No.", "Item Ledger Entry"."Source No.");
                            IF Customer.FINDFIRST THEN
                                DescName := Customer.Name;
                        END;
                        IF "Item Ledger Entry"."Source Type" = "Item Ledger Entry"."Source Type"::Vendor THEN BEGIN
                            Vendor.SETRANGE("No.", "Item Ledger Entry"."Source No.");
                            IF Vendor.FINDFIRST THEN
                                DescName := Vendor.Name;
                        END;
                        NepaliCal.RESET;
                        NepaliCal.SETRANGE("English Date", "Item Ledger Entry"."Posting Date");
                        IF NepaliCal.FINDFIRST THEN
                            NepaliDate := NepaliCal."Nepali Date";
                        //KMT2016CU5 <<
                    end;

                    trigger OnPreDataItem()
                    begin
                        CurrReport.CREATETOTALS(Quantity, IncreasesQty, DecreasesQty);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                StartOnHand := 0;
                StartOnHandVal := 0;
                IF ItemDateFilter <> '' THEN
                    IF GETRANGEMIN("Date Filter") > 00000101D THEN BEGIN
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("Net Change");
                        StartOnHand := "Net Change";
                        StartOnHandVal := "Unit Cost";
                        SETFILTER("Date Filter", ItemDateFilter);
                    END;
                ItemOnHand := StartOnHand;
                ItemOnHandVal := StartOnHandVal * StartOnHand; //KMT2016CU5
                IF PrintOnlyOnePerPage THEN
                    RecordNo := RecordNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                RecordNo := 1;
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
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        Caption = 'New Page per Item';
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
        ItemFilter := Item.GETFILTERS;
        ItemDateFilter := Item.GETFILTER("Date Filter");
        //KMT2016CU5 >>
        CompanyInfo.GET;
        IF ItemDateFilter <> '' THEN BEGIN
            StartDateNep := '';
            EndDateNep := '';
            StartEngDate := 0D;
            EndEngDate := 0D;
            StartEngDate := Item.GETRANGEMIN("Date Filter");
            EndEngDate := Item.GETRANGEMAX("Date Filter");
            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", StartEngDate);
            IF NepaliCal.FINDFIRST THEN
                StartDateNep := NepaliCal."Nepali Date";

            NepaliCal.RESET;
            NepaliCal.SETRANGE("English Date", EndEngDate);
            IF NepaliCal.FINDFIRST THEN
                EndDateNep := NepaliCal."Nepali Date";
        END;
        //KMT2016CU5 <<
    end;

    var
        Text000: Label 'Period: %1';
        ItemFilter: Text;
        ItemDateFilter: Text[30];
        ItemOnHand: Decimal;
        StartOnHand: Decimal;
        IncreasesQty: Decimal;
        DecreasesQty: Decimal;
        IncreasesVal: Decimal;
        DecreasesVal: Decimal;
        InventoryVal: Decimal;
        PrintOnlyOnePerPage: Boolean;
        RecordNo: Integer;
        InventoryTransDetailCaptionLbl: Label 'Item Ledger Report';
        CurrReportPageNoCaptionLbl: Label 'Page';
        ItemLedgEntryPostDateCaptionLbl: Label 'Posting Date';
        ItemLedgEntryEntryTypCaptionLbl: Label 'Entry Type';
        IncreasesQtyCaptionLbl: Label 'Increases';
        DecreasesQtyCaptionLbl: Label 'Decreases';
        ItemOnHandCaptionLbl: Label 'Inventory';
        ContinuedCaptionLbl: Label 'Continued';
        DescName: Text;
        Customer: Record Customer;
        Vendor: Record Vendor;
        OpeningInventory: Decimal;
        StartingInv: Decimal;
        CompanyInfo: Record "Company Information";
        SalesPrice: Record "Sales Price";
        ItemOnHandVal: Decimal;
        StartOnHandVal: Decimal;
        NepaliDate: Code[10];
        NepaliCal: Record "English-Nepali Date";
        InvoicedPrice: Decimal;
        SalesInvLine: Record "Sales Invoice Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ValueEntries: Record "Value Entry";
        StartDateNep: Code[10];
        EndDateNep: Code[10];
        StartEngDate: Date;
        EndEngDate: Date;
       

    [Scope('OnPrem')]
    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
    end;
}

