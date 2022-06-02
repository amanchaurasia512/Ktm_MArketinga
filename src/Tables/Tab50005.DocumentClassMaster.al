table 50005 "Document Class Master"
{
    Caption = 'Document Class Master';
    DrillDownPageID = 50005;
    LookupPageID = 50005;

    fields
    {
        field(1; "Doc. Class Type"; Option)
        {
            OptionCaption = ' ,Letter of Credit/Telex Transfer,T/R,Margin,PragyapanPatra,Party,IFB/Title,Demand loan';
            OptionMembers = " ","Letter of Credit/Telex Transfer","T/R",Margin,PragyapanPatra,Party,"IFB/Title","Demand loan";
        }
        field(2; "Doc. Class No."; Code[100])
        {
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = ' ,Vendor,Bank';
            OptionMembers = " ",Vendor,Bank;

            trigger OnValidate()
            begin
                CLEAR("Account No.");
                CLEAR("Account Name");
            end;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Account Type" = CONST(Bank)) "Bank Account"."No.";

            trigger OnValidate()
            begin
                CLEAR("Account Name");

                CASE "Account Type" OF
                    "Account Type"::Vendor:
                        BEGIN
                            Vendor.GET("Account No.");
                            UpdateAccountName(Vendor.Name);
                        END;
                    "Account Type"::Bank:
                        BEGIN
                            Bank.GET("Account No.");
                            UpdateAccountName(Bank.Name);
                        END;
                END;
            end;
        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; Blocked; Boolean)
        {
        }
        field(5000; "Party Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("G/L Account Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Party No." = FIELD("Doc. Class No.")));
            FieldClass = FlowField;
        }
        field(5001; "G/L Account Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "G/L Account"."No.";
        }
        field(5002; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(5003; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5004; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No.""=CONST(2));
        }
    }

    keys
    {
        key(Key1; "Doc. Class Type", "Doc. Class No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CASE "Doc. Class Type" OF
            "Doc. Class Type"::"Letter of Credit/Telex Transfer":
                BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Letter of Credit/Telex Trans.", "Doc. Class No.");
                    IF GLEntry.FINDFIRST THEN
                        ERROR(Text1002, "Doc. Class No.");
                END;
            "Doc. Class Type"::"T/R":
                BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE(Loan, "Doc. Class No.");
                    IF GLEntry.FINDFIRST THEN
                        ERROR(Text1002, "Doc. Class No.");
                END;
            "Doc. Class Type"::Margin:
                BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE(Margin, "Doc. Class No.");
                    IF GLEntry.FINDFIRST THEN
                        ERROR(Text1002, "Doc. Class No.");
                END;
            "Doc. Class Type"::PragyapanPatra:
                BEGIN
                    VATEntry.RESET;
                    VATEntry.SETRANGE(PragyapanPatra, "Doc. Class No.");
                    IF VATEntry.FINDFIRST THEN
                        ERROR(Text1003, "Doc. Class No.");
                END;
            "Doc. Class Type"::Party:
                BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE("Party Type", "Doc. Class Type"::Party);
                    GLEntry.SETRANGE("Party No.", "Doc. Class No.");
                    IF GLEntry.FINDFIRST THEN
                        ERROR(Text1002, "Doc. Class No.");
                END;
            "Doc. Class Type"::"IFB/Title":
                BEGIN
                    GLEntry.RESET;
                    //GLEntry.SETRANGE("IFB/Title","Doc. Class No.");
                    IF GLEntry.FINDFIRST THEN
                        ERROR(Text1002, "Doc. Class No.");
                END;
        END;
    end;

    trigger OnInsert()
    begin
        IF "Doc. Class Type" = "Doc. Class Type"::" " THEN
            ERROR(Text1001, FIELDCAPTION("Doc. Class Type"));

        IF ("Doc. Class Type" <> "Doc. Class Type"::" ") AND ("Doc. Class No." = '') THEN
            ERROR(Text1001, FIELDCAPTION("Doc. Class No."));
    end;

    var
        Text1001: Label '%1 should not be blank';
        GLEntry: Record "G/L Entry";
        Text1002: Label '%1 cannot be deleted. %1 has General Ledger Entries';
        VATEntry: Record "VAT Entry";
        Text1003: Label '%1 cannot be deleted. %1 has VAT Ledger Entries';
        Bank: Record "Bank Account";
        Vendor: Record Vendor;

    local procedure UpdateAccountName(Text: Text[50])
    begin
        "Account Name" := Text;
    end;
}

