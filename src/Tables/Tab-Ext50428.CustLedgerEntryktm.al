tableextension 50428 "Cust. Ledger Entry_ktm" extends "Cust. Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amount"(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Original Amt. (LCY)"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amt. (LCY)"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount (LCY)"(Field 17)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount (LCY)"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount (LCY)"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Original Amount"(Field 75)".


        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50000; "Also Vendor"; Boolean)
        {
        }
        field(50002; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50003; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50004; "Pass Value to Sales/Purch (LCY"; Boolean)
        {
            Caption = 'Pass Value to Report';
        }
        // field(70000; "Shortcut Dimension 3 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,3';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
        // }
        // field(70001; "Shortcut Dimension 4 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,4';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(4));
        // }
        // field(70002; "Shortcut Dimension 5 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,5';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(5));
        // }
        // field(70003; "Shortcut Dimension 6 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,6';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(6));
        // }
        // field(70004; "Shortcut Dimension 7 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,7';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(7));
        // }
        // field(70005; "Shortcut Dimension 8 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,8';
        //     TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(8));
        // }
    }
    keys
    {
        // key(Key2; "Customer No.", "Applies-to ID", Open, Positive, "Posting Date")
        // {
        // }
    }


    //Unsupported feature: Code Modification on "SetStyle(PROCEDURE 5)".

    //procedure SetStyle();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Open THEN BEGIN
      IF WORKDATE > "Due Date" THEN
        EXIT('Unfavorable')
    END ELSE
      IF "Closed at Date" > "Due Date" THEN
        EXIT('Attention');
    EXIT('');
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF Open THEN BEGIN
      IF WORKDATE >= "Due Date" THEN   // full code not exported 
    #3..7
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: CustRec) (VariableCollection) on "CopyFromGenJnlLine(PROCEDURE 6)".


    //Unsupported feature: Code Modification on "CopyFromCVLedgEntryBuffer(PROCEDURE 10)".

    //procedure CopyFromCVLedgEntryBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TRANSFERFIELDS(CVLedgerEntryBuffer);
    Amount := CVLedgerEntryBuffer.Amount;
    "Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)";
    "Remaining Amount" := CVLedgerEntryBuffer."Remaining Amount";
    "Remaining Amt. (LCY)" := CVLedgerEntryBuffer."Remaining Amt. (LCY)";
    "Original Amount" := CVLedgerEntryBuffer."Original Amount";
    "Original Amt. (LCY)" := CVLedgerEntryBuffer."Original Amt. (LCY)";

    OnAfterCopyCustLedgerEntryFromCVLedgEntryBuffer(Rec,CVLedgerEntryBuffer);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*                             //Modified code is not expported 
    #1..7
    */
    //end;

    procedure CopyShortcutDimensions(var GLEntry: Record "G/L Entry"; DimValueCode: array[8] of Code[20])
    begin
        GLEntry."Shortcut Dimension 3 Code" := DimValueCode[3];
        GLEntry."Shortcut Dimension 4 Code" := DimValueCode[4];
        GLEntry."Shortcut Dimension 5 Code" := DimValueCode[5];
        GLEntry."Shortcut Dimension 6 Code" := DimValueCode[6];
        GLEntry."Shortcut Dimension 7 Code" := DimValueCode[7];
        GLEntry."Shortcut Dimension 8 Code" := DimValueCode[8];
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        ShortcutCustomDimCode: array[8] of Code[20];
}

