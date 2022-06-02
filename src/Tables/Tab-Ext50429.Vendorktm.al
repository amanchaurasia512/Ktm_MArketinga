tableextension 50429 "Vendor_ktm" extends Vendor
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
            end;

        }

        //Unsupported feature: Property Modification (Data type) on "Address(Field 5)".

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
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                IF NOT CONFIRM(Text100, FALSE) THEN
                    ERROR('Saving canceled');
            end;
        }
        field(50000; "Also Customer"; Boolean)
        {
        }
        field(50001; "TDS Balance"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TDS Entry"."TDS Amount" WHERE("Source Type" = CONST(Vendor),
                                                              "Bill-to/Pay-to No." = FIELD("No."),
                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                              Closed = FIELD("TDS Entry Closed Filter"),
                                                              "TDS Type" = CONST("Purchase TDS"),
                                                              "Posting Date" = FIELD("Date Filter")));

        }
        field(50002; "TDS Entry Closed Filter"; Boolean)
        {
            Description = 'TDS1.00';
            FieldClass = FlowFilter;
        }
        field(50003; "TDS Balance (Open)"; Decimal)
        {
            Description = 'TDS1.00';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("TDS Entry"."TDS Amount" WHERE("Source Type" = CONST(Vendor),
                                                              "Bill-to/Pay-to No." = FIELD("No."),
                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                              Closed = CONST(false),
                                                              "TDS Type" = CONST("Purchase TDS"),
                                                              "Posting Date" = FIELD("Date Filter"),
                                                              Reversed = CONST(false)));

        }
        field(50004; "Applicable Item Charges"; Code[250])
        {

            trigger OnLookup()
            var
                ItemCharge: Record "Item Charge";
            begin
                //SRT June 15th 2020 >>
                ItemCharge.RESET;
                IF PAGE.RUNMODAL(0, ItemCharge) = ACTION::LookupOK THEN BEGIN
                    IF STRPOS("Applicable Item Charges", ItemCharge."No.") = 0 THEN
                        IF "Applicable Item Charges" <> '' THEN
                            "Applicable Item Charges" += '|' + ItemCharge."No."
                        ELSE
                            "Applicable Item Charges" := ItemCharge."No.";
                END;
                //SRT June 15th 2020 <<
            end;
        }
        field(50005; "Hide in Trial Balance Report"; Boolean)
        {
        }
        field(50501; "Pragyapan Patra Mandatory"; Boolean)
        {
            Description = 'NP15.1001';
        }
        field(50502; "Consigment No. Mandatory"; Boolean)
        {
        }
    }


    //Unsupported feature: Property Modification (Id) on "InsertFromTemplate(Variable 1018)".

    //var
    //>>>> ORIGINAL VALUE:
    //InsertFromTemplate : 1018;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //InsertFromTemplate : 1998;
    //Variable type has not been exported.

    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        Text100: Label 'Do you want to save?';
}

