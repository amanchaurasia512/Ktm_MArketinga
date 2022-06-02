tableextension 50430 "Gen. Journal Batch_ktm" extends "Gen. Journal Batch"
{
    //Unsupported feature: Property Modification (Id) on "Text000(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : 1999;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text001(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text001 : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text001 : 1998;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GenJnlTemplate(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //GenJnlTemplate : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GenJnlTemplate : 1997;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GenJnlLine(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //GenJnlLine : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GenJnlLine : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "GenJnlAlloc(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //GenJnlAlloc : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //GenJnlAlloc : 1995;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "BankStmtImpFormatBalAccErr(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //BankStmtImpFormatBalAccErr : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BankStmtImpFormatBalAccErr : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ApprovalsMgmt(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApprovalsMgmt : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApprovalsMgmt : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CannotBeSpecifiedForRecurrJnlErr(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //CannotBeSpecifiedForRecurrJnlErr : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CannotBeSpecifiedForRecurrJnlErr : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "BalAccountIdDoesNotMatchAGLAccountErr(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //BalAccountIdDoesNotMatchAGLAccountErr : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BalAccountIdDoesNotMatchAGLAccountErr : 1991;
    //Variable type has not been exported.
    trigger OnModify()
    begin
        "Last Modified DateTime" := CurrentDateTime;
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Manage Template" THEN
            ERROR('No permission.');
    end;

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Manage Template" THEN
            ERROR('No permission.');
    end;

    var
        UserSetup: Record "User Setup";

}

