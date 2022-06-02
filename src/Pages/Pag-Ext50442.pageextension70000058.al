pageextension 50442 "pageextension70000058" extends "Sales Invoice Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 25".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode3(Control 300)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode4(Control 302)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode5(Control 304)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode6(Control 306)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode7(Control 308)".


        //Unsupported feature: Property Modification (TableRelation) on "ShortcutDimCode8(Control 310)".


        //Unsupported feature: Code Modification on "Control 4.OnValidate".
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //KMT2016CU5 >>
                IF Rec.Type = Rec.Type::Item THEN
                    CompareVatProdPostingGr(Rec);
                //KMT2016CU5 <<
            end;
        }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 25".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 25".


        //Unsupported feature: Property Deletion (Visible) on "Control 25".

        addlast(content)
        {
            // field("Location Code"; "Location Code")
            // {
            // }
        }
        // moveafter("Control 6"; "Control 25")
        // moveafter("Control 106"; "Control 27")
    }


    //Unsupported feature: Property Modification (Id) on "TotalSalesHeader(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //TotalSalesHeader : 1014;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TotalSalesHeader : 1961;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TotalSalesLine(Variable 1013)".

    //var
    //>>>> ORIGINAL VALUE:
    //TotalSalesLine : 1013;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TotalSalesLine : 1962;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Currency(Variable 1024)".

    //var
    //>>>> ORIGINAL VALUE:
    //Currency : 1024;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Currency : 1963;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalesSetup(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesSetup : 1010;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesSetup : 1964;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TempOptionLookupBuffer(Variable 1018)".

    //var
    //>>>> ORIGINAL VALUE:
    //TempOptionLookupBuffer : 1018;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TempOptionLookupBuffer : 1965;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ApplicationAreaMgmtFacade(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApplicationAreaMgmtFacade : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApplicationAreaMgmtFacade : 1966;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TransferExtendedText(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //TransferExtendedText : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TransferExtendedText : 1967;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalesPriceCalcMgt(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesPriceCalcMgt : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesPriceCalcMgt : 1968;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ItemAvailFormsMgt(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //ItemAvailFormsMgt : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ItemAvailFormsMgt : 1969;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalesCalcDiscByType(Variable 1015)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesCalcDiscByType : 1015;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesCalcDiscByType : 1970;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DocumentTotals(Variable 1016)".

    //var
    //>>>> ORIGINAL VALUE:
    //DocumentTotals : 1016;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DocumentTotals : 1971;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "VATAmount(Variable 1017)".

    //var
    //>>>> ORIGINAL VALUE:
    //VATAmount : 1017;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //VATAmount : 1972;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InvoiceDiscountAmount(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvoiceDiscountAmount : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvoiceDiscountAmount : 1973;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InvoiceDiscountPct(Variable 1023)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvoiceDiscountPct : 1023;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvoiceDiscountPct : 1974;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AmountWithDiscountAllowed(Variable 1021)".

    //var
    //>>>> ORIGINAL VALUE:
    //AmountWithDiscountAllowed : 1021;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AmountWithDiscountAllowed : 1975;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ShortcutDimCode(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //ShortcutDimCode : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ShortcutDimCode : 1976;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UpdateAllowedVar(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //UpdateAllowedVar : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UpdateAllowedVar : 1977;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text000(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : 1978;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "LocationCodeVisible(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //LocationCodeVisible : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //LocationCodeVisible : 1979;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InvDiscAmountEditable(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //InvDiscAmountEditable : 1012;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InvDiscAmountEditable : 1980;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsCommentLine(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsCommentLine : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsCommentLine : 1981;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UnitofMeasureCodeIsChangeable(Variable 1011)".

    //var
    //>>>> ORIGINAL VALUE:
    //UnitofMeasureCodeIsChangeable : 1011;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UnitofMeasureCodeIsChangeable : 1982;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsFoundation(Variable 1020)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsFoundation : 1020;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsFoundation : 1983;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CurrPageIsEditable(Variable 1019)".

    //var
    //>>>> ORIGINAL VALUE:
    //CurrPageIsEditable : 1019;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CurrPageIsEditable : 1984;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ItemChargeStyleExpression(Variable 1022)".

    //var
    //>>>> ORIGINAL VALUE:
    //ItemChargeStyleExpression : 1022;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ItemChargeStyleExpression : 1985;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TypeAsText(Variable 1098)".

    //var
    //>>>> ORIGINAL VALUE:
    //TypeAsText : 1098;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TypeAsText : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible1(Variable 1032)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible1 : 1032;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible1 : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible2(Variable 1031)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible2 : 1031;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible2 : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible3(Variable 1030)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible3 : 1030;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible3 : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible4(Variable 1029)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible4 : 1029;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible4 : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible5(Variable 1028)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible5 : 1028;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible5 : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible6(Variable 1027)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible6 : 1027;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible6 : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible7(Variable 1026)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible7 : 1026;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible7 : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimVisible8(Variable 1025)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimVisible8 : 1025;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimVisible8 : 1994;
    //Variable type has not been exported.

    var
        Text002: Label 'You must insert the item having same Vat. Prod. Posting Group';

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item;   //KMT2016CU5
        UpdateTypeText;
    end;

    local procedure "<--Agile-->"()
    begin
    end;

    procedure CompareVatProdPostingGr(SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        Item.RESET;
        SalesLine.SETRANGE("Document Type", Rec."Document Type"::Order);
        SalesLine.SETRANGE("Document No.", SalesLine."Document No.");
        IF SalesLine.FIND('-') THEN BEGIN
            Item.SETRANGE("No.", Rec."No.");
            IF Item.FINDFIRST THEN BEGIN
                IF Item."VAT Prod. Posting Group" <> SalesLine."VAT Prod. Posting Group" THEN
                    ERROR(Text002);
            END;
        END;
    end;

    //Unsupported feature: Property Modification (Id) on "UpdateTypeText(PROCEDURE 18).RecRef(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "SetDimensionsVisibility(PROCEDURE 14).DimMgt(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "SetDefaultType(PROCEDURE 17).IsHandled(Variable 1000)".

}

