tableextension 50427 "Customer_ktm" extends Customer
{
    fields
    {
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                    "Search Name" := Name;
                //KMT2016CU5 >>
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
                //KMT2016CU5 <<
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }

        modify(Contact)
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;

        }


        //Unsupported feature: Property Modification (Data type) on "Address(Field 5)".
        //Unsupported feature: Code Modification on "Name(Field 2).OnValidate".
        //Unsupported feature: Code Insertion on ""Address 2"(Field 6)".
        //Unsupported feature: Code Modification on "City(Field 7).OnLookup".

        //Unsupported feature: Deletion on ""Tax Area Code"(Field 108).OnValidate".

        field(50000; "Also Vendor"; Boolean)
        {
        }
        field(50001; "Hide in Trial Balance Report"; Boolean)
        {
        }
        field(50002; "VAT/PAN Attachment"; BLOB)
        {
        }
        field(50003; "VAT/PAN File Name"; Text[250])
        {
        }
        field(50004; "SMS Mobile No"; Text[30])
        {
        }
        field(50005; "SMS Log No."; Integer)
        {
        }
        field(50006; "SMS Sent Date"; Date)
        {
        }
    }

    local procedure "---SRT--"()
    begin
    end;

    procedure ViewBLOBFile(BlobFieldNo: Integer; FileName: Text)
    var
        BlobTxt: Label 'BLOB';
        NoAttachmentErr: Label 'No attachment available.';
    begin
        RecRef.GETTABLE(Rec);
        FldRef := RecRef.FIELD(BlobFieldNo);
        IF FORMAT(FldRef.TYPE) <> BlobTxt THEN
            EXIT;

        FldRef.CALCFIELD;
        //TempBlob := FldRef;
        IF NOT TempBlob.HASVALUE THEN
            ERROR(NoAttachmentErr);

        FileManagement.BLOBExport(TempBlob, FileName, TRUE);
    end;

    procedure InsertAttachment()
    var
        FileName: Text;
        Instr: InStream;
        OutStr: OutStream;
    begin
        IF UPLOADINTOSTREAM('', '', '', "VAT/PAN File Name", Instr) THEN BEGIN
            "VAT/PAN File Name" := GetFileName("VAT/PAN File Name");
            "VAT/PAN Attachment".CREATEOUTSTREAM(OutStr);
            COPYSTREAM(OutStr, Instr);
            MODIFY;
        END;
    end;

    local procedure GetFileName(FullFileName: Text): Text
    var
        FileNameWithoutPath: Text;
    begin
        FileNameWithoutPath := FullFileName;
        WHILE STRPOS(FileNameWithoutPath, '\') <> 0 DO
            FileNameWithoutPath := COPYSTR(FileNameWithoutPath, 1 + STRPOS(FileNameWithoutPath, '\'));

        EXIT(FileNameWithoutPath);
    end;

    procedure RemoveAttachment()
    begin
        IF NOT CONFIRM('Do you want to remove attachment?', FALSE) THEN
            EXIT;
        CLEAR("VAT/PAN Attachment");
        CLEAR("VAT/PAN File Name");
        MODIFY;
    end;


    //Unsupported feature: Property Modification (Id) on "CreateNewCustTxt(Variable 1041)".

    //var                   
    //>>>> ORIGINAL VALUE:
    //CreateNewCustTxt : 1041;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CreateNewCustTxt : 1999;                                // variable is not  define cannot do this
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SelectCustErr(Variable 1040)".

    //var
    //>>>> ORIGINAL VALUE:
    //SelectCustErr : 1040;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SelectCustErr : 1998;                                                   //variable not define
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CustNotRegisteredTxt(Variable 1042)".

    //var
    //>>>> ORIGINAL VALUE:
    //CustNotRegisteredTxt : 1042;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CustNotRegisteredTxt : 1997;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SelectCustTxt(Variable 1043)".

    //var
    //>>>> ORIGINAL VALUE:
    //SelectCustTxt : 1043;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SelectCustTxt : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "InsertFromTemplate(Variable 1044)".

    //var
    //>>>> ORIGINAL VALUE:
    //InsertFromTemplate : 1044;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InsertFromTemplate : 1995;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "OverrideImageQst(Variable 1045)".

    //var
    //>>>> ORIGINAL VALUE:
    //OverrideImageQst : 1045;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //OverrideImageQst : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PhoneNoCannotContainLettersErr(Variable 1046)".

    //var
    //>>>> ORIGINAL VALUE:
    //PhoneNoCannotContainLettersErr : 1046;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PhoneNoCannotContainLettersErr : 1993;
    //Variable type has not been exported.

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        Text100: Label 'Do you want to save?';
        "--SRT--": Integer;
        RecRef: RecordRef;
        FldRef: FieldRef;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
}

