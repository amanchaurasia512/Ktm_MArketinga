codeunit 50000 "IRD Mgt."
{
    Permissions = TableData 50000 = r,
                  TableData 50001 = rim,
                  TableData 50002 = rim;

    trigger OnRun()
    begin
        //MESSAGE(FORMAT(CALCDATE('<-CM>')));
    end;

    var
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text1280000: Label 'LAKH';
        Text1280001: Label 'CRORE';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        UserSetup: Record "User Setup";

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    [Scope('OnPrem')]
    procedure BuildAppVersion(var SystemAppVersion: Text[80])
    var
        AppVersionTxt: Label 'NP 9.0.45243.5 Agile Solutions Pvt. Ltd. Localization for Nepal';
    begin
        SystemAppVersion := COPYSTR((AppVersionTxt), 1, 80);
    end;

    [Scope('OnPrem')]
    procedure Binding()
    begin
    end;

    [Scope('OnPrem')]
    procedure CalculateInvoiceTotals(TableNo: Integer; DocumentNo: Code[20]; var TotalSubTotal: Decimal; var TotalInvDiscAmount: Decimal; var TotalTaxableAmount: Decimal; var TotalAmountVAT: Decimal; var TotalAmountInclVAT: Decimal)
    var
        Currency: Record Currency;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
    begin
        TotalSubTotal := 0;
        TotalInvDiscAmount := 0;
        TotalTaxableAmount := 0;
        TotalAmountVAT := 0;
        TotalAmountInclVAT := 0;
        CASE TableNo OF
            DATABASE::"Sales Invoice Header":
                BEGIN
                    IF NOT SalesInvHeader.GET(DocumentNo) THEN
                        EXIT;
                    SalesInvLine.RESET;
                    SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
                    IF SalesInvLine.FINDSET THEN
                        REPEAT
                            IF NOT SalesInvLine."Prepayment Line" THEN BEGIN
                                IF SalesInvHeader."Currency Code" = '' THEN
                                    Currency.InitRoundingPrecision
                                ELSE BEGIN
                                    SalesInvHeader.TESTFIELD("Currency Factor");
                                    Currency.GET(SalesInvHeader."Currency Code");
                                    Currency.TESTFIELD("Amount Rounding Precision");
                                END;
                                TotalSubTotal += ROUND(SalesInvLine.Quantity * SalesInvLine."Unit Price", Currency."Amount Rounding Precision");
                                TotalInvDiscAmount += SalesInvLine."Line Discount Amount";
                                TotalInvDiscAmount += SalesInvLine."Inv. Discount Amount";
                                IF SalesInvLine."VAT %" > 0 THEN
                                    TotalTaxableAmount += SalesInvLine.Amount;
                                TotalAmountVAT += SalesInvLine."Amount Including VAT" - SalesInvLine.Amount;
                                TotalAmountInclVAT += SalesInvLine."Amount Including VAT";
                            END;
                        UNTIL SalesInvLine.NEXT = 0;
                END;

            DATABASE::"Service Invoice Header":
                BEGIN
                    IF NOT ServiceInvoiceHeader.GET(DocumentNo) THEN
                        EXIT;
                    ServiceInvoiceLine.RESET;
                    ServiceInvoiceLine.SETRANGE("Document No.", ServiceInvoiceHeader."No.");
                    IF ServiceInvoiceLine.FINDSET THEN
                        REPEAT
                            IF ServiceInvoiceHeader."Currency Code" = '' THEN
                                Currency.InitRoundingPrecision
                            ELSE BEGIN
                                ServiceInvoiceHeader.TESTFIELD("Currency Factor");
                                Currency.GET(ServiceInvoiceHeader."Currency Code");
                                Currency.TESTFIELD("Amount Rounding Precision");
                            END;
                            TotalSubTotal += ROUND(ServiceInvoiceLine.Quantity * ServiceInvoiceLine."Unit Price", Currency."Amount Rounding Precision");
                            TotalInvDiscAmount += ServiceInvoiceLine."Line Discount Amount";
                            TotalInvDiscAmount += ServiceInvoiceLine."Inv. Discount Amount";
                            IF ServiceInvoiceLine."VAT %" > 0 THEN
                                TotalTaxableAmount += ServiceInvoiceLine.Amount;
                            TotalAmountVAT += ServiceInvoiceLine."Amount Including VAT" - ServiceInvoiceLine.Amount;
                            TotalAmountInclVAT += ServiceInvoiceLine."Amount Including VAT";
                        UNTIL ServiceInvoiceLine.NEXT = 0;
                END;

            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    IF NOT SalesCrMemoHeader.GET(DocumentNo) THEN
                        EXIT;
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                    IF SalesCrMemoLine.FINDSET THEN
                        REPEAT
                            IF NOT SalesCrMemoLine."Prepayment Line" THEN BEGIN
                                IF SalesCrMemoHeader."Currency Code" = '' THEN
                                    Currency.InitRoundingPrecision
                                ELSE BEGIN
                                    SalesCrMemoHeader.TESTFIELD("Currency Factor");
                                    Currency.GET(SalesCrMemoHeader."Currency Code");
                                    Currency.TESTFIELD("Amount Rounding Precision");
                                END;
                                TotalSubTotal += ROUND(SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price", Currency."Amount Rounding Precision");
                                TotalInvDiscAmount += SalesCrMemoLine."Line Discount Amount";
                                TotalInvDiscAmount += SalesCrMemoLine."Inv. Discount Amount";
                                IF SalesCrMemoLine."VAT %" > 0 THEN
                                    TotalTaxableAmount += SalesCrMemoLine.Amount;
                                TotalAmountVAT += SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount;
                                TotalAmountInclVAT += SalesCrMemoLine."Amount Including VAT";
                            END;
                        UNTIL SalesCrMemoLine.NEXT = 0;
                END;

            DATABASE::"Service Cr.Memo Header":
                BEGIN
                    IF NOT ServiceCrMemoHeader.GET(DocumentNo) THEN
                        EXIT;
                    ServiceCrMemoLine.RESET;
                    ServiceCrMemoLine.SETRANGE("Document No.", ServiceCrMemoHeader."No.");
                    IF ServiceCrMemoLine.FINDSET THEN
                        REPEAT
                            IF ServiceCrMemoHeader."Currency Code" = '' THEN
                                Currency.InitRoundingPrecision
                            ELSE BEGIN
                                ServiceCrMemoHeader.TESTFIELD("Currency Factor");
                                Currency.GET(ServiceCrMemoHeader."Currency Code");
                                Currency.TESTFIELD("Amount Rounding Precision");
                            END;
                            TotalSubTotal += ROUND(ServiceCrMemoLine.Quantity * ServiceCrMemoLine."Unit Price", Currency."Amount Rounding Precision");
                            TotalInvDiscAmount += ServiceCrMemoLine."Line Discount Amount";
                            TotalInvDiscAmount += ServiceCrMemoLine."Inv. Discount Amount";
                            IF ServiceCrMemoLine."VAT %" > 0 THEN
                                TotalTaxableAmount += ServiceCrMemoLine.Amount;
                            TotalAmountVAT += ServiceCrMemoLine."Amount Including VAT" - ServiceCrMemoLine.Amount;
                            TotalAmountInclVAT += ServiceCrMemoLine."Amount Including VAT";
                        UNTIL ServiceCrMemoLine.NEXT = 0;
                END;

        END;
    end;

    [Scope('OnPrem')]
    procedure CreatePurchaseOrder(PurchConsignment: Record "TDS Posting Buffer"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        Text101: Label 'Purchase Order %1 has been created.';
        Text102: Label 'Purchase Orders exist for Purchase Consignment No. %1. Do you to create new Purchase Order?';
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."TDS Group";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('OnPrem')]
    procedure CreatePurchaseInvoice(PurchConsignment: Record "TDS Posting Buffer"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        Text101: Label 'Purchase Invoice %1 has been created.';
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."TDS Group";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('OnPrem')]
    procedure CreatePurchaseCreditMemo(PurchConsignment: Record "TDS Posting Buffer"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        Text101: Label 'Purchase Credit Memo %1 has been created.';
        Text102: Label 'Purchase Credit Memo exist for Purchase Consignment No. %1. Do you want to create new Purchase Credit Memo?';
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."TDS Group";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('OnPrem')]
    procedure CreatePurchaseReturnOrder(PurchConsignment: Record "TDS Posting Buffer"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        Text101: Label 'Purchase Credit Memo %1 has been created.';
        Text102: Label 'Purchase Credit Memo exist for Purchase Consignment No. %1. Do you want to create new Purchase Credit Memo?';
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Return Order";
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."TDS Group";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('OnPrem')]
    procedure CheckVendor(VendorNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        IF Vendor.GET(VendorNo) THEN
            Vendor.TESTFIELD("VAT Registration No.");
    end;

    [Scope('OnPrem')]
    procedure CheckCustomer(CustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        IF Customer.GET(CustomerNo) THEN
            Customer.TESTFIELD("VAT Registration No.");
    end;

    [Scope('OnPrem')]
    procedure EnableChangeLog()
    var
        ChangeLogSetup: Record "Change Log Setup";
    begin
        IF NOT ChangeLogSetup.GET THEN BEGIN
            ChangeLogSetup.INIT;
            ChangeLogSetup."Change Log Activated" := TRUE;
            ChangeLogSetup.INSERT;
        END
        ELSE BEGIN
            ChangeLogSetup."Change Log Activated" := TRUE;
            ChangeLogSetup.MODIFY;
        END;
        InsertTableChangeLog(3);
        InsertTableChangeLog(4);
        InsertTableChangeLog(5);
        InsertTableChangeLog(9);
        InsertTableChangeLog(10);
        InsertTableChangeLog(13);
        InsertTableChangeLog(14);
        InsertTableChangeLog(15);
        InsertTableChangeLog(18);
        InsertTableChangeLog(23);
        InsertTableChangeLog(27);
        InsertTableChangeLog(50);
        InsertTableChangeLog(77);
        InsertTableChangeLog(78);
        InsertTableChangeLog(79);
        InsertTableChangeLog(80);
        InsertTableChangeLog(82);
        InsertTableChangeLog(84);
        InsertTableChangeLog(85);
        InsertTableChangeLog(91);
        InsertTableChangeLog(92);
        InsertTableChangeLog(93);
        InsertTableChangeLog(94);
        InsertTableChangeLog(95);
        InsertTableChangeLog(98);
        InsertTableChangeLog(112);
        InsertTableChangeLog(113);
        InsertTableChangeLog(114);
        InsertTableChangeLog(115);
        InsertTableChangeLog(131);
        InsertTableChangeLog(135);
        InsertTableChangeLog(152);
        InsertTableChangeLog(156);
        InsertTableChangeLog(200);
        InsertTableChangeLog(201);
        InsertTableChangeLog(202);
        InsertTableChangeLog(204);
        InsertTableChangeLog(205);
        InsertTableChangeLog(206);
        InsertTableChangeLog(208);
        InsertTableChangeLog(209);
        InsertTableChangeLog(220);
        InsertTableChangeLog(230);
        InsertTableChangeLog(231);
        InsertTableChangeLog(232);
        InsertTableChangeLog(233);
        InsertTableChangeLog(236);
        InsertTableChangeLog(237);
        InsertTableChangeLog(242);
        InsertTableChangeLog(244);
        InsertTableChangeLog(245);
        InsertTableChangeLog(250);
        InsertTableChangeLog(251);
        InsertTableChangeLog(252);
        InsertTableChangeLog(254);
        InsertTableChangeLog(270);
        InsertTableChangeLog(289);
        InsertTableChangeLog(308);
        InsertTableChangeLog(309);
        InsertTableChangeLog(310);
        InsertTableChangeLog(311);
        InsertTableChangeLog(312);
        InsertTableChangeLog(313);
        InsertTableChangeLog(314);
        InsertTableChangeLog(315);
        InsertTableChangeLog(323);
        InsertTableChangeLog(324);
        InsertTableChangeLog(325);
        InsertTableChangeLog(333);
        InsertTableChangeLog(334);
        InsertTableChangeLog(348);
        InsertTableChangeLog(349);
        InsertTableChangeLog(350);
        InsertTableChangeLog(351);
        InsertTableChangeLog(352);
        InsertTableChangeLog(363);
        InsertTableChangeLog(409);
        InsertTableChangeLog(470);
        InsertTableChangeLog(471);
        InsertTableChangeLog(472);
        InsertTableChangeLog(487);
        InsertTableChangeLog(550);
        InsertTableChangeLog(750);
        InsertTableChangeLog(762);
        InsertTableChangeLog(770);
        InsertTableChangeLog(843);
        InsertTableChangeLog(869);
        InsertTableChangeLog(980);
        InsertTableChangeLog(1108);
        InsertTableChangeLog(1112);
        InsertTableChangeLog(1200);
        InsertTableChangeLog(1213);
        InsertTableChangeLog(1261);
        InsertTableChangeLog(1270);
        InsertTableChangeLog(1275);
        InsertTableChangeLog(1501);
        InsertTableChangeLog(1508);
        InsertTableChangeLog(1510);
        InsertTableChangeLog(1512);
        InsertTableChangeLog(5050);
        InsertTableChangeLog(5063);
        InsertTableChangeLog(5064);
        InsertTableChangeLog(5068);
        InsertTableChangeLog(5069);
        InsertTableChangeLog(5070);
        InsertTableChangeLog(5071);
        InsertTableChangeLog(5073);
        InsertTableChangeLog(5079);
        InsertTableChangeLog(5083);
        InsertTableChangeLog(5084);
        InsertTableChangeLog(5105);
        InsertTableChangeLog(5122);
        InsertTableChangeLog(5200);
        InsertTableChangeLog(5202);
        InsertTableChangeLog(5203);
        InsertTableChangeLog(5204);
        InsertTableChangeLog(5205);
        InsertTableChangeLog(5206);
        InsertTableChangeLog(5209);
        InsertTableChangeLog(5210);
        InsertTableChangeLog(5211);
        InsertTableChangeLog(5215);
        InsertTableChangeLog(5216);
        InsertTableChangeLog(5218);
        InsertTableChangeLog(5404);
        InsertTableChangeLog(5600);
        InsertTableChangeLog(5603);
        InsertTableChangeLog(5604);
        InsertTableChangeLog(5605);
        InsertTableChangeLog(5606);
        InsertTableChangeLog(5607);
        InsertTableChangeLog(5608);
        InsertTableChangeLog(5609);
        InsertTableChangeLog(5611);
        InsertTableChangeLog(5612);
        InsertTableChangeLog(5619);
        InsertTableChangeLog(5620);
        InsertTableChangeLog(5622);
        InsertTableChangeLog(5623);
        InsertTableChangeLog(5626);
        InsertTableChangeLog(5628);
        InsertTableChangeLog(5630);
        InsertTableChangeLog(5633);
        InsertTableChangeLog(5634);
        InsertTableChangeLog(5700);
        InsertTableChangeLog(5714);
        InsertTableChangeLog(5715);
        InsertTableChangeLog(5718);
        InsertTableChangeLog(5719);
        InsertTableChangeLog(5722);
        InsertTableChangeLog(5723);
        InsertTableChangeLog(5769);
        InsertTableChangeLog(5813);
        InsertTableChangeLog(5814);
        InsertTableChangeLog(5911);
        InsertTableChangeLog(5915);
        InsertTableChangeLog(5916);
        InsertTableChangeLog(5917);
        InsertTableChangeLog(5918);
        InsertTableChangeLog(5919);
        InsertTableChangeLog(5920);
        InsertTableChangeLog(5921);
        InsertTableChangeLog(5927);
        InsertTableChangeLog(5928);
        InsertTableChangeLog(5929);
        InsertTableChangeLog(5940);
        InsertTableChangeLog(5941);
        InsertTableChangeLog(5945);
        InsertTableChangeLog(5954);
        InsertTableChangeLog(5955);
        InsertTableChangeLog(5956);
        InsertTableChangeLog(5957);
        InsertTableChangeLog(5958);
        InsertTableChangeLog(5966);
        InsertTableChangeLog(5968);
        InsertTableChangeLog(5996);
        InsertTableChangeLog(6080);
        InsertTableChangeLog(6081);
        InsertTableChangeLog(6082);
        InsertTableChangeLog(6502);
        InsertTableChangeLog(6504);
        InsertTableChangeLog(6505);
        InsertTableChangeLog(6635);
        InsertTableChangeLog(7002);
        InsertTableChangeLog(7004);
        InsertTableChangeLog(7012);
        InsertTableChangeLog(7014);
        InsertTableChangeLog(7111);
        InsertTableChangeLog(7112);
        InsertTableChangeLog(7113);
        InsertTableChangeLog(7116);
        InsertTableChangeLog(7152);
        InsertTableChangeLog(7300);
        InsertTableChangeLog(7301);
        InsertTableChangeLog(7302);
        InsertTableChangeLog(7303);
        InsertTableChangeLog(7304);
        InsertTableChangeLog(7305);
        InsertTableChangeLog(7309);
        InsertTableChangeLog(7310);
        InsertTableChangeLog(7326);
        InsertTableChangeLog(7327);
        InsertTableChangeLog(7328);
        InsertTableChangeLog(7335);
        InsertTableChangeLog(7336);
        InsertTableChangeLog(7337);
        InsertTableChangeLog(7338);
        InsertTableChangeLog(7354);
        InsertTableChangeLog(7600);
        InsertTableChangeLog(9000);
        InsertTableChangeLog(9001);
        InsertTableChangeLog(9002);
        InsertTableChangeLog(9003);
        InsertTableChangeLog(9651);
        InsertTableChangeLog(9657);
        InsertTableChangeLog(50000);
        InsertTableChangeLog(50001);
        InsertTableChangeLog(50002);
    end;

    [Scope('OnPrem')]
    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        IF CurrencyCode <> '' THEN BEGIN
            Currency.GET(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        END ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        // AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
        IF (CurrencyCode <> '') THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, '')
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    [Scope('OnPrem')]
    procedure getNepaliDate(EngDate: Date): Code[10]
    var
        EnglishNepaliDate: Record "English-Nepali Date";
        Text0000: Label 'Cannot find the equivalant Nepali Date! Please contact your system administrator.';
    begin
        EnglishNepaliDate.RESET;
        EnglishNepaliDate.SETRANGE("English Date", EngDate);
        IF EnglishNepaliDate.FIND('-') THEN
            EXIT(EnglishNepaliDate."Nepali Date");
    end;

    [Scope('OnPrem')]
    procedure getEngDate(NepDate: Code[20]): Date
    var
        EnglishNepaliDate: Record "English-Nepali Date";
        Text001: Label 'Cannot find equivalant English Date! Please contact your system administrator.';
    begin
        EnglishNepaliDate.RESET;
        EnglishNepaliDate.SETRANGE("Nepali Date", NepDate);
        IF EnglishNepaliDate.FIND('-') THEN
            EXIT(EnglishNepaliDate."English Date");
    end;

    [Scope('OnPrem')]
    procedure GetNepaliFiscalYear(PostingDate: Date): Text[30]
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE("Starting Date", 0D, PostingDate);
        IF AccountingPeriod.FINDLAST THEN BEGIN
            VerifyAndSetNepaliFiscalYear(PostingDate);
            EXIT(AccountingPeriod."Nepali Fiscal Year");
        END;
    end;

    [Scope('OnPrem')]
    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text1280000;
        ExponentText[4] := Text1280001;
    end;

    [Scope('OnPrem')]
    procedure InsertRepSelection(ReportUsage: Integer; Sequence: Code[10]; ReportID: Integer)
    var
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.RESET;
        ReportSelections.SETRANGE(Usage, ReportUsage);
        ReportSelections.SETRANGE(Sequence, Sequence);
        ReportSelections.DELETEALL;

        CLEAR(ReportSelections);
        ReportSelections.INIT;
        ReportSelections.Usage := ReportUsage;
        ReportSelections.Sequence := Sequence;
        ReportSelections."Report ID" := ReportID;
        ReportSelections.INSERT;
    end;

    [Scope('OnPrem')]
    procedure InsertRegisterInvoice(TableID: Integer; DocumentNo: Code[20])
    var
        AccountingPeriod: Record "Accounting Period";
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";//after exporting table
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        CASE TableID OF
            DATABASE::"Sales Invoice Header":
                BEGIN
                    IF NOT SalesInvHeader.GET(DocumentNo) THEN
                        EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Sales Invoice Header";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice";
                    RegisterofInvoiceNoSeries."Bill No" := SalesInvHeader."No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := GetNepaliFiscalYear(SalesInvHeader."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := SalesInvHeader."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := SalesInvHeader."Posting Time";
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := SalesInvHeader."Bill-to Customer No.";
                    RegisterofInvoiceNoSeries."Source Code" := SalesInvHeader."Source Code";
                    RegisterofInvoiceNoSeries."Customer Name" := SalesInvHeader."Bill-to Name";
                    RegisterofInvoiceNoSeries."VAT Registration No." := SalesInvHeader."VAT Registration No.";
                    SetSyncStatus(RegisterofInvoiceNoSeries);
                    CalculateInvoiceTotals(DATABASE::"Sales Invoice Header", SalesInvHeader."No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Created By" := SalesInvHeader."User ID";
                    RegisterofInvoiceNoSeries."Is Bill Printed" := SalesInvHeader."No. Printed" > 0;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := SalesInvHeader."Tax Invoice Printed By";
                    //Agile SRT Jan 2nd 2019 >>
                    RegisterofInvoiceNoSeries."Shortcut Dimension 1 Code" := SalesInvHeader."Shortcut Dimension 1 Code";
                    RegisterofInvoiceNoSeries."Shortcut Dimension 2 Code" := SalesInvHeader."Shortcut Dimension 2 Code";
                    //Agile SRT Jan 2nd 2019 <<
                    RegisterofInvoiceNoSeries.INSERT;
                END;

            DATABASE::"Service Invoice Header":
                BEGIN
                    IF NOT ServiceInvoiceHeader.GET(DocumentNo) THEN
                        EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Service Invoice Header";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice";
                    RegisterofInvoiceNoSeries."Bill No" := ServiceInvoiceHeader."No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := GetNepaliFiscalYear(ServiceInvoiceHeader."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := ServiceInvoiceHeader."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := ServiceInvoiceHeader."Posting Time";
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := ServiceInvoiceHeader."Bill-to Customer No.";
                    RegisterofInvoiceNoSeries."Source Code" := ServiceInvoiceHeader."Source Code";
                    RegisterofInvoiceNoSeries."Customer Name" := ServiceInvoiceHeader."Bill-to Name";
                    RegisterofInvoiceNoSeries."VAT Registration No." := ServiceInvoiceHeader."VAT Registration No.";

                    CalculateInvoiceTotals(DATABASE::"Service Invoice Header", ServiceInvoiceHeader."No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Created By" := ServiceInvoiceHeader."User ID";
                    RegisterofInvoiceNoSeries."Is Bill Printed" := ServiceInvoiceHeader."No. Printed" > 0;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := ServiceInvoiceHeader."Tax Invoice Printed By";
                    RegisterofInvoiceNoSeries.INSERT;
                END;
            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    IF NOT SalesCrMemoHeader.GET(DocumentNo) THEN
                        EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Sales Cr.Memo Header";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Credit Memo";
                    RegisterofInvoiceNoSeries."Bill No" := SalesCrMemoHeader."No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := GetNepaliFiscalYear(SalesCrMemoHeader."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := SalesCrMemoHeader."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := SalesCrMemoHeader."Posting Time";
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := SalesCrMemoHeader."Bill-to Customer No.";
                    RegisterofInvoiceNoSeries."Source Code" := SalesCrMemoHeader."Source Code";
                    RegisterofInvoiceNoSeries."Customer Name" := SalesCrMemoHeader."Bill-to Name";
                    RegisterofInvoiceNoSeries."VAT Registration No." := SalesCrMemoHeader."VAT Registration No.";
                    SetSyncStatus(RegisterofInvoiceNoSeries);
                    CalculateInvoiceTotals(DATABASE::"Sales Cr.Memo Header", SalesCrMemoHeader."No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Created By" := SalesCrMemoHeader."User ID";
                    RegisterofInvoiceNoSeries."Is Bill Printed" := SalesCrMemoHeader."No. Printed" > 0;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := SalesCrMemoHeader."Printed By";
                    //Agile SRT Jan 2nd 2019 >>
                    RegisterofInvoiceNoSeries."Shortcut Dimension 1 Code" := SalesCrMemoHeader."Shortcut Dimension 1 Code";
                    RegisterofInvoiceNoSeries."Shortcut Dimension 2 Code" := SalesCrMemoHeader."Shortcut Dimension 2 Code";
                    //Agile SRT Jan 2nd 2019 <<
                    RegisterofInvoiceNoSeries.INSERT;
                    SetInActiveInvoices(DATABASE::"Sales Cr.Memo Header", DocumentNo);
                END;
            DATABASE::"Service Cr.Memo Header":
                BEGIN
                    IF NOT ServiceCrMemoHeader.GET(DocumentNo) THEN
                        EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Service Cr.Memo Header";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Credit Memo";
                    RegisterofInvoiceNoSeries."Bill No" := ServiceCrMemoHeader."No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := GetNepaliFiscalYear(ServiceCrMemoHeader."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := ServiceCrMemoHeader."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := ServiceCrMemoHeader."Posting Time";
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := ServiceCrMemoHeader."Bill-to Customer No.";
                    RegisterofInvoiceNoSeries."Source Code" := ServiceCrMemoHeader."Source Code";
                    RegisterofInvoiceNoSeries."Customer Name" := ServiceCrMemoHeader."Bill-to Name";
                    RegisterofInvoiceNoSeries."VAT Registration No." := ServiceCrMemoHeader."VAT Registration No.";

                    CalculateInvoiceTotals(DATABASE::"Service Cr.Memo Header", ServiceCrMemoHeader."No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Created By" := ServiceCrMemoHeader."User ID";
                    RegisterofInvoiceNoSeries."Is Bill Printed" := ServiceCrMemoHeader."No. Printed" > 0;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := ServiceCrMemoHeader."Printed By";
                    RegisterofInvoiceNoSeries.INSERT;
                    SetInActiveInvoices(DATABASE::"Service Cr.Memo Header", DocumentNo);
                END;
        END;
    end;

    [Scope('OnPrem')]
    procedure SetSyncStatus(var InvoiceMaterializeView: Record "Invoice Materialize View")
    var
        CBMSMgt: Codeunit "IRD CBMS Mgt.";
        ReturnedDocNo: Code[20];
    begin
        IF CBMSMgt.Enabled THEN BEGIN
            IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Credit Memo" THEN BEGIN
                IF CBMSMgt.RealTimeEnabled THEN
                    InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::"Sync In Progress"
                ELSE
                    InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::Pending;
            END
            ELSE
                IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Invoice" THEN BEGIN
                    IF CBMSMgt.RealTimeEnabled THEN
                        InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::"Sync In Progress"
                    ELSE
                        InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::Pending;
                END;
        END
        ELSE BEGIN
            InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::"Not Valid";
        END;
    end;

    [Scope('OnPrem')]
    procedure InsertSalesDocPrintHistory(TableNo: Integer; DocumentNo: Code[20]; PrintingDate: Date; PrintingTime: Time)
    var
        SalesInvoicePrintHistory: Record "Sales Invoice Print History";
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        PostingDate: Date;
        LastNoOfPrint: Integer;
        LastLineNo: Integer;
        DocumentType: Option "Sales Invoice","Sales Credit Memo";
        FiscalYear: Text[30];
    begin
        SalesInvoicePrintHistory.RESET;
        SalesInvoicePrintHistory.SETRANGE("Table ID", TableNo);
        CASE TableNo OF
            DATABASE::"Sales Invoice Header":
                BEGIN
                    SalesInvoicePrintHistory.SETRANGE("Document Type", SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
                    SalesInvHeader.GET(DocumentNo);
                    LastNoOfPrint := SalesInvHeader."No. Printed";
                    PostingDate := SalesInvHeader."Posting Date";
                    DocumentType := DocumentType::"Sales Invoice";
                    FiscalYear := GetNepaliFiscalYear(PostingDate);
                END;
            DATABASE::"Service Invoice Header":
                BEGIN
                    SalesInvoicePrintHistory.SETRANGE("Document Type", SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
                    ServiceInvoiceHeader.GET(DocumentNo);
                    LastNoOfPrint := ServiceInvoiceHeader."No. Printed";
                    PostingDate := ServiceInvoiceHeader."Posting Date";
                    DocumentType := DocumentType::"Sales Invoice";
                    FiscalYear := GetNepaliFiscalYear(PostingDate);
                END;
            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    SalesInvoicePrintHistory.SETRANGE("Document Type", SalesInvoicePrintHistory."Document Type"::"Sales Credit Memo");
                    SalesCrMemoHeader.GET(DocumentNo);
                    LastNoOfPrint := SalesCrMemoHeader."No. Printed";
                    PostingDate := SalesCrMemoHeader."Posting Date";
                    DocumentType := DocumentType::"Sales Credit Memo";
                    FiscalYear := GetNepaliFiscalYear(PostingDate);
                END;
            DATABASE::"Service Cr.Memo Header":
                BEGIN
                    SalesInvoicePrintHistory.SETRANGE("Document Type", SalesInvoicePrintHistory."Document Type"::"Sales Credit Memo");
                    ServiceCrMemoHeader.GET(DocumentNo);
                    LastNoOfPrint := ServiceCrMemoHeader."No. Printed";
                    PostingDate := ServiceCrMemoHeader."Posting Date";
                    DocumentType := DocumentType::"Sales Credit Memo";
                    FiscalYear := GetNepaliFiscalYear(PostingDate);
                END;
        END;
        SalesInvoicePrintHistory.SETRANGE("Document No.", DocumentNo);
        SalesInvoicePrintHistory.SETRANGE("Fiscal Year", FiscalYear);
        IF SalesInvoicePrintHistory.FINDLAST THEN
            LastLineNo := SalesInvoicePrintHistory."Line No.";

        SalesInvoicePrintHistory.INIT;
        SalesInvoicePrintHistory."Table ID" := TableNo;
        SalesInvoicePrintHistory."Document Type" := DocumentType;
        SalesInvoicePrintHistory."Document No." := DocumentNo;
        SalesInvoicePrintHistory."Fiscal Year" := GetNepaliFiscalYear(PostingDate);
        SalesInvoicePrintHistory."Line No." := LastLineNo + 10000;
        SalesInvoicePrintHistory."Printing Date" := PrintingDate;
        SalesInvoicePrintHistory."Printed Time" := PrintingTime;
        SalesInvoicePrintHistory."Printed By" := USERID;
        IF LastNoOfPrint = 0 THEN BEGIN
            SalesInvoicePrintHistory.Type := SalesInvoicePrintHistory.Type::"Tax Invoice";
            SalesInvoicePrintHistory."Times Printed" := 1
        END
        ELSE
            IF LastNoOfPrint = 1 THEN BEGIN
                SalesInvoicePrintHistory.Type := SalesInvoicePrintHistory.Type::Invoice;
                SalesInvoicePrintHistory."Times Printed" := 1
            END
            ELSE BEGIN
                SalesInvoicePrintHistory.Type := SalesInvoicePrintHistory.Type::"Copy of Original";
                SalesInvoicePrintHistory."Times Printed" := LastNoOfPrint - 1;
            END;

        SalesInvoicePrintHistory.INSERT;
    end;

    [Scope('OnPrem')]
    procedure InsertSalesMaterializedView(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    begin
        IF SalesHeader.Invoice THEN BEGIN
            IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN BEGIN
                InsertRegisterInvoice(DATABASE::"Sales Invoice Header", SalesInvHdrNo);
            END
            ELSE BEGIN
                InsertRegisterInvoice(DATABASE::"Sales Cr.Memo Header", SalesCrMemoHdrNo);
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure InsertServiceMaterializedView(var ServiceHeader: Record "Service Header"; ServiceShptHdrNo: Code[20]; ServiceInvHdrNo: Code[20]; ServiceCrMemoHdrNo: Code[20]; Ship: Boolean; Consume: Boolean; Invoice: Boolean; WhseShip: Boolean)
    begin
        IF Invoice THEN BEGIN
            IF ServiceHeader."Document Type" IN [ServiceHeader."Document Type"::Order, ServiceHeader."Document Type"::Invoice] THEN BEGIN
                InsertRegisterInvoice(DATABASE::"Service Invoice Header", ServiceInvHdrNo);
            END
            ELSE BEGIN
                InsertRegisterInvoice(DATABASE::"Service Cr.Memo Header", ServiceCrMemoHdrNo);
            END;
        END;
    end;

    local procedure InsertTableChangeLog(TableID: Integer)
    var
        ChangeLogSetupTable: Record "Change Log Setup (Table)";
    begin
        IF NOT ChangeLogSetupTable.GET(TableID) THEN BEGIN
            ChangeLogSetupTable.INIT;
            ChangeLogSetupTable."Table No." := TableID;
            ChangeLogSetupTable."Log Insertion" := ChangeLogSetupTable."Log Insertion"::"All Fields";
            ChangeLogSetupTable."Log Modification" := ChangeLogSetupTable."Log Modification"::"All Fields";
            ChangeLogSetupTable."Log Deletion" := ChangeLogSetupTable."Log Deletion"::"All Fields";
            ChangeLogSetupTable.INSERT;
        END
        ELSE BEGIN
            ChangeLogSetupTable."Log Insertion" := ChangeLogSetupTable."Log Insertion"::"All Fields";
            ChangeLogSetupTable."Log Modification" := ChangeLogSetupTable."Log Modification"::"All Fields";
            ChangeLogSetupTable."Log Deletion" := ChangeLogSetupTable."Log Deletion"::"All Fields";
            ChangeLogSetupTable.MODIFY;
        END;
    end;

    [Scope('OnPrem')]
    procedure InitReportSelection()
    var
        ReportSelections: Record "Report Selections";
    begin
        InsertRepSelection(ReportSelections.Usage::"S.Quote", '1', REPORT::"Sales Quote");
        InsertRepSelection(ReportSelections.Usage::"S.Order", '1', REPORT::"Sales Order");
        InsertRepSelection(ReportSelections.Usage::"S.Invoice", '1', REPORT::"Sales Invoice");
        InsertRepSelection(ReportSelections.Usage::"S.Return", '1', REPORT::"Return Order Confirmation");
        InsertRepSelection(ReportSelections.Usage::"S.Cr.Memo", '1', REPORT::"Sales Credit Memo");
        InsertRepSelection(ReportSelections.Usage::"S.Shipment", '1', REPORT::"Sales Shipment");
        InsertRepSelection(ReportSelections.Usage::"S.Ret.Rcpt.", '1', REPORT::"Sales - Return Receipt");
        InsertRepSelection(ReportSelections.Usage::"SM.Invoice", '1', REPORT::"Last Sales Price List");
        InsertRepSelection(ReportSelections.Usage::"SM.Order", '1', REPORT::"Trial Balance Plus All");
        InsertRepSelection(ReportSelections.Usage::"P.Quote", '1', REPORT::"Purchase - Quote");
        InsertRepSelection(ReportSelections.Usage::"P.Order", '1', REPORT::"Purchase Order");
        InsertRepSelection(ReportSelections.Usage::"P.Invoice", '1', REPORT::"Purchase Invoice");
        InsertRepSelection(ReportSelections.Usage::"P.Return", '1', REPORT::"Return Order");
        InsertRepSelection(ReportSelections.Usage::"P.Cr.Memo", '1', REPORT::"Purchase Debit Memo");
        InsertRepSelection(ReportSelections.Usage::"P.Receipt", '1', REPORT::"Purchase Receipt");
        InsertRepSelection(ReportSelections.Usage::"P.Ret.Shpt.", '1', REPORT::"Purchase - Return Shipment");
        InsertRepSelection(ReportSelections.Usage::Inv2, '1', REPORT::"Transfer Shipments");
        InsertRepSelection(ReportSelections.Usage::Inv3, '1', REPORT::"Transfer Receipts");
    end;

    [Scope('OnPrem')]
    procedure ModifySalesInvPrintInformation(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        AccountingPeriod: Record "Accounting Period";
        PrintingDate: Date;
        PrintingTime: Time;
    begin
        PrintingDate := TODAY;
        PrintingTime := TIME;
        IF SalesInvoiceHeader."No. Printed" = 1 THEN BEGIN
            SalesInvoiceHeader."Tax Invoice Printed By" := USERID;
            RegisterofInvoiceNoSeries.RESET;
            RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
            RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
            RegisterofInvoiceNoSeries.SETRANGE("Bill No", SalesInvoiceHeader."No.");
            RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(SalesInvoiceHeader."Posting Date"));
            IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries."Is Bill Printed" := TRUE;
                RegisterofInvoiceNoSeries."Printed By" := USERID;
                RegisterofInvoiceNoSeries."Is Printed" := SalesInvoiceHeader."No. Printed";
                RegisterofInvoiceNoSeries."Printed Time" := PrintingTime;
                RegisterofInvoiceNoSeries.MODIFY;
            END;
        END;
        InsertSalesDocPrintHistory(DATABASE::"Sales Invoice Header", SalesInvoiceHeader."No.", PrintingDate, PrintingTime);
    end;

    [Scope('OnPrem')]
    procedure ModifySalesCrInvPrintInformation(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        AccountingPeriod: Record "Accounting Period";
        PrintingDate: Date;
        PrintingTime: Time;
    begin
        PrintingDate := TODAY;
        PrintingTime := TIME;
        IF SalesCrMemoHeader."No. Printed" = 1 THEN BEGIN
            SalesCrMemoHeader."Printed By" := USERID;
            RegisterofInvoiceNoSeries.RESET;
            RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
            RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
            RegisterofInvoiceNoSeries.SETRANGE("Bill No", SalesCrMemoHeader."No.");
            RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(SalesCrMemoHeader."Posting Date"));
            IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries."Is Bill Printed" := TRUE;
                RegisterofInvoiceNoSeries."Printed By" := USERID;
                RegisterofInvoiceNoSeries."Is Printed" := SalesCrMemoHeader."No. Printed";
                RegisterofInvoiceNoSeries."Printed Time" := PrintingTime;
                RegisterofInvoiceNoSeries.MODIFY;
            END;
        END;
        InsertSalesDocPrintHistory(DATABASE::"Sales Cr.Memo Header", SalesCrMemoHeader."No.", PrintingDate, PrintingTime);
    end;

    [Scope('OnPrem')]
    procedure ModifyServiceInvPrintInformation(var ServiceInvoiceHeader: Record "Service Invoice Header")
    var
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        AccountingPeriod: Record "Accounting Period";
        PrintingDate: Date;
        PrintingTime: Time;
    begin
        PrintingDate := TODAY;
        PrintingTime := TIME;
        IF ServiceInvoiceHeader."No. Printed" = 1 THEN BEGIN
            ServiceInvoiceHeader."Tax Invoice Printed By" := USERID;
            RegisterofInvoiceNoSeries.RESET;
            RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Service Invoice Header");
            RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
            RegisterofInvoiceNoSeries.SETRANGE("Bill No", ServiceInvoiceHeader."No.");
            RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(ServiceInvoiceHeader."Posting Date"));
            IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries."Is Bill Printed" := TRUE;
                RegisterofInvoiceNoSeries."Printed By" := USERID;
                RegisterofInvoiceNoSeries."Is Printed" := ServiceInvoiceHeader."No. Printed";
                RegisterofInvoiceNoSeries."Printed Time" := PrintingTime;
                RegisterofInvoiceNoSeries.MODIFY;
            END;
        END;
        InsertSalesDocPrintHistory(DATABASE::"Service Invoice Header", ServiceInvoiceHeader."No.", PrintingDate, PrintingTime);
    end;

    [Scope('OnPrem')]
    procedure ModifyServiceCrInvPrintInformation(var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    var
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
        AccountingPeriod: Record "Accounting Period";
        PrintingDate: Date;
        PrintingTime: Time;
    begin
        PrintingDate := TODAY;
        PrintingTime := TIME;
        IF ServiceCrMemoHeader."No. Printed" = 1 THEN BEGIN
            ServiceCrMemoHeader."Printed By" := USERID;
            RegisterofInvoiceNoSeries.RESET;
            RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Service Cr.Memo Header");
            RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
            RegisterofInvoiceNoSeries.SETRANGE("Bill No", ServiceCrMemoHeader."No.");
            RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(ServiceCrMemoHeader."Posting Date"));
            IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries."Is Bill Printed" := TRUE;
                RegisterofInvoiceNoSeries."Printed By" := USERID;
                RegisterofInvoiceNoSeries."Is Printed" := ServiceCrMemoHeader."No. Printed";
                RegisterofInvoiceNoSeries."Printed Time" := PrintingTime;
                RegisterofInvoiceNoSeries.MODIFY;
            END;
        END;
        InsertSalesDocPrintHistory(DATABASE::"Service Cr.Memo Header", ServiceCrMemoHeader."No.", PrintingDate, PrintingTime);
    end;

    [Scope('OnPrem')]
    procedure OneLineAddress(var AddrArray: array[8] of Text[50]) OneLineAddress: Text
    var
        i: Integer;
    begin
        COMPRESSARRAY(AddrArray);
        FOR i := 2 TO ARRAYLEN(AddrArray) DO BEGIN
            IF AddrArray[i] <> '' THEN
                IF OneLineAddress = '' THEN
                    OneLineAddress += AddrArray[i]
                ELSE
                    OneLineAddress += ', ' + AddrArray[i];
        END;
        EXIT(OneLineAddress);
    end;

    [Scope('OnPrem')]
    procedure PurchPostRestriction(var Sender: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        PurchLine: Record "Purchase Line";
        MistakeTDSGrpErr: Label '%1 %2 is not applicable for item charge %3.';
        ItemCharge: Record "Item Charge";
    begin
        /*Vendor.GET("Pay-to Vendor No.");
IF Vendor."Pragyapan Patra Mandatory" THEN
  TESTFIELD(PragyapanPatra)
ELSE
  TESTFIELD(PragyapanPatra,'');

IF Vendor."Consigment No. Mandatory" THEN
  TESTFIELD("Purchase Consignment No.")
ELSE
  TESTFIELD("Purchase Consignment No.",'');*/
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", Sender."Document Type");
        PurchLine.SETRANGE("Document No.", Sender."No.");
        PurchLine.SETFILTER(Quantity, '<>0');
        IF PurchLine.FINDSET THEN
            REPEAT
                IF PurchLine."Document Type" IN [PurchLine."Document Type"::"Return Order", PurchLine."Document Type"::"Credit Memo"] THEN
                    PurchLine.TESTFIELD("Return Reason Code")
                ELSE
                    IF PurchLine."Document Type" IN [PurchLine."Document Type"::Order, PurchLine."Document Type"::Invoice] THEN BEGIN
                        //ASPL Dec 24th 2020 >>
                        IF (PurchLine.Type = PurchLine.Type::"Charge (Item)") AND (PurchLine."TDS Group" <> '') THEN BEGIN
                            ItemCharge.GET(PurchLine."No.");
                            ItemCharge.TESTFIELD("Applicable TDS Posting Groups");
                            IF ItemCharge."Applicable TDS Posting Groups" <> '' THEN BEGIN
                                IF STRPOS(ItemCharge."Applicable TDS Posting Groups", PurchLine."TDS Group") = 0 THEN
                                    ERROR(MistakeTDSGrpErr, PurchLine.FIELDCAPTION("TDS Group"), PurchLine."TDS Group", PurchLine."No.");
                            END;
                        END;
                        //ASPL Dec 24th 2020 <<
                    END;
            UNTIL PurchLine.NEXT = 0;

    end;

    [Scope('OnPrem')]
    procedure SalesPostRestriction(var Sender: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesSetup.GET;
        //SalesSetup.TESTFIELD("Exact Cost Reversing Mandatory");
        VerifyAndSetNepaliFiscalYear(Sender."Posting Date");
        //ASPL Apr 6th 2021 >>
        IF (Sender."Document Type" = Sender."Document Type"::Order) AND
           (Sender."Location Code" = SalesSetup."Damage Location") AND
            SalesSetup."Restrict Invoicing from Damage" AND
            Sender.Invoice THEN
            ERROR('Invoicing from damage location is restricted.');
        IF (Sender."Document Type" = Sender."Document Type"::Invoice) AND
           (Sender."Location Code" = SalesSetup."Damage Location") THEN
            ERROR('Invoicing from damage location is restriced.');
        //ASPL Apr 6th 2021 <<

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", Sender."Document Type");
        SalesLine.SETRANGE("Document No.", Sender."No.");
        SalesLine.SETFILTER(Quantity, '<>0');
        IF SalesLine.FINDSET THEN
            REPEAT
                IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] THEN BEGIN
                    SalesLine.TESTFIELD("Return Reason Code");
                    SalesLine.TESTFIELD("Returned Document No.");
                    SalesInvLine.RESET;
                    SalesInvLine.SETRANGE("Document No.", SalesLine."Returned Document No.");
                    SalesInvLine.SETRANGE("Line No.", SalesLine."Returned Document Line No.");
                    IF SalesInvLine.FINDFIRST THEN BEGIN
                        SalesLine.TESTFIELD("Shortcut Dimension 1 Code", SalesInvLine."Shortcut Dimension 1 Code"); //Min
                        SalesLine.TESTFIELD("Shortcut Dimension 2 Code", SalesInvLine."Shortcut Dimension 2 Code");
                        SalesLine.TESTFIELD("Dimension Set ID", SalesInvLine."Dimension Set ID");//Min
                    END;

                    IF SalesInvHdr.GET(SalesLine."Returned Document No.") THEN BEGIN
                        UserSetup.GET(USERID); //Min
                        IF NOT UserSetup."Skip Diff Product Segment Code" THEN
                            Sender.TESTFIELD("Shortcut Dimension 1 Code", SalesInvHdr."Shortcut Dimension 1 Code");
                        //TESTFIELD("Shortcut Dimension 2 Code",SalesInvHdr."Shortcut Dimension 2 Code");
                    END;
                END;
            /*IF SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" THEN
              IF SalesLine."Returned Document No." <> 'NA' THEN
                SalesSetup.TESTFIELD("Exact Cost Reversing Mandatory");*/

            UNTIL SalesLine.NEXT = 0;

    end;

    [Scope('OnPrem')]
    procedure ServicePostRestriction(var Sender: Record "Service Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ServiceLine: Record "Service Line";
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Exact Cost Reversing Mandatory");
        VerifyAndSetNepaliFiscalYear(Sender."Posting Date");
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", Sender."Document Type");
        ServiceLine.SETRANGE("Document No.", Sender."No.");
        ServiceLine.SETFILTER(Quantity, '<>0');
        IF ServiceLine.FINDSET THEN
            REPEAT
                IF ServiceLine."Document Type" = ServiceLine."Document Type"::"Credit Memo" THEN BEGIN
                    ServiceLine.TESTFIELD("Return Reason Code");
                    ServiceLine.TESTFIELD("Returned Document No.");
                END;
            UNTIL ServiceLine.NEXT = 0;
    end;

    local procedure SetInActiveInvoices(TableID: Integer; DocumentNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        ValueEntry: Record "Value Entry";
        RegisterofInvoiceNoSeries: Record "Invoice Materialize View";
    begin
        CASE TableID OF
            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
                    SalesCrMemoLine.SETFILTER(Quantity, '<>0');
                    IF SalesCrMemoLine.FINDSET THEN
                        REPEAT
                            IF SalesInvHeader.GET(SalesCrMemoLine."Returned Document No.") THEN BEGIN
                                RegisterofInvoiceNoSeries.RESET;
                                RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
                                RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
                                RegisterofInvoiceNoSeries.SETRANGE("Bill No", SalesCrMemoLine."Returned Document No.");
                                RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(SalesInvHeader."Posting Date"));
                                IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                                    RegisterofInvoiceNoSeries."Is Bill Active" := FALSE;
                                    RegisterofInvoiceNoSeries.MODIFY;
                                END;
                            END;
                        UNTIL SalesCrMemoLine.NEXT = 0;
                END;
            DATABASE::"Service Cr.Memo Header":
                BEGIN
                    ServiceCrMemoLine.RESET;
                    ServiceCrMemoLine.SETRANGE("Document No.", DocumentNo);
                    ServiceCrMemoLine.SETFILTER(Quantity, '<>0');
                    IF ServiceCrMemoLine.FINDSET THEN
                        REPEAT
                            IF ServiceInvoiceHeader.GET(ServiceCrMemoLine."Returned Document No.") THEN BEGIN
                                RegisterofInvoiceNoSeries.RESET;
                                RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Service Invoice Header");
                                RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
                                RegisterofInvoiceNoSeries.SETRANGE("Bill No", ServiceCrMemoLine."Returned Document No.");
                                RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(ServiceInvoiceHeader."Posting Date"));
                                IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                                    RegisterofInvoiceNoSeries."Is Bill Active" := FALSE;
                                    RegisterofInvoiceNoSeries.MODIFY;
                                END;
                            END;
                        UNTIL ServiceCrMemoLine.NEXT = 0;
                END;
        END;
    end;

    [Scope('OnPrem')]
    procedure UpdatePurchLinesFCallFromPurchHeader(var Sender: Record "Purchase Header"; ChangedFieldName: Text[100]; var PurchaseLine: Record "Purchase Line")
    begin
        CASE ChangedFieldName OF
            Sender.FIELDCAPTION(PragyapanPatra):
                IF PurchaseLine."No." <> '' THEN
                    PurchaseLine.VALIDATE(PragyapanPatra, Sender.PragyapanPatra);
        END;
    end;

    [Scope('OnPrem')]
    procedure UpdatePurchLineOnField6Validation(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        IF PurchaseHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
            Rec.PragyapanPatra := PurchaseHeader.PragyapanPatra;
        END;
    end;

    [Scope('OnPrem')]
    procedure UpdateServLinesFCallFromServHeader(var Sender: Record "Service Header"; ChangedFieldName: Text[100]; var ServiceLine: Record "Service Line")
    begin
        CASE ChangedFieldName OF
            Sender.FIELDCAPTION("Applies-to Doc. No."):
                IF ServiceLine."No." <> '' THEN BEGIN
                    ServiceLine.VALIDATE("Returned Document No.", Sender."Applies-to Doc. No.");
                    ServiceLine.MODIFY(TRUE);
                END;
        END;
    end;

    [Scope('OnPrem')]
    procedure UpdateServLineOnField6Validation(var Rec: Record "Service Line"; var xRec: Record "Service Line"; CurrFieldNo: Integer)
    var
        ServiceHeader: Record "Service Header";
    begin
        IF ServiceHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
            Rec."Returned Document No." := ServiceHeader."Applies-to Doc. No.";
        END;
    end;

    [Scope('OnPrem')]
    procedure VerifyAndSetNepaliFiscalYear(PostingDate: Date)
    var
        AccountingPeriodPage: Page "Accounting Periods";
        AccountingPeriod: Record "Accounting Period";
        NoNepaliFiscalYearInfoQst: Label 'No Nepali Fiscal Year is provided in %1. Do you want to update it now?', Comment = '%1 = Company Information';
        NoNepaliFiscalYearInfoMsg: Label 'No Nepali Fiscal Year information is provided in %1. Review the report.';
        UpdateNepaliFiscalYearError: Label 'Please update Nepali Fiscal Year in %1. ';
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE("Starting Date", 0D, PostingDate);
        IF (AccountingPeriod.FINDLAST) AND (AccountingPeriod."Nepali Fiscal Year" <> '') THEN
            EXIT;
        ERROR(UpdateNepaliFiscalYearError, AccountingPeriod.TABLECAPTION);
        IF NOT (AccountingPeriod.FINDLAST) AND (AccountingPeriod."Nepali Fiscal Year" <> '') THEN
            MESSAGE(NoNepaliFiscalYearInfoMsg, AccountingPeriod.TABLECAPTION);
    end;


    [Scope('OnPrem')]
    procedure CheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        GLAccount: Record "G/L Account";
        PurchSetup: Record "Purchases & Payables Setup";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        IF (GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Purchase) THEN BEGIN
            PurchSetup.GET;
            IF PurchSetup."Ext. Doc. No. Mandatory" THEN
                GenJournalLine.TESTFIELD("External Document No.");
            GenJournalLine.TESTFIELD("Localized VAT Identifier");
        END;

        IF (GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Sale) THEN BEGIN
            SalesSetup.GET;
            IF SalesSetup."Ext. Doc. No. Mandatory" THEN
                GenJournalLine.TESTFIELD("External Document No.");
            GenJournalLine.TESTFIELD("Localized VAT Identifier");
        END;

        IF (GenJournalLine."VAT %" <> 0) OR (GenJournalLine."VAT Amount" <> 0) THEN
            GenJournalLine.TESTFIELD("VAT Registration No.");
    end;

    [Scope('OnPrem')]
    procedure CopyOnGLRegister(var GLRegister: Record "G/L Register"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLRegister."Creation Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure CopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry.Narration := GenJournalLine.Narration;
        GLEntry."Localized VAT Identifier" := GenJournalLine."Localized VAT Identifier";
        GLEntry.PragyapanPatra := GenJournalLine.PragyapanPatra;
        GLEntry."Purchase Consignment No." := GenJournalLine."Purchase Consignment No.";
    end;

    [Scope('OnPrem')]
    procedure CopyVATEntryFromGenJnlLine(var Sender: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        Sender.PragyapanPatra := GenJournalLine.PragyapanPatra;
        Sender."Localized VAT Identifier" := GenJournalLine."Localized VAT Identifier";
        Sender."Purchase Consignment No." := GenJournalLine."Purchase Consignment No.";
        //KMT2016CU5 <<
        Sender."Free Item Vendor No." := GenJournalLine."Free Item Vendor No.";
        Sender."Free Item Vendor Name" := GenJournalLine."Free Item Vendor Name";
        //KMT2016CU5 <<
    end;

    [Scope('OnPrem')]
    procedure CopyItemLedgEntryFromItemJnlLine(var ItemLedgerEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemLedgerEntry.PragyapanPatra := ItemJournalLine.PragyapanPatra;
        ItemLedgerEntry."Purchase Consignment No." := ItemJournalLine."Purchase Consignment No.";
        ItemLedgerEntry.MODIFY;
    end;

    [Scope('OnPrem')]
    procedure CopyItemJnlLineFromPurchHeader(var ItemJournalLine: Record "Item Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        ItemJournalLine."Purchase Consignment No." := PurchHeader."Purchase Consignment No.";
    end;

    [Scope('OnPrem')]
    procedure CopyValueEntryFromItemJnlLine(var ValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        PurchRcptLine: Record "Purchase Prepayment %";
    begin
        ValueEntry."Purchase Consignment No." := ItemJournalLine."Purchase Consignment No.";
        ValueEntry."Letter of Credit/Telex Trans." := ItemJournalLine."Letter of Credit/Telex Trans.";  //KMT2016CU5
        ValueEntry.PragyapanPatra := ItemJournalLine.PragyapanPatra;   //KMT2016CU5
    end;

    [Scope('OnPrem')]
    procedure CopyGenJnlLineFromPurchHeader(var GenJournalLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header")
    begin
        GenJournalLine."Purchase Consignment No." := PurchHeader."Purchase Consignment No.";
        //KMT2016CU5 <<
        GenJournalLine."Free Item Vendor No." := PurchHeader."Free Item Vendor No.";
        GenJournalLine."Free Item Vendor Name" := PurchHeader."Free Item Vendor Name";
        //KMT2016CU5 <<
    end;

    [Scope('OnPrem')]
    procedure CopySalesInvHeaderToSalesLine(var FromSalesLine: Record "Sales Line"; SalesInvHeaderNo: Code[20]; SalesInvHeaderLineNo: Integer)
    begin
        FromSalesLine."Returned Document No." := SalesInvHeaderNo;
        FromSalesLine."Returned Document Line No." := SalesInvHeaderLineNo;
    end;

    [Scope('OnPrem')]
    procedure CopySalesShptHeaderToSalesLine(var FromSalesLine: Record "Sales Line"; SalesShptHeaderNo: Code[20])
    begin
        //FromSalesLine."Returned Document No." := SalesShptHeaderNo;
    end;

    [Scope('OnPrem')]
    procedure CopySalesReturnRcptHeaderToSalesLine(var FromSalesLine: Record "Sales Line"; ReturnRcptHeaderNo: Code[20])
    begin
        //FromSalesLine."Returned Document No." := ReturnRcptHeaderNo;
    end;

    [Scope('OnPrem')]
    procedure CopySalesCrMemoHeaderToSalesLine(var FromSalesLine: Record "Sales Line"; SalesCrMemoHeaderNo: Code[20])
    begin
        //FromSalesLine."Returned Document No." := SalesCrMemoHeaderNo;
    end;

    [Scope('OnPrem')]
    procedure CopyGenJnlLineFromInvPostBufferSales(var GenJournalLine: Record "Gen. Journal Line"; var InvoicePostBuffer: array[2] of Record "Invoice Post. Buffer")
    begin
        GenJournalLine.PragyapanPatra := InvoicePostBuffer[1].PragyapanPatra;
        GenJournalLine."Localized VAT Identifier" := InvoicePostBuffer[1]."Localized VAT Identifier";
        //KMT2016CU5 >>
        GenJournalLine."Free Item Vendor No." := InvoicePostBuffer[1]."Free Item Vendor No.";
        GenJournalLine."Free Item Vendor Name" := InvoicePostBuffer[1]."Free Item Vendor Name";
        //KMT2016CU5 <<
    end;

    [Scope('OnPrem')]
    procedure CopyGenJnlLineFromPrepInvPostBufferSales(var GenJournalLine: Record "Gen. Journal Line"; PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    begin
        GenJournalLine."Localized VAT Identifier" := PrepaymentInvLineBuffer."Localized VAT Identifier"::Prepayments; //IME
    end;

    [Scope('OnPrem')]
    procedure CopyGenJnlLineFromInvPostBufferService(var GenJournalLine: Record "Gen. Journal Line"; var InvoicePostBuffer: array[2] of Record "Invoice Post. Buffer")
    begin
        GenJournalLine.PragyapanPatra := InvoicePostBuffer[1].PragyapanPatra;
        GenJournalLine."Localized VAT Identifier" := InvoicePostBuffer[1]."Localized VAT Identifier";
        //KMT2016CU5 >>
        GenJournalLine."Free Item Vendor No." := InvoicePostBuffer[1]."Free Item Vendor No.";
        GenJournalLine."Free Item Vendor Name" := InvoicePostBuffer[1]."Free Item Vendor Name";
        //KMT2016CU5 <<
    end;

    [Scope('OnPrem')]
    procedure CopyGenJnlLineFromInvPostBufferPurchase(var GenJournalLine: Record "Gen. Journal Line"; var InvoicePostBuffer: array[2] of Record "Invoice Post. Buffer"; PurchHeader: Record "Purchase Header")
    begin
        GenJournalLine.PragyapanPatra := InvoicePostBuffer[1].PragyapanPatra;
        GenJournalLine."Localized VAT Identifier" := InvoicePostBuffer[1]."Localized VAT Identifier";
        GenJournalLine."Purchase Consignment No." := PurchHeader."Purchase Consignment No.";
        //KMT2016CU5 >>
        GenJournalLine."Free Item Vendor No." := InvoicePostBuffer[1]."Free Item Vendor No.";
        GenJournalLine."Free Item Vendor Name" := InvoicePostBuffer[1]."Free Item Vendor Name";

        //KMT2016CU5 <<
    end;

    [Scope('OnPrem')]
    procedure CopySalesInvLineFromPrepInvPostBuffer(var SalesInvoiceLine: Record "Sales Invoice Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    begin
        SalesInvoiceLine."Localized VAT Identifier" := PrepaymentInvLineBuffer."Localized VAT Identifier"::Prepayments; //IME
    end;

    [Scope('OnPrem')]
    procedure CopySalesCrMemoLineFromPrepInvPostBuffer(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    begin
        SalesCrMemoLine."Localized VAT Identifier" := PrepaymentInvLineBuffer."Localized VAT Identifier"::Prepayments; //IME
    end;

    [Scope('OnPrem')]
    procedure GetCustomVATPostingSetupOnSalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN
            Rec."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure GetCustomVATPostingSetupOnPurchLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN
            Rec."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure GetCustomVATPostingSetupOnServiceLine(var Rec: Record "Service Line"; var xRec: Record "Service Line"; RunTrigger: Boolean)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN
            Rec."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure GetCustomVATPostingSetupOnF6ServiceLine(var Rec: Record "Service Line"; var xRec: Record "Service Line"; CurrFieldNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN
            Rec."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure GetCustomVATPostingSetupOnF90GenJnlLine(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN
            Rec."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure GetCustomVATPostingSetupOnF91GenJnlLine(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN
            Rec."Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure InitializeCompany()
    begin
        InitReportSelection;
        EnableChangeLog;
    end;

    [Scope('OnPrem')]
    procedure OnAfterCopyToSalesLineFromDocuments(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line")
    begin
        ToSalesLine."Returned Document No." := FromSalesLine."Returned Document No.";
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertSalesInvHeader(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    begin
        Rec."Posting Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertSalesCrMemoHeader(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    begin
        Rec."Posting Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertServiceInvHeader(var Rec: Record "Service Invoice Header"; RunTrigger: Boolean)
    begin
        Rec."Posting Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertServiceCrMemoHeader(var Rec: Record "Service Cr.Memo Header"; RunTrigger: Boolean)
    begin
        Rec."Posting Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertPurchInvHeader(var Rec: Record "Purch. Inv. Header"; RunTrigger: Boolean)
    begin
        Rec."Posting Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertPurchCrMemoHeader(var Rec: Record "Purch. Cr. Memo Hdr."; RunTrigger: Boolean)
    begin
        Rec."Posting Time" := TIME;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertSalesCrMemoLineOnPrepPosting(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    begin
        SalesCrMemoLine."Localized VAT Identifier" := PrepaymentInvLineBuffer."Localized VAT Identifier"::Prepayments;
    end;

    [Scope('OnPrem')]
    procedure OnBeforeInsertSalesInvLineOnPrepPosting(var SalesInvoiceLine: Record "Sales Invoice Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    begin
        SalesInvoiceLine."Localized VAT Identifier" := PrepaymentInvLineBuffer."Localized VAT Identifier"::Prepayments;
    end;

    [Scope('OnPrem')]
    procedure PrepareSalesFieldsOnInvPostBuffer(var Sender: Record "Invoice Post. Buffer"; SalesLine: Record "Sales Line")
    begin
        Sender."Localized VAT Identifier" := SalesLine."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure PrepareServiceFieldsOnInvPostBuffer(var Sender: Record "Invoice Post. Buffer"; ServiceLine: Record "Service Line")
    begin
        Sender."Localized VAT Identifier" := ServiceLine."Localized VAT Identifier";
    end;

    [Scope('OnPrem')]
    procedure PreparePurchaseFieldsOnInvPostBuffer(var Sender: Record "Invoice Post. Buffer"; PurchaseLine: Record "Purchase Line")
    begin
        Sender."Localized VAT Identifier" := PurchaseLine."Localized VAT Identifier";
        Sender.PragyapanPatra := PurchaseLine.PragyapanPatra;
        //KMT2016CU5 >>
        Sender."Free Item Vendor No." := PurchaseLine."Free Item Vendor No.";
        Sender."Free Item Vendor Name" := PurchaseLine."Free Item Vendor Name";
        //KMT2016CU5 <<
    end;

    [Scope('OnPrem')]
    procedure PrepareSalesFieldsOnPrepInvPostBuffer(var Sender: Record "Prepayment Inv. Line Buffer"; SalesLine: Record "Sales Line")
    begin
        Sender."Localized VAT Identifier" := SalesLine."Localized VAT Identifier"::"Exempt Sales";
    end;

    [Scope('OnPrem')]
    procedure LookUpVehicle(var Vehicle: Record "Serial No. Information"; SerialNo: Code[20]): Boolean
    var
        VehicleList: Page "Sales Invoice Print History";
    begin
        CLEAR(VehicleList);
        IF SerialNo <> '' THEN BEGIN
            Vehicle.RESET;
            Vehicle.SETCURRENTKEY("Serial No.");
            Vehicle.SETRANGE("Serial No.", SerialNo);
            IF Vehicle.FINDFIRST THEN
                VehicleList.SETRECORD(Vehicle);
        END;
        VehicleList.LOOKUPMODE(TRUE);
        IF VehicleList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            VehicleList.GETRECORD(Vehicle);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('OnPrem')]
    procedure LookUpModelVersion(var recItem: Record Item; No: Code[20]; MakeCode: Code[20]; ModelCode: Code[20]): Boolean
    var
        ModelVersions: Page "Sales Cr.Memo Materialize View";
        ModelVersionListPage: Page "Sales Cr.Memo Materialize View";
    begin
        CLEAR(ModelVersions);
        CLEAR(ModelVersionListPage);
        recItem.SETCURRENTKEY("Item Category Code");
        //recItem.SETRANGE("Item Type",recItem."Item Type"::"Model Version");
        IF MakeCode <> '' THEN
            recItem.SETRANGE("Item Category Code", MakeCode);
        IF ModelCode <> '' THEN
            // recItem.SETRANGE("Product Group Code", ModelCode);
            IF No <> '' THEN
                IF recItem.GET(No) THEN
                    ModelVersionListPage.SETRECORD(recItem);


        ModelVersionListPage.SETTABLEVIEW(recItem);
        ModelVersionListPage.LOOKUPMODE(TRUE);
        IF ModelVersionListPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ModelVersionListPage.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('OnPrem')]
    procedure SalesLineLookUpModelVersion(var recItem: Record Item; No: Code[20]; MakeCode: Code[20]; ModelCode: Code[20]): Boolean
    var
        ModelVersions: Page "Sales Cr.Memo Materialize View";
        ModelVersionListPage: Page "Sales Cr.Memo Materialize View";
    begin
        CLEAR(ModelVersions);
        CLEAR(ModelVersionListPage);
        recItem.SETCURRENTKEY("Item Category Code");
        //recItem.SETRANGE("Item Type",recItem."Item Type"::"Model Version");
        recItem.SETFILTER(Inventory, '>%1', 0);
        IF MakeCode <> '' THEN
            recItem.SETRANGE("Item Category Code", MakeCode);
        IF ModelCode <> '' THEN
            //recItem.SETRANGE("Product Group Code", ModelCode);
        IF No <> '' THEN
                IF recItem.GET(No) THEN
                    ModelVersionListPage.SETRECORD(recItem);


        ModelVersionListPage.SETTABLEVIEW(recItem);
        ModelVersionListPage.LOOKUPMODE(TRUE);
        IF ModelVersionListPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ModelVersionListPage.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('OnPrem')]
    procedure CreateVehicle(ItemNo: Code[20]; SerialNo: Code[20]; VariantCode: Code[10])
    var
        ServiceItem: Record "Service Item";
        Item: Record Item;
        VINErr: Label 'VIN %1 has wrong information. Please contact your Vendor and verify Make, Model and Model Version of VIN %1.';
    begin
        ServiceItem.RESET;
        ServiceItem.SETRANGE("Item No.", ItemNo);
        ServiceItem.SETRANGE("Variant Code", VariantCode);
        ServiceItem.SETRANGE("Serial No.", SerialNo);
        IF NOT ServiceItem.FINDFIRST THEN BEGIN
            CLEAR(ServiceItem);
            ServiceItem.INIT;
            ServiceItem.VALIDATE("Serial No.", SerialNo);
            //ServiceItem.VALIDATE("VC No.",VariantCode);
            ServiceItem.VALIDATE("Item No.", ItemNo);
            //ServiceItem.VIN := ServiceItem."Serial No.";
            ServiceItem.INSERT(TRUE);
            IF Item.GET(ItemNo) THEN BEGIN
                ServiceItem.VALIDATE("Serial No.", SerialNo);
                // ServiceItem.VALIDATE("Make Code", Item."Item Category Code");
                // ServiceItem.VALIDATE("Model Code", Item."Product Group Code");
                // ServiceItem."Model Commercial Name" := Item.Description;
                ServiceItem.MODIFY(TRUE);
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure CheckCustomerCreditLimit(SalesHeader: Record "Sales Header")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustCrLimitDetail: Record "Customer Credit Limit Detail";
        Cust: Record Customer;
        DueDays: Integer;
        PaymentTerms: Record "Payment Terms";
    begin
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"] THEN
            EXIT;

        Cust.GET(SalesHeader."Bill-to Customer No.");
        Cust.CALCFIELDS("Balance (LCY)");
        SalesHeader.CALCFIELDS("Amount Including VAT");
        CustCrLimitDetail.RESET;
        CustCrLimitDetail.SETRANGE("Customer No.", SalesHeader."Bill-to Customer No.");
        CustCrLimitDetail.SETRANGE("Global Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");  //product segment code
        CustCrLimitDetail.SETRANGE("Skip Credit Limit Control", FALSE);
        IF CustCrLimitDetail.FINDFIRST THEN BEGIN
            IF FORMAT(CustCrLimitDetail."Payment Terms Code") <> '' THEN BEGIN
                CustLedgEntry.RESET;
                CustLedgEntry.SETCURRENTKEY(Open, "Due Date");
                CustLedgEntry.SETRANGE("Customer No.", SalesHeader."Bill-to Customer No.");
                CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
                CustLedgEntry.SETRANGE("Global Dimension 1 Code", CustCrLimitDetail."Global Dimension 1 Code");
                CustLedgEntry.SETRANGE(Open, TRUE);
                IF CustLedgEntry.FINDFIRST THEN BEGIN
                    PaymentTerms.GET(CustCrLimitDetail."Payment Terms Code");
                    DueDays := CALCDATE(PaymentTerms."Due Date Calculation", TODAY) - TODAY;
                    IF (TODAY - CustLedgEntry."Due Date") > DueDays THEN
                        ERROR('Credit Limit Exceeded for customer %1 by due date %2 in invoice %3.', Cust.Name, CustLedgEntry."Posting Date", CustLedgEntry."Document No.");
                END;
            END;
            IF CustCrLimitDetail."Credit Limit (LCY)" <> 0 THEN BEGIN
                IF (Cust."Balance Due (LCY)" + SalesHeader."Amount Including VAT") > CustCrLimitDetail."Credit Limit (LCY)" THEN
                    ERROR('Credit Limit Exceeded for customer %1 by amount %2.', Cust.Name, ((Cust."Balance Due (LCY)" + SalesHeader."Amount Including VAT") - CustCrLimitDetail."Credit Limit (LCY)"));
            END;
        END;
    end;

    [Scope('OnPrem')]
    procedure SendProductWiseReportMailToSalesperson()
    var
        CustProductWiseSalesPerson: Record "Product&Salesperson Posting Gr";
        SalesPerson: Record "Salesperson/Purchaser";
        ProductWiseReportSetup: Record "Tax Area Line";
        SalesPersonEmail: Text;
        ProductSegmentFilter: Text;
        DimensionValue: Record "Dimension Value";
        SMTPMail: Codeunit "SMTP Mail";
        SMTPMailSetup: Record "SMTP Mail Setup";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        VariantRef: Variant;
        GLSetup: Record "General Ledger Setup";
        ReportMettadata: Record "Report Metadata";
        FileNameTxt: Text;
        ProgressWindow: Dialog;
        ProcessingRecords: Integer;
        ProgressingTxt: Label 'Total Salesperson : #1##########\Processing : #2###########\Generating Report #3###########\Mail Sent Count #4##############';
        GeneratedReportCount: Integer;
        DateFilterFieldRef: FieldRef;
        FileDirectory: Text;
        FileMgt: Codeunit "File Management";
        AttachmentExists: Boolean;
        MailSentCount: Integer;
        ProductWiseReportSetup1: Record "Tax Area Line";
    begin
        GLSetup.GET;
        SMTPMailSetup.GET;
        SalesPerson.RESET;
        SalesPerson.SETFILTER("E-Mail", '<>%1', '');
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(ProgressingTxt);
            ProgressWindow.UPDATE(1, SalesPerson.COUNT);
        END;
        IF SalesPerson.FINDFIRST THEN
            REPEAT
                CLEAR(SMTPMail);
                SalesPersonEmail := SalesPerson."E-Mail";
                // SMTPMail.CreateMessage(COMPANYNAME,
                //                        SMTPMailSetup."User ID",
                //                        SalesPersonEmail,
                //                        STRSUBSTNO('Salesperson Reports for %1 to %2',
                //                        CALCDATE('<-CM>'), TODAY),
                //                        '',
                //                        FALSE);
                IF NOT JobQueueActive THEN BEGIN
                    ProcessingRecords += 1;
                    ProgressWindow.UPDATE(2, ProcessingRecords);
                END;
                CustProductWiseSalesPerson.RESET;
                CustProductWiseSalesPerson.SETRANGE("Area Code", SalesPerson.Code);
                IF CustProductWiseSalesPerson.FINDFIRST THEN
                    REPEAT
                        IF STRPOS(ProductSegmentFilter, CustProductWiseSalesPerson."Product Segment Code") = 0 THEN
                            IF ProductSegmentFilter <> '' THEN
                                ProductSegmentFilter += '|' + CustProductWiseSalesPerson."Product Segment Code"
                            ELSE
                                ProductSegmentFilter := CustProductWiseSalesPerson."Product Segment Code";
                    UNTIL CustProductWiseSalesPerson.NEXT = 0;

                IF ProductSegmentFilter <> '' THEN BEGIN
                    ProductWiseReportSetup.RESET;
                    ProductWiseReportSetup.SETFILTER("Product Segment Code", ProductSegmentFilter);
                    IF ProductWiseReportSetup.FINDFIRST THEN
                        REPEAT
                            ReportMettadata.GET(ProductWiseReportSetup."Report ID");
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 1 Code");
                            DimensionValue.SETFILTER(Code, ProductSegmentFilter);
                            IF DimensionValue.FINDFIRST THEN
                                REPEAT
                                    CLEAR(RecRef);
                                    ReportMettadata.GET(ProductWiseReportSetup."Report ID");
                                    RecRef.OPEN(ReportMettadata.FirstDataItemTableID);
                                    //FieldRef := RecRef.FIELD(GetFieldNo(ReportMettadata.FirstDataItemTableID, 'Global Dimension 1 Code|Shortcut Dimension 1 Code'));// ERoRR doesnt exit in current conext
                                    FieldRef.SETRANGE(DimensionValue.Code);
                                    // DateFilterFieldRef := RecRef.FIELD(GetFieldNo(ReportMettadata.FirstDataItemTableID, 'Posting Date|Date Filter'));//ERoRR doesnt exit in current conext
                                    DateFilterFieldRef.SETRANGE(CALCDATE('<-CM>'), TODAY);
                                    VariantRef := RecRef;
                                    IF RecRef.FINDFIRST THEN BEGIN
                                        FileNameTxt := ReportMettadata.Caption + '-' + SalesPerson.Name + '-' + DimensionValue.Code + '-' + '.pdf';
                                        FileDirectory := FileMgt.ServerTempFileName('pdf');
                                        REPORT.SAVEASPDF(ProductWiseReportSetup."Report ID", FileDirectory, VariantRef);
                                        GeneratedReportCount += 1;
                                        SMTPMail.AddAttachment(FileDirectory, FileNameTxt);
                                        AttachmentExists := TRUE;
                                    END;
                                    IF NOT JobQueueActive THEN
                                        ProgressWindow.UPDATE(3, GeneratedReportCount);
                                UNTIL DimensionValue.NEXT = 0;
                        UNTIL ProductWiseReportSetup.NEXT = 0;
                END;
            // IF AttachmentExists THEN BEGIN
            //     IF SMTPMail.TrySend THEN BEGIN //defination doesnt exist
            //         IF NOT JobQueueActive THEN BEGIN
            //             MailSentCount += 1;
            //             ProgressWindow.UPDATE(4, MailSentCount);
            //         END;
            //     END;
            // END;
            UNTIL SalesPerson.NEXT = 0;
    end;

    // local procedure GetFieldNo(TableNo: Integer; _Fieldname: Text): Integer
    // var
    //     FieldTable: Record "2000000041";
    // begin
    //     FieldTable.SETRANGE(TableNo, TableNo);
    //     FieldTable.SETFILTER(FieldName, _Fieldname);
    //     IF FieldTable.FINDFIRST THEN
    //         EXIT(FieldTable."No.");
    // end;

    [Scope('OnPrem')]
    procedure CreateTransferFromSalesCreditMemo(SalesCrMemoHdr: Record "Sales Cr.Memo Header")
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        SalesSetup: Record "Sales & Receivables Setup";
        TransShtpHdr: Record "Transfer Shipment Header";
        Text1000: Label 'Items have already been shipped from %1 to %2 for credit memo %3.';
        SourceDocNo: Code[20];
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferOrder: Page "Transfer Order";
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Restrict Invoicing from Damage" THEN
            EXIT;

        SourceDocNo := SalesCrMemoHdr."No.";
        SalesSetup.TESTFIELD("Default Transfer-from Code");
        SalesSetup.TESTFIELD("Default Transfer-to Code");

        TransShtpHdr.RESET;
        TransShtpHdr.SETRANGE("Source Document No.", SourceDocNo);
        IF TransShtpHdr.FINDFIRST THEN
            ERROR(Text1000, TransShtpHdr."Transfer-from Code", TransShtpHdr."Transfer-to Code", SourceDocNo);

        TransferHeader.RESET;
        TransferHeader.SETRANGE("Source Document No.", SourceDocNo);
        IF NOT TransferHeader.FINDFIRST THEN BEGIN
            TransferHeader.INIT;
            TransferHeader."Source Document No." := SourceDocNo;
            TransferHeader.INSERT(TRUE);
            TransferHeader.VALIDATE("Transfer-from Code", SalesSetup."Default Transfer-from Code");
            TransferHeader.VALIDATE("Transfer-to Code", SalesSetup."Default Transfer-to Code");
            TransferHeader.VALIDATE("Shortcut Dimension 1 Code", SalesCrMemoHdr."Shortcut Dimension 1 Code");
            TransferHeader.VALIDATE("Shortcut Dimension 2 Code", SalesCrMemoHdr."Shortcut Dimension 2 Code");
            TransferHeader.MODIFY(TRUE);

            SalesCrMemoLine.RESET;
            SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHdr."No.");
            SalesCrMemoLine.SETRANGE(Type, SalesCrMemoLine.Type::Item);
            IF SalesCrMemoLine.FINDFIRST THEN
                REPEAT
                    CLEAR(TransferLine);
                    TransferLine.INIT;
                    TransferLine."Document No." := TransferHeader."No.";
                    TransferLine."Line No." := SalesCrMemoLine."Line No.";
                    TransferLine.VALIDATE("Item No.", SalesCrMemoLine."No.");
                    TransferLine.VALIDATE(Quantity, SalesCrMemoLine.Quantity);
                    TransferLine."Source Document No." := SalesCrMemoHdr."No.";
                    TransferLine."Source Document Line No." := SalesCrMemoLine."Line No.";
                    TransferLine.INSERT(TRUE);
                UNTIL SalesCrMemoLine.NEXT = 0;
        END;
        CLEAR(TransferOrder);
        TransferOrder.SETRECORD(TransferHeader);
        TransferOrder.SETTABLEVIEW(TransferHeader);
        TransferOrder.RUN;
    end;

    [Scope('OnPrem')]
    procedure CreateSalesLineBasedOnTransferReceiptNo(SalesHeader: Record "Sales Header"; TransRcptNo: Code[20])
    var
        TransRcptHeader: Record "Transfer Receipt Header";
        TransRcptLine: Record "Transfer Receipt Line";
        SalesLine: Record "Sales Line";
        ReceiptSalesHeader: Record "Sales Header";
        ErrMsgTxt: Label 'Transfer Receipt No. %1 have already been selected in Sales Order %2.';
    begin
        SalesHeader.TESTFIELD("Inventory Posting Group");


        IF TransRcptNo <> '' THEN BEGIN
            ReceiptSalesHeader.RESET;
            ReceiptSalesHeader.SETRANGE("Document Type", SalesHeader."Document Type");
            ReceiptSalesHeader.SETRANGE("Transfer Receipt No.", TransRcptNo);
            ReceiptSalesHeader.SETFILTER("No.", '<>%1', SalesHeader."No.");
            IF ReceiptSalesHeader.FINDFIRST THEN
                ERROR(ErrMsgTxt, TransRcptNo, ReceiptSalesHeader."No.");
        END;
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.DELETEALL;

        IF TransRcptNo = '' THEN
            EXIT;

        TransRcptHeader.GET(TransRcptNo);
        TransRcptLine.SETRANGE("Document No.", TransRcptHeader."No.");
        IF TransRcptLine.FINDFIRST THEN
            REPEAT
                CLEAR(SalesLine);
                SalesLine.INIT;
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := TransRcptLine."Line No.";
                SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                SalesLine.VALIDATE("No.", TransRcptLine."Item No.");
                SalesLine.VALIDATE(Quantity, TransRcptLine.Quantity);
                SalesLine.INSERT(TRUE);
            UNTIL TransRcptLine.NEXT = 0;
    end;

    [Scope('OnPrem')]
    procedure JobQueueActive(): Boolean
    begin
        EXIT(NOT GUIALLOWED);
    end;

    [Scope('OnPrem')]
    procedure SendProductWiseReportMailToConcernedPersons()
    var
        CustProductWiseSalesPerson: Record "Product&Salesperson Posting Gr";
        SalesPerson: Record "Salesperson/Purchaser";
        ProductWiseReportSetup: Record "Tax Area Line";
        ProductWiseConcerns: Record "Tax Detail";
        SalesPersonEmail: Text;
        ReportIDFilter: Text;
        DimensionValue: Record "Dimension Value";
        SMTPMail: Codeunit "SMTP Mail";
        SMTPMailSetup: Record "SMTP Mail Setup";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        VariantRef: Variant;
        GLSetup: Record "General Ledger Setup";
        ReportMettadata: Record "Report Metadata";
        FileNameTxt: Text;
        ProgressWindow: Dialog;
        ProcessingRecords: Integer;
        ProgressingTxt: Label 'Total Product Segments : #1##########\Product Segment : #2######\Processing Concern Emails : #3###########\Generating Report #4###########\Mail Sent Count #5##############';
        GeneratedReportCount: Integer;
        DateFilterFieldRef: FieldRef;
        FileDirectory: Text;
        FileMgt: Codeunit "File Management";
        AttachmentExists: Boolean;
        MailSentCount: Integer;
        SubjectTxt: Label 'Salesperson Reports for %1 to %2.';
        CompanyInfo: Record "Company Information";
        DearSir_Madam: Label 'Dear Sir/Ma''m,';
        BodyText: Label 'Please find the attached file for reports.';
        SingleLineBreak: Label '<br>';
        DoubleLineBreak: Label '<br><br>';
        RegardsTxt: Label 'Regards,';
        EmailIds: Text;
    begin
        SMTPMailSetup.GET;
        CompanyInfo.GET;
        GLSetup.GET;
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 1 Code");
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(ProgressingTxt);
            ProgressWindow.UPDATE(1, DimensionValue.COUNT);
        END;
        IF DimensionValue.FINDFIRST THEN
            REPEAT
                IF NOT JobQueueActive THEN
                    ProgressWindow.UPDATE(2, DimensionValue.Code);

                IF NOT JobQueueActive THEN BEGIN
                    ProcessingRecords += 1;
                    ProgressWindow.UPDATE(3, ProcessingRecords);
                END;
                // MESSAGE('%1',ProductWiseConcerns."Report ID");
                /* IF ReportIDFilter <> '' THEN BEGIN
                   IF STRPOS(ReportIDFilter, FORMAT(ProductWiseConcerns."Report ID")) = 0 THEN
                     ReportIDFilter += '|' + FORMAT(ProductWiseConcerns."Report ID");
                 END ELSE*/
                //ReportIDFilter := FORMAT(ProductWiseConcerns."Report ID");

                //IF ReportIDFilter <> '' THEN BEGIN
                ProductWiseReportSetup.RESET;
                ProductWiseReportSetup.SETFILTER("Product Segment Code", DimensionValue.Code);
                //ProductWiseReportSetup.SETFILTER("Report ID",);
                IF ProductWiseReportSetup.FINDFIRST THEN
                    REPEAT
                        CLEAR(RecRef);
                        CLEAR(FieldRef);
                        CLEAR(DateFilterFieldRef);
                        CLEAR(VariantRef);
                        CLEAR(FileNameTxt);
                        CLEAR(FileDirectory);
                        CLEAR(SMTPMail);

                        CLEAR(EmailIds);
                        ProductWiseConcerns.RESET;
                        ProductWiseConcerns.SETRANGE("Product Segment Code", DimensionValue.Code);
                        ProductWiseConcerns.SETFILTER("Concerned Emails", '<>%1', '');
                        ProductWiseConcerns.SETRANGE("Report ID", ProductWiseReportSetup."Report ID");
                        IF ProductWiseConcerns.FINDFIRST THEN
                            REPEAT
                                IF EmailIds = '' THEN
                                    EmailIds := ProductWiseConcerns."Concerned Emails"
                                ELSE
                                    EmailIds += ';' + ProductWiseConcerns."Concerned Emails";

                            UNTIL ProductWiseConcerns.NEXT = 0;
                        // SMTPMail.CreateMessage(COMPANYNAME, SMTPMailSetup."User ID", EmailIds, //cannot convert text to list
                        //                STRSUBSTNO(SubjectTxt, CALCDATE('<-CM>'), TODAY),
                        //                '', TRUE);
                        SMTPMail.AppendBody(DearSir_Madam + DoubleLineBreak);
                        SMTPMail.AppendBody(BodyText + DoubleLineBreak);
                        SMTPMail.AppendBody(RegardsTxt + SingleLineBreak);
                        SMTPMail.AppendBody(CompanyInfo.Name);
                        ReportMettadata.GET(ProductWiseReportSetup."Report ID");
                        RecRef.OPEN(ReportMettadata.FirstDataItemTableID);
                        //FieldRef := RecRef.FIELD(GetFieldNo(ReportMettadata.FirstDataItemTableID, 'Global Dimension 1 Code|Shortcut Dimension 1 Code'));//ERoRR doesnt exit in current conext
                        IF (ProductWiseReportSetup."Report ID" = 50076) OR (ProductWiseReportSetup."Report ID" = 106) THEN //aakrista for updating the filter of the report id 50076 as Global dimension 2 filter
                            FieldRef := RecRef.FIELD(56);
                        FieldRef.SETRANGE(ProductWiseReportSetup."Product Segment Code");
                        // DateFilterFieldRef := RecRef.FIELD(GetFieldNo(ReportMettadata.FirstDataItemTableID, 'Posting Date|Date Filter'));//ERoRR doesnt exit in current conext
                        IF ProductWiseReportSetup."Report ID" = 106 THEN  //aakrista to skip posting date filter of report 106
                            DateFilterFieldRef.SETFILTER('..TODAY')
                        ELSE
                            DateFilterFieldRef.SETRANGE(CALCDATE('<-CM>'), TODAY);
                        VariantRef := RecRef;
                        CLEAR(FileDirectory);
                        IF RecRef.FINDFIRST THEN BEGIN
                            GeneratedReportCount += 1;
                            FileNameTxt := ReportMettadata.Caption + '-' + DimensionValue.Code + '-' + '.xlsx';
                            FileDirectory := 'C:\NAVTEMP\productsegement.xlsx';
                            REPORT.SAVEASEXCEL(ProductWiseReportSetup."Report ID", FileDirectory, VariantRef);
                            IF FILE.EXISTS(FileDirectory) THEN BEGIN
                                SMTPMail.AddAttachment(FileDirectory, FileNameTxt);
                                AttachmentExists := TRUE;
                            END;
                            IF NOT JobQueueActive THEN BEGIN
                                ProgressWindow.UPDATE(4, GeneratedReportCount);
                            END;
                        END;

                    //     IF AttachmentExists THEN BEGIN
                    //         IF EmailIds <> '' THEN
                    //             IF SMTPMail.TrySend THEN BEGIN
                    //                 IF NOT JobQueueActive THEN BEGIN
                    //                     MailSentCount += 1;
                    //                     ProgressWindow.UPDATE(5, MailSentCount);
                    //                 END;
                    //             END;
                    //         AttachmentExists := FALSE;//aakrista made false after mail sent..
                    //     END;
                    UNTIL ProductWiseReportSetup.NEXT = 0;

            UNTIL DimensionValue.NEXT = 0;

    end;

    [Scope('OnPrem')]
    procedure SendBillDeliveryMail(DeliveryDetails: Record "Tax Area")
    var
        SalesInvHeader: Record "Sales Invoice Header";
        Customer: Record Customer;
        CustomerEmail: Text;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        SalesPerson: Record "Salesperson/Purchaser";
        MessageText: Text;
        DearSir_Madam: Label 'Dear Sir/Ma''m,';
        TransportName: Label 'Transport Name';
        BillNo: Label 'Bill No';
        BiltyNo: Label 'Bilty No';
        BookingDate: Label 'Booking Date';
        COLON: Label ':';
        BodyText: Label 'Please find the below delivery details for bill.';
        SalesSetup: Record "Sales & Receivables Setup";
        SubjectText: Label 'Delivery Details for Bill No. - %1.';
        SingleLineBreak: Label '<br>';
        DoubleLineBreak: Label '<br><br>';
        RegardsTxt: Label 'Regards,';
        CompanyInfo: Record "Company Information";
        FileDirectory: Text;
        FileMgt: Codeunit "File Management";
        ReportSelection: Record "Report Selections";
        FileNameTxt: Text;
        PDFSalesInvHdr: Record "Sales Invoice Header";
    begin
        SalesSetup.GET;
        CompanyInfo.GET;
        DeliveryDetails.TESTFIELD("Transport Name");
        DeliveryDetails.TESTFIELD("Bilty No.");
        DeliveryDetails.TESTFIELD("Booking Date");
        CLEAR(SMTPMail);
        IF SalesInvHeader.GET(DeliveryDetails.Code) THEN BEGIN
            IF SalesInvHeader."No. Printed" = 0 THEN
                ERROR('Tax invoice must be printed to send delivery mail.');
            ReportSelection.RESET;
            ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"S.Invoice");
            ReportSelection.FINDFIRST;

            SMTPMailSetup.GET;
            Customer.GET(SalesInvHeader."Sell-to Customer No.");
            IF Customer."E-Mail" = '' THEN
                EXIT;
            CustomerEmail := Customer."E-Mail";
            // SMTPMail.CreateMessage(SalesSetup."Sender Name",
            //                        SMTPMailSetup."User ID",
            //                        CustomerEmail,//CANNOT CONVERT TEXT TO LIST
            //                        STRSUBSTNO(SubjectText, DeliveryDetails.Code),
            //                        '',
            //                        TRUE);
            IF SalesPerson.GET(SalesInvHeader."Salesperson Code") AND (SalesPerson."E-Mail" <> '') THEN
                // SMTPMail.AddCC(SalesPerson."E-Mail");//CANNOT COnVERT text to list
                SMTPMail.AppendBody(DearSir_Madam + DoubleLineBreak);
            SMTPMail.AppendBody(BodyText + DoubleLineBreak);
            SMTPMail.AppendBody(TransportName + COLON + ' ' + DeliveryDetails."Transport Name" + SingleLineBreak);
            SMTPMail.AppendBody(BillNo + COLON + ' ' + DeliveryDetails.Code + SingleLineBreak);
            SMTPMail.AppendBody(BiltyNo + COLON + ' ' + DeliveryDetails."Bilty No." + SingleLineBreak);
            SMTPMail.AppendBody(BookingDate + COLON + ' ' + FORMAT(DeliveryDetails."Booking Date") + DoubleLineBreak);
            SMTPMail.AppendBody(RegardsTxt + SingleLineBreak);
            SMTPMail.AppendBody(CompanyInfo.Name);
            FileNameTxt := ReplaceString(SalesInvHeader."No.", '/', '_') + '.xls';
            FileDirectory := FileMgt.ServerTempFileName('xls');
            PDFSalesInvHdr.RESET;
            PDFSalesInvHdr.SETRANGE("No.", SalesInvHeader."No.");
            IF PDFSalesInvHdr.FINDFIRST THEN BEGIN
                REPORT.SAVEASEXCEL(REPORT::"Sales Invoice KMT", FileDirectory, PDFSalesInvHdr);
                SMTPMail.AddAttachment(FileDirectory, FileNameTxt);
            END;
            // IF SMTPMail.TrySend THEN BEGIN // doesnt contain defination
            //     DeliveryDetails."Mail Sent" := TRUE;
            //     DeliveryDetails.Posted := TRUE;
            //     DeliveryDetails."Posted By" := USERID;
            //     DeliveryDetails."Posted Time" := TIME;
            //     DeliveryDetails.MODIFY;
            //     MESSAGE('Mail Sent successfully.');
            // END;
        END;
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
        EXIT(NewString);
    end;

    [Scope('OnPrem')]
    procedure CreateItemJnlAfterTransferReceive(TransferReceiptHeader: Record "Transfer Receipt Header"; CalledAfterTransferReceive: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ItemJournalLine: Record "Item Journal Line";
        InvSetup: Record "Inventory Setup";
        TransferReceiptLine: Record "Transfer Receipt Line";
        LastLineNo: Integer;
        DocumentNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        LineInserted: Boolean;
        ItemJournal: Page "Item Journal";
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Populate Damage Location" THEN
            EXIT;

        IF SalesSetup."Populate Damage Location" THEN BEGIN
            SalesSetup.TESTFIELD("Damage Location");
            SalesSetup.TESTFIELD("Default Item Jnl. Template");
            SalesSetup.TESTFIELD("Default Item Jnl. Batch");
        END;

        ItemJnlBatch.GET(SalesSetup."Default Item Jnl. Template", SalesSetup."Default Item Jnl. Batch");

        CLEAR(NoSeriesMgt);


        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", SalesSetup."Default Item Jnl. Template");
        ItemJournalLine.SETRANGE("Journal Batch Name", SalesSetup."Default Item Jnl. Batch");
        IF ItemJournalLine.FINDLAST THEN BEGIN
            LastLineNo := ItemJournalLine."Line No." + 10000;
            DocumentNo := INCSTR(ItemJournalLine."Document No.");
        END ELSE BEGIN
            LastLineNo := 10000;
            DocumentNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", TransferReceiptHeader."Posting Date", FALSE);
        END;

        TransferReceiptLine.RESET;
        TransferReceiptLine.SETRANGE("Document No.", TransferReceiptHeader."No.");
        TransferReceiptLine.SETFILTER("Item No.", '<>%1', '');
        IF TransferReceiptLine.FINDFIRST THEN
            REPEAT
                CLEAR(ItemJournalLine);
                ItemJournalLine.INIT;
                ItemJournalLine."Journal Template Name" := SalesSetup."Default Item Jnl. Template";
                ItemJournalLine."Journal Batch Name" := SalesSetup."Default Item Jnl. Batch";
                ItemJournalLine."Line No." := LastLineNo;
                ItemJournalLine."Document No." := DocumentNo;
                ItemJournalLine.VALIDATE("Posting Date", TransferReceiptHeader."Posting Date");
                ItemJournalLine.VALIDATE("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                ItemJournalLine.VALIDATE("Item No.", TransferReceiptLine."Item No.");
                ItemJournalLine.VALIDATE("Location Code", TransferReceiptLine."Transfer-to Code");
                ItemJournalLine.VALIDATE(Quantity, TransferReceiptLine.Quantity);
                ItemJournalLine.VALIDATE("Posting No. Series", ItemJnlBatch."Posting No. Series");
                ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", TransferReceiptLine."Shortcut Dimension 1 Code");
                ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code", TransferReceiptLine."Shortcut Dimension 2 Code");
                ItemJournalLine."Dimension Set ID" := TransferReceiptLine."Dimension Set ID";
                ItemJournalLine."Transfer Receipt No." := TransferReceiptHeader."No.";
                ItemJournalLine."Transfer Receipt Line No." := TransferReceiptLine."Line No.";
                ItemJournalLine.INSERT(TRUE);
                LastLineNo += 10000;
                LineInserted := TRUE;
            UNTIL TransferReceiptLine.NEXT = 0;

        IF LineInserted THEN BEGIN
            CLEAR(ItemJournal);
            ItemJournalLine.RESET;
            ItemJournalLine.SETRANGE("Journal Template Name", SalesSetup."Default Item Jnl. Template");
            ItemJournalLine.SETRANGE("Journal Batch Name", SalesSetup."Default Item Jnl. Batch");
            IF ItemJournalLine.FINDFIRST THEN BEGIN
                ItemJournal.SETRECORD(ItemJournalLine);
                ItemJournal.SETTABLEVIEW(ItemJournalLine);
                IF CalledAfterTransferReceive THEN
                    COMMIT;
                ItemJournal.RUNMODAL;
            END;
        END;
    end;
}

