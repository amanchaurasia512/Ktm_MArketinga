tableextension 50477 "Service Heade_ktm" extends "Service Header"
{

    //Unsupported feature: Code Modification on "UpdateServLinesByFieldNo(PROCEDURE 15)".

    //procedure UpdateServLinesByFieldNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Field.GET(DATABASE::"Service Header",ChangedFieldNo);

    IF ServLineExists AND AskQuestion THEN BEGIN
    #4..92
            ELSE
              OnUpdateServLineByChangedFieldName(Rec,ServLine,Field."Field Caption");
          END;
        UNTIL ServLine.NEXT = 0;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..95
         // OnAfterUpdateServLines(ChangedFieldName,ServLine);
        UNTIL ServLine.NEXT = 0;
    END;
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: ChangedFieldName) (ParameterCollection) on "OnAfterUpdateServLines(PROCEDURE 61)".


    //Unsupported feature: Property Modification (Attributes) on "OnAfterGetPostingNoSeriesCode(PROCEDURE 61)".


    //Unsupported feature: Property Modification (Name) on "OnAfterGetPostingNoSeriesCode(PROCEDURE 61)".


    //Unsupported feature: Property Modification (Attributes) on "OnBeforeGetNoSeries(PROCEDURE 60)".


    //Unsupported feature: Property Deletion (Local) on "OnBeforeGetNoSeries(PROCEDURE 60)".


    //Unsupported feature: Property Modification (Name) on "OnBeforeGetNoSeries(PROCEDURE 60)".


    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyCustomerFields(var ServiceHeader: Record "Service Header"; Customer: Record "Customer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyBillToCustomerFields(var ServiceHeader: Record "Service Header"; Customer: Record "Customer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetPostingNoSeriesCode(var ServiceHeader: Record "Service Header"; var PostingNos: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitRecord(var ServiceHeader: Record "Service Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateShipToAddress(var ServiceHeader: Record "Service Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateServLineByChangedFieldName(ServiceHeader: Record "Service Header"; var ServiceLine: Record "service line"; ChangedFieldName: Text[100])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDimTableIDs(var ServiceHeader: Record "Service Header"; CallingFieldNo: Integer; var TableID: array[10] of Integer; var No: array[10] of Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var ServiceHeader: Record "Service Header"; xServiceHeader: Record "Service Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateCust(var ServiceHeader: Record "Service Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferExtendedTextForServLineRecreation(var ServLine: Record "Service Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckBlockedCustomer(Customer: Record "Customer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmUpdateContractNo(var ServiceHeader: Record "Service Header"; Confirmed: Boolean; HideValidationDialog: Boolean; IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetNoSeries(var ServiceHeader: Record "Service Header"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetPostingNoSeriesCode(var ServiceHeader: Record "Service Header"; ServiceMgtSetup: Record "Service Mgt. Setup"; var PostingNos: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertServLineOnServLineRecreation(var ServiceLine: Record "Service Line"; var TempServiceLine: Record "Service Line" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestMandatoryFields(var ServiceHeader: Record "Service Header"; var ServiceLine: Record "Service Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var ServiceHeader: Record "Service Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeriesManual(var ServiceHeader: Record "Service Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateAllLineDim(var ServiceHeader: Record "Service Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateDimOnBeforeUpdateLines(var ServiceHeader: Record "Service Header"; xServiceHeader: Record "Service Header"; CurrentFieldNo: Integer)
    begin
    end;

    //Unsupported feature: Property Modification (Name) on "OnAfterGetPostingNoSeriesCode(PROCEDURE 61).ServiceHeader(Parameter 1000)".


    //Unsupported feature: Property Modification (Subtype) on "OnAfterGetPostingNoSeriesCode(PROCEDURE 61).ServiceHeader(Parameter 1000)".


    //Unsupported feature: Deletion (ParameterCollection) on "OnAfterGetPostingNoSeriesCode(PROCEDURE 61).PostingNos(Parameter 1002)".


    //Unsupported feature: Deletion (ParameterCollection) on "OnBeforeGetNoSeries(PROCEDURE 60).ServiceHeader(Parameter 1000)".


    //Unsupported feature: Deletion (ParameterCollection) on "OnBeforeGetNoSeries(PROCEDURE 60).NoSeriesCode(Parameter 1001)".


    //Unsupported feature: Deletion (ParameterCollection) on "OnBeforeGetNoSeries(PROCEDURE 60).IsHandled(Parameter 1002)".

}

