tableextension 50469 "Transfer Line_ktm" extends "Transfer Line"
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item WHERE(Type = CONST(Inventory), Blocked = CONST(false));
            trigger OnAfterValidate()
            begin
                SalesSetup.GET;
                IF NOT SalesSetup."Skip Product Group Check" THEN BEGIN
                    GetTransHeader_ktm;
                    IF Item.GET("Item No.") THEN BEGIN
                        TransHeader.TESTFIELD("Shortcut Dimension 1 Code");
                        IF Item."Global Dimension 1 Code" <> TransHeader."Shortcut Dimension 1 Code" THEN
                            ERROR('Item %1 (%2) and transfer header does not have same product segment %3', Item."No.", Item.Description, TransHeader."Shortcut Dimension 1 Code");
                    END;
                END;
            end;
        }
        modify(Description)
        {
            TableRelation = Item WHERE(Type = CONST(Inventory), Blocked = CONST(false));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity Inbnd."(Field 50)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity Outbnd."(Field 51)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. Inbnd. (Base)"(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. Outbnd. (Base)"(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity Shipped"(Field 55)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. Shipped (Base)"(Field 56)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Inbnd. Otsdg. Qty (Base)"(Field 5750)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse Outbnd. Otsdg. Qty (Base)"(Field 5751)".

        modify("Transfer-from Bin Code")
        {
            TableRelation = "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Transfer-from Code"), "Item No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"));
        }


        field(50000; "Source Document No."; Code[20])
        {
        }
        field(50001; "Source Document Line No."; Integer)
        {
        }
    }


    //Unsupported feature: Property Modification (Id) on ""Item No."(Field 3).OnValidate.ReturnValue(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //"Item No." : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //"Item No." : 1998;
    //Variable type has not been exported.
    procedure GetTransHeader_ktm()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeGetTransHeader(Rec, TransHeader, IsHandled);
        if IsHandled then
            exit;

        //GetTransferHeaderNoVerification;

        //CheckTransferHeader(TransHeader);

        "In-Transit Code" := TransHeader."In-Transit Code";
        "Transfer-from Code" := TransHeader."Transfer-from Code";
        "Transfer-to Code" := TransHeader."Transfer-to Code";
        "Shipment Date" := TransHeader."Shipment Date";
        "Receipt Date" := TransHeader."Receipt Date";
        "Shipping Agent Code" := TransHeader."Shipping Agent Code";
        "Shipping Agent Service Code" := TransHeader."Shipping Agent Service Code";
        "Shipping Time" := TransHeader."Shipping Time";
        "Outbound Whse. Handling Time" := TransHeader."Outbound Whse. Handling Time";
        "Inbound Whse. Handling Time" := TransHeader."Inbound Whse. Handling Time";
        Status := TransHeader.Status;
        "Direct Transfer" := TransHeader."Direct Transfer";

        //OnAfterGetTransHeader(Rec, TransHeader);
    end;


    var
        "--ASPL--": Integer;
        SalesSetup: Record "Sales & Receivables Setup";
        item: Record Item;
        TransHeader: Record "Transfer Header";
}

