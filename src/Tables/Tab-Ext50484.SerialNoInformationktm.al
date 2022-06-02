tableextension 50484 "Serial No. Information_ktm" extends "Serial No. Information"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on "Inventory(Field 20)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expired Inventory"(Field 24)".

        field(50000; VIN; Code[20])
        {
            Editable = true;

            trigger OnValidate()
            var
                SerialRec: Record "Serial No. Information";
            begin
                SerialRec.RESET;
                SerialRec.SETRANGE(VIN, VIN);
                SerialRec.SETFILTER("Serial No.", '<>%1', "Serial No.");
                IF SerialRec.FINDFIRST THEN
                    ERROR('Selected VIN already exist in %1', SerialRec."Serial No.");
            end;
        }
        field(50001; "Make Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                /*IF LedgerFound THEN
                  ERROR(Text50000,"Serial No.");*/

            end;
        }
        field(50002; "Model Code"; Code[20])
        {
            Editable = false;
            // TableRelation = item."Product Group".Code WHERE("Item Category Code" = FIELD("Make Code"));

            trigger OnValidate()
            begin
                /*IF LedgerFound THEN
                  ERROR(Text50000,"Serial No.");*/

            end;
        }
        field(50003; "Model Commercial Name"; Text[50])
        {
        }
        field(50005; "Registration No."; Code[20])
        {
            Caption = 'Registration No.';
        }
        field(50009; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(50018; "Engine No."; Code[30])
        {
        }
        field(50019; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50020; "Body Color"; Text[30])
        {
        }
    }


    //Unsupported feature: Code Insertion on "OnInsert".

    trigger OnInsert()
    begin
        //KMT2017CU5 >>
        Item.RESET;
        //Item.SETCURRENTKEY("Item Type", "Item Category Code");     //this two line were commented in Ktm marketing
        //Item.SETRANGE("Item Type", Item."Item Type"::"Model Version");
        Item.SETRANGE("No.", "Item No.");
        IF Item.FINDFIRST THEN BEGIN
            "Make Code" := Item."Item Category Code";
            //"Model Code" := Item."Product Group Code"; //product group become frist level of children
        END;
        //KMT2017CU5 <<
    end;

    local procedure "-----GAT.15.07"()
    begin
    end;

    procedure ValidateModelVersion()
    begin
        //GAT.15.07 >>
        Item.RESET;
        //Item.SETCURRENTKEY("Item Type","Item Category Code");
        //Item.SETRANGE("Item Type",Item."Item Type"::"Model Version");
        Item.SETRANGE("No.", "Item No.");
        Item.FINDFIRST;
        "Item No." := Item."No.";
        "Make Code" := Item."Item Category Code";
        //"Model Code" := Item."Product Group Code";
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        AssignSerialNo;
        //GAT.15.07 <<
    end;

    procedure LookupModelVersion()
    begin
        //GAT.15.07 >>
        DMSMgt.LookUpModelVersion(Item, "Item No.", "Make Code", "Model Code");
        "Item No." := Item."No.";
        "Make Code" := Item."Item Category Code";
        // "Model Code" := Item."Product Group Code";
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        AssignSerialNo;
        //GAT.15.07 <<
    end;

    local procedure AssignSerialNo()
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "Serial No." = '' THEN BEGIN
            InvtSetup.GET;
            //InvtSetup.TESTFIELD("Vehicle Serial No. Nos.");
            //NoSeriesMgt.InitSeries(InvtSetup."Vehicle Serial No. Nos.",xRec."No. Series",0D,"Serial No.","No. Series");
        END;
    end;

    procedure TestSerialNo()
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "Serial No." <> xRec."Serial No." THEN BEGIN
            InvtSetup.GET;
            //NoSeriesMgt.TestManual(InvtSetup."Vehicle Serial No. Nos.");
            "No. Series" := '';
        END;
    end;

    procedure AssistEdit(): Boolean
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        InvtSetup.GET;
        //InvtSetup.TESTFIELD("Vehicle Serial No. Nos.");
        //IF NoSeriesMgt.SelectSeries(InvtSetup."Vehicle Serial No. Nos.",xRec."No. Series","No. Series") THEN BEGIN
        NoSeriesMgt.SetSeries("Serial No.");
        EXIT(TRUE);
        //END;
    end;

    local procedure "--GAT.15.07"()
    begin
    end;

    local procedure LedgerFound(): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
        ItemLedgerEntry.SETRANGE("Serial No.", "Serial No.");
        EXIT(NOT ItemLedgerEntry.ISEMPTY)
    end;

    var
        Text50000: Label 'Item Ledger entries exists for item %1.Unable to modify the VIN No.';
        Item: Record Item;
        DMSMgt: Codeunit "IRD Mgt.";
}

