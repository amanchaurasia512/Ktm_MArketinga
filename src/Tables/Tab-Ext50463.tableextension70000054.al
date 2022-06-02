tableextension 50463 "tableextension70000054" extends Employee
{
    fields
    {
        modify(City)
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
        modify("Post Code")
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 39)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total Absence (Base)"(Field 45)".


        //Unsupported feature: Property Modification (CalcFormula) on "Balance(Field 59)".

        modify("First Name")
        {
            trigger OnAfterValidate()
            begin
                CreateDimension();
            end;
        }
        modify("Middle Name")
        {
            trigger OnAfterValidate()
            begin
                CreateDimension();
            end;

        }
        modify("Last Name")
        {
            trigger OnAfterValidate()
            begin
                CreateDimension();
            end;
        }

        field(50000; "Blood Group"; Option)
        {
            OptionCaption = ' ,O+VE,O-VE,A+VE,A-VE,B+VE,B-VE,AB+VE,AB-VE';
            OptionMembers = " ","O+VE","O-VE","A+VE","A-VE","B+VE","B-VE","AB+VE","AB-VE";
        }
        field(50001; "Marital Status"; Option)
        {
            OptionCaption = ' ,Unmarried,Married,Divorced';
            OptionMembers = " ",Unmarried,Married,Divorced;
        }
        field(50002; "Employement Start Date"; Date)
        {
        }
        field(50003; "Employement End Date"; Date)
        {
        }
        field(50004; "Vehicle No."; Code[30])
        {
        }
        field(50005; "Vehicle Company Name"; Text[50])
        {
        }
        field(50006; "Driving License No."; Code[20])
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: DimValue) (VariableCollection) on "CreateDimension(PROCEDURE 3)".


    //Unsupported feature: Property Deletion (Local) on "SetSearchNameToFullnameAndInitials(PROCEDURE 3)".


    //Unsupported feature: Property Modification (Name) on "SetSearchNameToFullnameAndInitials(PROCEDURE 3)".


    //Unsupported feature: Parameter Insertion (Parameter: Employee) (ParameterCollection) on "OnBeforeGetFullName(PROCEDURE 6)".

    local procedure CreateDimension()
    var

    begin
        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Employee Dimension");
        DimName := COPYSTR(("First Name" + "Middle Name" + "Last Name"), 1, 50);
        DimValue.SETRANGE("Dimension Code", HumanResSetup."Employee Dimension");
        DimValue.SETRANGE(Code, "No.");
        IF NOT DimValue.FINDFIRST THEN BEGIN
            DimValue.INIT;
            DimValue.VALIDATE("Dimension Code", HumanResSetup."Employee Dimension");
            DimValue.VALIDATE(Code, "No.");
            DimValue.VALIDATE(Name, DimName);
            DimValue.INSERT(TRUE);
        END ELSE BEGIN
            IF DimValue.Name <> ("First Name" + "Middle Name" + "Last Name") THEN BEGIN
                DimValue.VALIDATE(Name, DimName);
                DimValue.MODIFY;
            END;
        END;
    end;

    procedure SetSearchNameToFullnameAndInitials(): Code[250]
    begin
        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Employee Dimension");
        DimName := COPYSTR(("First Name" + "Middle Name" + "Last Name"), 1, 50);
        DimValue.SETRANGE("Dimension Code", HumanResSetup."Employee Dimension");
        DimValue.SETRANGE(Code, "No.");
        IF NOT DimValue.FINDFIRST THEN BEGIN
            DimValue.INIT;
            DimValue.VALIDATE("Dimension Code", HumanResSetup."Employee Dimension");
            DimValue.VALIDATE(Code, "No.");
            DimValue.VALIDATE(Name, DimName);
            DimValue.INSERT(TRUE);
        END ELSE BEGIN
            IF DimValue.Name <> ("First Name" + "Middle Name" + "Last Name") THEN BEGIN
                DimValue.VALIDATE(Name, DimName);
                DimValue.MODIFY;
            END;
        end;
    end;

    procedure GetBankAccountNo(): Text
    begin
        IF IBAN <> '' THEN
            EXIT(DELCHR(IBAN, '=<>'));

        IF "Bank Account No." <> '' THEN
            EXIT("Bank Account No.");
    end;

    local procedure CheckIfAnEmployeeIsLinkedToTheResource(ResourceNo: Code[20])
    var
        Employee: Record Employee;
    begin
        Employee.SETFILTER("No.", '<>%1', "No.");
        Employee.SETRANGE("Resource No.", ResourceNo);
        IF Employee.FINDFIRST THEN
            ERROR(EmployeeLinkedToResourceErr, Employee."No.");
    end;

    //Unsupported feature: Deletion (ParameterCollection) on "OnBeforeGetFullName(PROCEDURE 6).Employee(Parameter 1000)".



    //Unsupported feature: Property Modification (Id) on "Relative(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //Relative : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Relative : 1984;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "EmployeeAbsence(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //EmployeeAbsence : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //EmployeeAbsence : 1985;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "MiscArticleInformation(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //MiscArticleInformation : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //MiscArticleInformation : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ConfidentialInformation(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //ConfidentialInformation : 1009;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ConfidentialInformation : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "HumanResComment(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //HumanResComment : 1010;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //HumanResComment : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalespersonPurchaser(Variable 1011)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalespersonPurchaser : 1011;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalespersonPurchaser : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "NoSeriesMgt(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //NoSeriesMgt : 1012;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //NoSeriesMgt : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "EmployeeResUpdate(Variable 1013)".

    //var
    //>>>> ORIGINAL VALUE:
    //EmployeeResUpdate : 1013;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //EmployeeResUpdate : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "EmployeeSalespersonUpdate(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //EmployeeSalespersonUpdate : 1014;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //EmployeeSalespersonUpdate : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimMgt(Variable 1015)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimMgt : 1015;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimMgt : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text000(Variable 1016)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : 1016;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "BlockedEmplForJnrlErr(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //BlockedEmplForJnrlErr : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BlockedEmplForJnrlErr : 1995;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "BlockedEmplForJnrlPostingErr(Variable 1017)".

    //var
    //>>>> ORIGINAL VALUE:
    //BlockedEmplForJnrlPostingErr : 1017;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BlockedEmplForJnrlPostingErr : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "EmployeeLinkedToResourceErr(Variable 1018)".

    //var
    //>>>> ORIGINAL VALUE:
    //EmployeeLinkedToResourceErr : 1018;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //EmployeeLinkedToResourceErr : 1997;
    //Variable type has not been exported.

    var
        DimName: Text[50];
        DimensionValue: Record "Dimension Value";
        EmployeeLinkedToResourceErr: Label 'You cannot link multiple employees to the same resource. Employee %1 is already linked to that resource.', Comment = '%1 = employee no.';
        HumanResSetup: Record "Human Resources Setup";
        DimValue: Record "Dimension Value";
}

