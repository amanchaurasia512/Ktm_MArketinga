codeunit 50002 "IRD Upgrade"
{
    Subtype = Upgrade;

    trigger OnRun()
    begin
    end;

    var
        DataUpgradeMgt: Codeunit "Data Upgrade Mgt.";

    // [CheckPrecondition]
    [Scope('OnPrem')]
    procedure CheckPreconditions()
    begin
    end;

    //[TableSyncSetup]
    [Scope('OnPrem')]
    procedure GetTableSyncSetupIRD(var TableSynchSetup: Record "Table Synch. Setup")
    begin
    end;

    //[UpgradePerCompany]
    [Scope('OnPrem')]
    procedure UpgradeData()
    begin
    end;
}

