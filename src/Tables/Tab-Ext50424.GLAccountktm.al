tableextension 50424 "G/L Account_ktm" extends "G/L Account"
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

        field(50000; "To Sales/Purch. (LCY)"; Boolean)
        {
        }
        field(50001; "TR Code Mandatory"; Boolean)
        {
        }
        field(50002; "LC Code Mandatory"; Boolean)
        {
        }
        field(50003; "TDS Account"; Boolean)
        {
            CalcFormula = Exist("TDS Posting Group" WHERE("GL Account No." = FIELD("No.")));
            Description = 'TDS1.00';
            FieldClass = FlowField;
        }
        field(50004; "Net Change - TDS Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."TDS Amount" WHERE("G/L Account No." = FIELD("No."),
                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                              "Posting Date" = FIELD("Date Filter")));
            Caption = 'Net Change - TDS Amount';
            Description = 'TDS1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Description VAT Book"; Text[50])
        {
        }
        field(50006; "Demand loan code Mandatory"; Boolean)
        {
        }
    }

    var
        GLEntry: Record "G/L Entry";
        Text100: Label 'Do you want to save?';
}

