tableextension 50434 "Item_ktm" extends Item
{
    fields
    {
        modify("Search Description")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }
        modify("Description 2")
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }
        modify("Base Unit of Measure")
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                IF ExistsItemLedgerEntry THEN
                    ERROR(CannotChangeFieldErr, FIELDCAPTION(Type), TABLECAPTION, "No.", ItemLedgEntryTableCaptionTxt);
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Item No.");
                ItemLedgEntry.SETRANGE("Item No.", "No.");
                IF NOT ItemLedgEntry.ISEMPTY THEN
                    ERROR(CannotChangeFieldErr, FIELDCAPTION(Type), TABLECAPTION, "No.", ItemLedgEntry.TABLECAPTION);
            end;
        }
        modify("Item Tracking Code")
        {
            trigger OnAfterValidate()
            begin
                IF "Item Tracking Code" <> '' THEN
                    VALIDATE("Costing Method", "Costing Method"::Specific);
            end;
        }
        field(50000; "Free Item"; Boolean)
        {

            trigger OnValidate()
            begin
                //KMT2016CU5 >>
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
                //KMT2016CU5 <<
            end;
        }
        field(50001; "Sub-Category"; Option)
        {
            Description = 'Currently being used for only RBI items';
            OptionCaption = ' ,Health,HY HO';
            OptionMembers = " ",Health,"HY HO";
        }
        field(50602; "RBI Product Code"; Code[10])
        {

            trigger OnValidate()
            begin
                //KMT2016CU5 >>
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
                //KMT2016CU5 <<
            end;
        }
    }

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    //Unsupported feature: Property Modification (Fields) on "Brick(FieldGroup 2)".


    //Unsupported feature: Property Modification (Id) on "DeleteRelatedData(PROCEDURE 12).BinContent(Variable 1002)".


    //Unsupported feature: Property Modification (Id) on "DeleteRelatedData(PROCEDURE 12).ItemCrossReference(Variable 1001)".


    //Unsupported feature: Property Modification (Id) on "DeleteRelatedData(PROCEDURE 12).SocialListeningSearchTopic(Variable 1000)".


    //Unsupported feature: Property Modification (Id) on "DeleteRelatedData(PROCEDURE 12).MyItem(Variable 1003)".


    //Unsupported feature: Property Modification (Id) on "DeleteRelatedData(PROCEDURE 12).ItemAttributeValueMapping(Variable 1004)".




    //Unsupported feature: Property Modification (Id) on "SelectItemErr(Variable 1083)".

    //var
    //>>>> ORIGINAL VALUE:
    //SelectItemErr : 1083;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SelectItemErr : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "CreateNewItemTxt(Variable 1187)".

    //var
    //>>>> ORIGINAL VALUE:
    //CreateNewItemTxt : 1187;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CreateNewItemTxt : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ItemNotRegisteredTxt(Variable 1186)".

    //var
    //>>>> ORIGINAL VALUE:
    //ItemNotRegisteredTxt : 1186;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ItemNotRegisteredTxt : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SelectItemTxt(Variable 1185)".

    //var
    //>>>> ORIGINAL VALUE:
    //SelectItemTxt : 1185;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SelectItemTxt : 1989;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UnitOfMeasureNotExistErr(Variable 1026)".

    //var
    //>>>> ORIGINAL VALUE:
    //UnitOfMeasureNotExistErr : 1026;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UnitOfMeasureNotExistErr : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ItemLedgEntryTableCaptionTxt(Variable 1048)".

    //var
    //>>>> ORIGINAL VALUE:
    //ItemLedgEntryTableCaptionTxt : 1048;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ItemLedgEntryTableCaptionTxt : 1987;
    //Variable type has not been exported.

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Text100: Label 'Do you want to save?';
        CannotChangeFieldErr: Label 'You cannot change the %1 field on %2 %3 because at least one %4 exists for this item.', Comment = '%1 = Field Caption, %2 = Item Table Name, %3 = Item No., %4 = Table Name';
        ItemLedgEntryTableCaptionTxt: Label 'Item Ledger Entry';
}


