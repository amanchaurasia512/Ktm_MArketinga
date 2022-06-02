tableextension 50423 "Salesperson/Purchaser_ktm" extends "Salesperson/Purchaser"
{
    fields
    {

        //Unsupported feature: Code Insertion on "Name(Field 2)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        CreateDimension //KMT2016CU5
        */
        //end;
    }

    procedure CreateDimension()
    var
        DimValue: Record "Dimension Value";
    begin
        GLSetup1.GET;
        GLSetup1.TESTFIELD("Global Dimension 2 Code");
        //DimName := COPYSTR(("First Name" + "Middle Name" + "Last Name"),1,50);
        DimName := COPYSTR(Name, 1, 50);
        DimValue.SETRANGE("Dimension Code", GLSetup1."Global Dimension 2 Code");
        DimValue.SETRANGE(Code, Code);
        IF NOT DimValue.FINDFIRST THEN BEGIN
            DimValue.INIT;
            DimValue.VALIDATE("Dimension Code", GLSetup1."Global Dimension 2 Code");
            DimValue.VALIDATE(Code, Code);
            DimValue.VALIDATE(Name, DimName);
            DimValue.INSERT(TRUE);
        END ELSE BEGIN
            IF DimValue.Name <> Name THEN BEGIN
                DimValue.VALIDATE(Name, DimName);
                DimValue.MODIFY;
            END;
        END;
    end;

    var
        DimName: Text[50];
        DimensionValue: Record "Dimension Value";
        GLSetup1: Record "General Ledger Setup";
}

