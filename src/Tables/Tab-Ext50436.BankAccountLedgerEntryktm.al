tableextension 50436 "Bank Account Ledger Entry_ktm" extends "Bank Account Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

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



    procedure CopyShortcutDimensions(var GLEntry: Record "G/L Entry"; DimValueCode: array[8] of Code[20])
    begin
        GLEntry."Shortcut Dimension 3 Code" := DimValueCode[3];
        GLEntry."Shortcut Dimension 4 Code" := DimValueCode[4];
        GLEntry."Shortcut Dimension 5 Code" := DimValueCode[5];
        GLEntry."Shortcut Dimension 6 Code" := DimValueCode[6];
        GLEntry."Shortcut Dimension 7 Code" := DimValueCode[7];
        GLEntry."Shortcut Dimension 8 Code" := DimValueCode[8];
    end;


    //Unsupported feature: Property Modification (Id) on "DimMgt(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimMgt : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimMgt : 1002;
    //Variable type has not been exported.

    var
        ShortcutCustomDimCode: array[8] of Code[20];
}

