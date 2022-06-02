pageextension 50451 "pageextension70000070" extends "Purchase Order Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode3(Control 300)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode4(Control 302)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode5(Control 304)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode6(Control 306)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode7(Control 308)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode8(Control 310)".

        modify(AmountBeforeDiscount)
        {

            //Unsupported feature: Property Modification (Level) on "AmountBeforeDiscount(Control 45)".


            //Unsupported feature: Property Modification (SourceExpr) on "AmountBeforeDiscount(Control 45)".

            Editable = false;
            Visible = false;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //KMT2016CU5 >>
                IF (Rec.Type = Rec.Type::"G/L Account") AND (Rec."No." = '2262200') THEN
                    IsEditable := TRUE
                ELSE
                    IsEditable := FALSE;
                //Following code is commented because the purchase document came with both vat and non-vat items from the vendor
                // {IF Type = Type::Item THEN
                //             CompareVatProdPostingGr(Rec);}
                //KMT2016CU5 <<
            end;
        }



        //Unsupported feature: Property Deletion (Name) on "AmountBeforeDiscount(Control 45)".


        //Unsupported feature: Property Deletion (CaptionML) on "AmountBeforeDiscount(Control 45)".


        //Unsupported feature: Property Deletion (ToolTipML) on "AmountBeforeDiscount(Control 45)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "AmountBeforeDiscount(Control 45)".


        //Unsupported feature: Property Deletion (AutoFormatType) on "AmountBeforeDiscount(Control 45)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on "AmountBeforeDiscount(Control 45)".


        //Unsupported feature: Property Deletion (CaptionClass) on "AmountBeforeDiscount(Control 45)".

        addlast(content)
        {
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
            }
            field("VAT Base 1"; Rec."VAT Base 1")
            {
                Caption = 'Vat Base Amt 13%';
                Editable = IsEditable;
                Visible = true;

                trigger OnValidate()
                begin
                    //KMT2016CU5 >>
                    IF Rec.Type <> Rec.Type::"G/L Account" THEN
                        ERROR('%1 field is valid only for g/l account selected..', Rec.FIELDCAPTION("VAT Base 1"));
                    //KMT2016CU5 <<
                end;
            }
            field("Exempt Amount"; Rec."Exempt Amount")
            {
                Editable = IsEditable;
                Visible = true;

                trigger OnValidate()
                begin
                    //KMT2016CU5 >>
                    IF Rec.Type <> Rec.Type::"G/L Account" THEN
                        ERROR('%1 field is valid only for g/l account selected..', Rec.FIELDCAPTION("Exempt Amount"));
                    //KMT2016CU5 <<
                end;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                Editable = false;
                Visible = false;
            }
            field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
            {
                Editable = true;
                Visible = false;
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
            }
            field("TDS Group"; Rec."TDS Group")
            {
            }
            field("TDS%"; Rec."TDS%")
            {
            }
            field("TDS Type"; Rec."TDS Type")
            {
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
            }
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
            }
        }

        // moveafter("Control 44"; "Control 16")
        // moveafter("Control 16"; "Control 60")
        // moveafter("Control 52"; AmountBeforeDiscount)
    }


    //Unsupported feature: Property Modification (Id) on "TotalPurchaseHeader(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //TotalPurchaseHeader : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TotalPurchaseHeader : 1948;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TotalPurchaseLine(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //TotalPurchaseLine : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TotalPurchaseLine : 1949;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PurchaseHeader(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchaseHeader : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchaseHeader : 1950;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Currency(Variable 1022)".

    //var
    //>>>> ORIGINAL VALUE:
    //Currency : 1022;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Currency : 1951;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PurchasesPayablesSetup(Variable 1038)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchasesPayablesSetup : 1038;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchasesPayablesSetup : 1952;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TempOptionLookupBuffer(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //TempOptionLookupBuffer : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TempOptionLookupBuffer : 1953;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ApplicationAreaMgmtFacade(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApplicationAreaMgmtFacade : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApplicationAreaMgmtFacade : 1954;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TransferExtendedText(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //TransferExtendedText : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TransferExtendedText : 1955;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ItemAvailFormsMgt(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //ItemAvailFormsMgt : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ItemAvailFormsMgt : 1956;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text001(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text001 : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text001 : 1957;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PurchCalcDiscByType(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchCalcDiscByType : 1010;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchCalcDiscByType : 1958;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DocumentTotals(Variable 1017)".

    //var
    //>>>> ORIGINAL VALUE:
    //DocumentTotals : 1017;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DocumentTotals : 1959;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ShortcutDimCode(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //ShortcutDimCode : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ShortcutDimCode : 1960;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "VATAmount(Variable 1018)".

    //var
    //>>>> ORIGINAL VALUE:
    //VATAmount : 1018;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //VATAmount : 1961;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InvoiceDiscountAmount(Variable 1036)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvoiceDiscountAmount : 1036;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvoiceDiscountAmount : 1962;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InvoiceDiscountPct(Variable 1037)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvoiceDiscountPct : 1037;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvoiceDiscountPct : 1963;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AmountWithDiscountAllowed(Variable 1039)".

    //var
    //>>>> ORIGINAL VALUE:
    //AmountWithDiscountAllowed : 1039;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AmountWithDiscountAllowed : 1964;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TypeAsText(Variable 1020)".

    //var
    //>>>> ORIGINAL VALUE:
    //TypeAsText : 1020;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TypeAsText : 1965;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ItemChargeStyleExpression(Variable 1016)".

    //var
    //>>>> ORIGINAL VALUE:
    //ItemChargeStyleExpression : 1016;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ItemChargeStyleExpression : 1966;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InvDiscAmountEditable(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvDiscAmountEditable : 1012;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvDiscAmountEditable : 1967;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsCommentLine(Variable 1019)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsCommentLine : 1019;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsCommentLine : 1968;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsFoundation(Variable 1021)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsFoundation : 1021;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsFoundation : 1969;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UpdateInvDiscountQst(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //UpdateInvDiscountQst : 1014;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UpdateInvDiscountQst : 1970;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CurrPageIsEditable(Variable 1023)".

    //var
    //>>>> ORIGINAL VALUE:
    //CurrPageIsEditable : 1023;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CurrPageIsEditable : 1971;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible1(Variable 1034)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible1 : 1034;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible1 : 1972;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible2(Variable 1033)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible2 : 1033;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible2 : 1973;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible3(Variable 1032)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible3 : 1032;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible3 : 1974;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible4(Variable 1029)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible4 : 1029;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible4 : 1975;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible5(Variable 1027)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible5 : 1027;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible5 : 1976;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible6(Variable 1026)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible6 : 1026;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible6 : 1977;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible7(Variable 1025)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible7 : 1025;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible7 : 1978;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible8(Variable 1024)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible8 : 1024;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible8 : 1979;
    //Variable type has not been exported.

    var
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        TypeChosen: Boolean;
        TotalQty: Decimal;
        BalTotalQty: Decimal;
        Item: Record Item;
        Text002: Label 'You must insert the item having same Vat. Prod. Posting Group';
        PurchLine: Record "Purchase Line";
        IsEditable: Boolean;
        IsVisible: Boolean;


    //Unsupported feature: Code Modification on "OnNewRecord".
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;  //KMT2016CU5
        UpdateTypeText;
    end;


    local procedure "<--Agile-->"()
    begin
    end;

    procedure CompareVatProdPostingGr(PurchaseLine: Record "Purchase Line")
    begin
        Item.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type"::Order);
        PurchaseLine.SETRANGE("Document No.", PurchaseLine."Document No.");
        IF PurchaseLine.FIND('-') THEN BEGIN
            Item.SETRANGE("No.", Rec."No.");
            IF Item.FINDFIRST THEN BEGIN
                IF Item."VAT Prod. Posting Group" <> PurchaseLine."VAT Prod. Posting Group" THEN
                    ERROR(Text002);
            END;
        END;
    end;

    //Unsupported feature: Property Modification (Id) on "ValidateInvoiceDiscountAmount(PROCEDURE 30).ConfirmManagement(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "OpenSalesOrderForm(PROCEDURE 5).SalesHeader(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "OpenSalesOrderForm(PROCEDURE 5).SalesOrder(Variable 1001)".


    //Unsupported feature: Property Modification (Id) on "ShowTracking(PROCEDURE 10).TrackingForm(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "OpenSpecOrderSalesOrderForm(PROCEDURE 12).SalesHeader(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "OpenSpecOrderSalesOrderForm(PROCEDURE 12).SalesOrder(Variable 1001)".


    //Unsupported feature: Property Modification (Id) on "ShowDocumentLineTracking(PROCEDURE 24).DocumentLineTracking(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "UpdateTypeText(PROCEDURE 14).RecRef(Variable 1000)".

}

