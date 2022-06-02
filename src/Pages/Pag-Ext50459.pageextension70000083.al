pageextension 50459 "pageextension70000083" extends "Item Charge Assignment (Purch)"
{
    layout
    {
        // modify("Control 14")
        // {
        //     Visible = false;
        // }
        // modify("Control 18")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = all;
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = all;
            }
            // field("Amount to Assign"; "Amount to Assign")
            // {
            //     Editable = true;
            // }
            // field("Qty. Assigned"; "Qty. Assigned")
            // {
            //     ApplicationArea = ItemCharges;
            //     ToolTip = 'Specifies the number of units of the item charge will be the assigned to the document line.';
            // }
        }


    }
    actions
    {
        // modify(GetReceiptLines)
        // {
        //     PromotedIsBig = true;
        // }
        // modify(SuggestItemChargeAssignment)
        // {
        //     PromotedIsBig = true;
        // }
    }


    //Unsupported feature: Property Modification (Id) on "Text000(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : 1973;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PurchLine(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchLine : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchLine : 1974;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PurchLine2(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchLine2 : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchLine2 : 1975;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PurchRcptLine(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchRcptLine : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchRcptLine : 1976;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ReturnShptLine(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //ReturnShptLine : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ReturnShptLine : 1977;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TransferRcptLine(Variable 1019)".

    //var
    //>>>> ORIGINAL VALUE:
    //TransferRcptLine : 1019;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TransferRcptLine : 1978;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalesShptLine(Variable 1017)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesShptLine : 1017;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesShptLine : 1979;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ReturnRcptLine(Variable 1018)".

    //var
    //>>>> ORIGINAL VALUE:
    //ReturnRcptLine : 1018;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ReturnRcptLine : 1980;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AssignableQty(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //AssignableQty : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AssignableQty : 1981;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TotalQtyToAssign(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //TotalQtyToAssign : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TotalQtyToAssign : 1982;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "RemQtyToAssign(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //RemQtyToAssign : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //RemQtyToAssign : 1983;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "AssgntAmount(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //AssgntAmount : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AssgntAmount : 1984;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "TotalAmountToAssign(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //TotalAmountToAssign : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TotalAmountToAssign : 1985;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "RemAmountToAssign(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //RemAmountToAssign : 1010;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //RemAmountToAssign : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "QtyToReceiveBase(Variable 1011)".

    //var
    //>>>> ORIGINAL VALUE:
    //QtyToReceiveBase : 1011;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //QtyToReceiveBase : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "QtyReceivedBase(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //QtyReceivedBase : 1012;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //QtyReceivedBase : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "QtyToShipBase(Variable 1013)".

    //var
    //>>>> ORIGINAL VALUE:
    //QtyToShipBase : 1013;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //QtyToShipBase : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "QtyShippedBase(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //QtyShippedBase : 1014;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //QtyShippedBase : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DataCaption(Variable 1016)".

    //var
    //>>>> ORIGINAL VALUE:
    //DataCaption : 1016;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DataCaption : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text001(Variable 1020)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text001 : 1020;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text001 : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GrossWeight(Variable 1021)".

    //var
    //>>>> ORIGINAL VALUE:
    //GrossWeight : 1021;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GrossWeight : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UnitVolume(Variable 1015)".

    //var
    //>>>> ORIGINAL VALUE:
    //UnitVolume : 1015;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UnitVolume : 1994;
    //Variable type has not been exported.

    var
        ItemLedgentry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        RcptLinePragyapan: Code[100];
        RcptLineLC: Code[100];
        PurchRcptLine1: Record "Purch. Rcpt. Line";

}

