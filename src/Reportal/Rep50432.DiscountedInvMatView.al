report 50432 "Discounted Inv. Mat. View"
{
    DefaultLayout = RDLC;
    RDLCLayout = './DiscountedInvMatView.rdlc';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(AllFilters; AllFilters)
            {
            }
            column(CompanyAddr_1; CompanyAddr[1])
            {
            }
            column(CompanyOneLineAddress; CompanyOneLineAddress)
            {
            }
            column(CompanyCommunicationAddress; CompanyCommunicationAddress)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
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
        dataitem(InvoiceMaterializedView; "Invoice Materialize View")
        {
            DataItemTableView = SORTING("Table ID", "Document Type", "Bill No", "Fiscal Year");
            RequestFilterFields = "Bill Date", "Document Type", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", Discount;
            column(InvoiceMaterializedView_FiscalYear; InvoiceMaterializedView."Fiscal Year")
            {
            }
            column(InvoiceMaterializedView_InvoiceNo; InvoiceMaterializedView."Bill No")
            {
            }
            column(InvoiceMaterializedView_Date; InvoiceMaterializedView."Bill Date")
            {
            }
            column(InvoiceMaterializedView_Time; InvoiceMaterializedView."Posting Time")
            {
            }
            column(InvoiceMaterializedView_CustomerName; InvoiceMaterializedView."Customer Name")
            {
            }
            column(InvoiceMaterializedView_PAN; InvoiceMaterializedView."VAT Registration No.")
            {
            }
            column(InvoiceMaterializedView_Amount; InvoiceMaterializedView.Amount)
            {
            }
            column(InvoiceMaterializedView_Discount; InvoiceMaterializedView.Discount)
            {
            }
            column(InvoiceMaterializedView_TaxableAmount; InvoiceMaterializedView."Taxable Amount")
            {
            }
            column(InvoiceMaterializedView_VATAmount; InvoiceMaterializedView."TAX Amount")
            {
            }
            column(InvoiceMaterializedView_TotalAmount; InvoiceMaterializedView."Total Amount")
            {
            }
            column(InvoiceMaterializedView_CreatedBy; DELSTR(InvoiceMaterializedView."Created By", 1, STRPOS(InvoiceMaterializedView."Created By", '\')))
            {
            }
            column(InvoiceMaterializedView_Printed; FORMAT(InvoiceMaterializedView."Is Bill Printed"))
            {
            }
            column(InvoiceMaterializedView_Active; FORMAT(InvoiceMaterializedView."Is Bill Active"))
            {
            }
            column(InvoiceMaterializedView_PrintedBy; DELSTR(InvoiceMaterializedView."Printed By", 1, STRPOS(InvoiceMaterializedView."Printed By", '\')))
            {
            }
            column(LineDisAmt; LineDisAmt)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SalesInvoiceLine.RESET;
                CLEAR(LineDisAmt);
                SalesInvoiceLine.SETRANGE("Document No.", InvoiceMaterializedView."Bill No");
                IF SalesInvoiceLine.FINDSET THEN
                    REPEAT
                        LineDisAmt += SalesInvoiceLine."Line Discount Amount";
                    UNTIL SalesInvoiceLine.NEXT = 0;
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        GetCompanyOneLineAddress;
    end;

    trigger OnPreReport()
    begin
        AllFilters := InvoiceMaterializedView.GETFILTERS;
        DateFilter := InvoiceMaterializedView.GETFILTER("Bill Date");
        IF DateFilter <> '' THEN BEGIN
            FromDate := InvoiceMaterializedView.GETRANGEMIN("Bill Date");
            ToDate := InvoiceMaterializedView.GETRANGEMAX("Bill Date");
        END;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyOneLineAddress: Text;
        CompanyCommunicationAddress: Text;
        CompanyAddr: array[8] of Text[50];
        ReportType: Option "Sales Invoices","Sales Credit Memo";
        Text000: Label 'Please fill in Posting Date Filter';
        ReportCaption: Label 'Discount Invoice Materialized View';
        FromDate: Date;
        ToDate: Date;
        SystemManagement: Codeunit "IRD Mgt.";
        AllFilters: Text;
        DateFilter: Text;
        LineDisAmt: Decimal;
        SalesInvoiceLine: Record "Sales Invoice Line";

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

