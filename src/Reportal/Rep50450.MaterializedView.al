report 50450 "Materialized View"
{
    DefaultLayout = RDLC;
    RDLCLayout = './MaterializedView.rdlc';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(CompanyAddr_1; CompanyInfo.Name)
            {
            }
            column(CompanyOneLineAddress; CompanyOneLineAddress)
            {
            }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress)
            {
            }
            column(CompanyInfo1Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoPicture2; CompanyInfo.Picture2)
            {
            }
            column(CompanyInfoPicture3; CompanyInfo.Picture3)
            {
            }
            column(CompanyInfoVATRegNo; CompanyInfo.FIELDCAPTION("VAT Registration No.") + ' : ' + CompanyInfo."VAT Registration No.")
            {
            }
            column(ReportType; ReportType)
            {
            }
            column(ReportCaption; STRSUBSTNO(ReportCaption, UPPERCASE(FORMAT(ReportType))))
            {
            }

            trigger OnPreDataItem()
            begin
                IF (FromDate = 0D) OR (ToDate = 0D) THEN
                    ERROR(Text000);
            end;
        }
        dataitem(SalesInvoice; "Invoice Materialize View")
        {
            DataItemTableView = SORTING("Table ID", "Document Type", "Bill No", "Fiscal Year")
                                WHERE("Table ID" = CONST(112),
                                      "Document Type" = CONST("Sales Invoice"));
            column(SalesInvHeader_FiscalYear; SalesInvoice."Fiscal Year")
            {
            }
            column(SalesInvHeader_InvoiceNo; SalesInvoice."Bill No")
            {
            }
            column(SalesInvHeader_Date; SalesInvoice."Bill Date")
            {
            }
            column(SalesInvHeader_Time; SalesInvoice."Posting Time")
            {
            }
            column(SalesInvHeader_CustomerName; SalesInvoice."Customer Name")
            {
            }
            column(SalesInvHeader_PAN; SalesInvoice."VAT Registration No.")
            {
            }
            column(SalesInvHeader_Amount; SalesInvoice.Amount)
            {
            }
            column(SalesInvHeader_Discount; SalesInvoice.Discount)
            {
            }
            column(SalesInvHeader_TaxableAmount; SalesInvoice."Taxable Amount")
            {
            }
            column(SalesInvHeader_VATAmount; SalesInvoice."TAX Amount")
            {
            }
            column(SalesInvHeader_TotalAmount; SalesInvoice."Total Amount")
            {
            }
            column(SalesInvHeader_CreatedBy; DELSTR(SalesInvoice."Entered By", 1, STRPOS(SalesInvoice."Entered By", '\')))
            {
            }
            column(SalesInvHeader_Printed; FORMAT(SalesInvoice."Is Bill Printed"))
            {
            }
            column(SalesInvHeader_Active; FORMAT(SalesInvoice."Is Bill Active"))
            {
            }
            column(SalesInvHeader_PrintedBy; DELSTR(SalesInvoice."Printed By", 1, STRPOS(SalesInvoice."Printed By", '\')))
            {
            }
            column(SyncwithIRD_SalesInvoice; SalesInvoice."Sync with IRD")
            {
            }
            column(IsBillActive_SalesInvoice; SalesInvoice."Is Bill Active")
            {
            }
            column(IsRealtime_SalesInvoice; SalesInvoice."Is RealTime")
            {
            }
            column(IsBillPrinted_SalesInvoice; SalesInvoice."Is Bill Printed")
            {
            }
            column(PrintedTime_SalesInvoice; FORMAT(SalesInvoice."Printed Time"))
            {
            }

            trigger OnPreDataItem()
            begin
                IF ReportType = ReportType::"Sales Credit Memo" THEN
                    CurrReport.BREAK;
                SETRANGE("Bill Date", FromDate, ToDate);
            end;
        }
        dataitem(SalesCrMemo; "Invoice Materialize View")
        {
            DataItemTableView = SORTING("Table ID", "Document Type", "Bill No", "Fiscal Year")
                                WHERE("Table ID" = CONST(114),
                                      "Document Type" = CONST("Sales Credit Memo"));
            column(SalesCrMemoHeader_FiscalYear; SalesCrMemo."Fiscal Year")
            {
            }
            column(SalesCrMemoHeader_InvoiceNo; SalesCrMemo."Bill No")
            {
            }
            column(SalesCrMemoHeader_Date; SalesCrMemo."Bill Date")
            {
            }
            column(SalesCrMemoHeader_Time; SalesCrMemo."Posting Time")
            {
            }
            column(SalesCrMemoHeader_CustomerName; SalesCrMemo."Customer Name")
            {
            }
            column(SalesCrMemoHeader_PAN; SalesCrMemo."VAT Registration No.")
            {
            }
            column(SalesCrMemoHeader_Amount; SalesCrMemo.Amount)
            {
            }
            column(SalesCrMemoHeader_Discount; SalesCrMemo.Discount)
            {
            }
            column(SalesCrMemoHeader_TaxableAmount; SalesCrMemo."Taxable Amount")
            {
            }
            column(SalesCrMemoHeader_VATAmount; SalesCrMemo."TAX Amount")
            {
            }
            column(SalesCrMemoHeader_TotalAmount; SalesCrMemo."Total Amount")
            {
            }
            column(SalesCrMemoHeader_CreatedBy; DELSTR(SalesCrMemo."Entered By", 1, STRPOS(SalesCrMemo."Entered By", '\')))
            {
            }
            column(SalesCrMemoHeader_Printed; FORMAT(SalesCrMemo."Is Bill Printed"))
            {
            }
            column(SalesCrMemoHeader_Active; FORMAT(SalesCrMemo."Is Bill Active"))
            {
            }
            column(SalesCrMemoHeader_PrintedBy; DELSTR(SalesCrMemo."Printed By", 1, STRPOS(SalesCrMemo."Printed By", '\')))
            {
            }
            column(SyncwithIRD_SalesCrMemo; SalesCrMemo."Sync with IRD")
            {
            }
            column(IsBillPrinted_SalesCrMemo; SalesCrMemo."Is Bill Printed")
            {
            }
            column(IsBillActive_SalesCrMemo; SalesCrMemo."Is Bill Active")
            {
            }
            column(IsRealtime_SalesCrMemo; SalesCrMemo."Is RealTime")
            {
            }
            column(PrintedTime_SalesCrMemo; FORMAT(SalesCrMemo."Printed Time"))
            {
            }

            trigger OnPreDataItem()
            begin
                IF ReportType = ReportType::"Sales Invoices" THEN
                    CurrReport.BREAK;
                SETRANGE("Bill Date", FromDate, ToDate);
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
                    field(ReportType; ReportType)
                    {
                        Caption = 'Report Type';
                    }
                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
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

    var
        AccountingPeriod: Record "Accounting Period";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        CompanyAddr: array[8] of Text[50];
        ReportType: Option "Sales Invoices","Sales Credit Memo";
        FromDate: Date;
        ToDate: Date;
        SystemManagement: Codeunit "IRD Mgt.";
        Text000: Label 'Please fill From Date and To Date.';
        ReportCaption: Label '%1 MATERIALIZED VIEW NO. SERIES REGISTER';

    local procedure GetCompanyOneLineAddress()
    begin
        CompanyAddr[1] := CompanyInfo.Name;
        IF CompanyInfo."Phone No." <> '' THEN
            CompanyOneLineAddress := SystemManagement.OneLineAddress(CompanyAddr) + ', ' + CompanyInfo.FIELDCAPTION("Phone No.") + ' : ' + CompanyInfo."Phone No."
        ELSE
            CompanyOneLineAddress := SystemManagement.OneLineAddress(CompanyAddr);

        IF CompanyInfo."Fax No." <> '' THEN
            CompanyCommunicationAddress := CompanyInfo.FIELDCAPTION("Fax No.") + ' : ' + CompanyInfo."Fax No.";
        IF (CompanyCommunicationAddress <> '') AND (CompanyInfo."E-Mail" <> '') THEN
            CompanyCommunicationAddress += ', ' + CompanyInfo.FIELDCAPTION("E-Mail") + ' : ' + CompanyInfo."E-Mail";
    end;
}

