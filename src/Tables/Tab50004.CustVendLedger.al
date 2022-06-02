table 50004 "Cust-Vend Ledger"
{
    Caption = 'Cust-Vend Ledger';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry From"; Option)
        {
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(3; "Party No."; Code[20])
        {
            Caption = 'Party No.';
            Description = 'Can be customer or vendor based on entry from type';

            trigger OnValidate()
            var
                CustRec: Record Customer;
                VendorRec: Record Vendor;
            begin
                IF "Entry From" = "Entry From"::Customer THEN BEGIN
                    CustRec.RESET;
                    CustRec.SETRANGE("No.", "Party No.");
                    IF CustRec.FINDFIRST THEN
                        "Party Name" := CustRec.Name;
                END ELSE
                    IF "Entry From" = "Entry From"::Vendor THEN BEGIN
                        VendorRec.RESET;
                        VendorRec.SETRANGE("No.", "Party No.");
                        IF VendorRec.FINDFIRST THEN
                            "Party Name" := VendorRec.Name;
                    END;
            end;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnLookup()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                IncomingDocument.HyperlinkToDocument("Document No.", "Posting Date");
            end;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
            FieldClass = Normal;
        }
        field(14; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Entry No."),
                                                                         "Posting Date" = FIELD("Date Filter")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Original Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Cust. Ledger Entry No." = FIELD("Entry No."),
                                                                                 "Entry Type" = FILTER("Initial Entry"),
                                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Original Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Remaining Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Cust. Ledger Entry No." = FIELD("Entry No."),
                                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Remaining Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(18; "Sales/Purch. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales (LCY)';
        }
        field(19; "Profit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Profit (LCY)';
        }
        field(20; "Inv. Discount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inv. Discount (LCY)';
        }
        field(21; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(22; "Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(25; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(33; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(34; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(35; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(36; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(37; "Due Date"; Date)
        {
            Caption = 'Due Date';

            trigger OnValidate()
            var
                ReminderEntry: Record "Reminder/Fin. Charge Entry";
                ReminderIssue: Codeunit "Reminder-Issue";
            begin
                TESTFIELD(Open, TRUE);
                IF "Due Date" <> xRec."Due Date" THEN BEGIN
                    ReminderEntry.SETCURRENTKEY("Customer Entry No.", Type);
                    ReminderEntry.SETRANGE("Customer Entry No.", "Entry No.");
                    ReminderEntry.SETRANGE(Type, ReminderEntry.Type::Reminder);
                    // ReminderEntry.SETRANGE("Reminder Level","Last Issued Reminder Level");
                    IF ReminderEntry.FINDLAST THEN
                        ReminderIssue.ChangeDueDate(ReminderEntry, "Due Date", xRec."Due Date");
                END;
            end;
        }
        field(38; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
            end;
        }
        field(39; "Original Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Original Pmt. Disc. Possible';
            Editable = false;
        }
        field(40; "Pmt. Disc. Given (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Disc. Given (LCY)';
        }
        field(43; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(44; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(45; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
        }
        field(46; "Closed by Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Amount';
        }
        field(47; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
            end;
        }
        field(49; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(50; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(51; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(52; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(53; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(54; "Closed by Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Closed by Amount (LCY)';
        }
        field(58; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = Normal;
        }
        field(59; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = Normal;
        }
        field(60; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(61; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(62; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(63; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(64; "Calculate Interest"; Boolean)
        {
            Caption = 'Calculate Interest';
        }
        field(65; "Closing Interest Calculated"; Boolean)
        {
            Caption = 'Closing Interest Calculated';
        }
        field(66; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(67; "Closed by Currency Code"; Code[10])
        {
            Caption = 'Closed by Currency Code';
            TableRelation = Currency;
        }
        field(68; "Closed by Currency Amount"; Decimal)
        {
            AccessByPermission = TableData 4 = R;
            AutoFormatExpression = "Closed by Currency Code";
            AutoFormatType = 1;
            Caption = 'Closed by Currency Amount';
        }
        field(73; "Adjusted Currency Factor"; Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(74; "Original Currency Factor"; Decimal)
        {
            Caption = 'Original Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(75; "Original Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Entry No."),
                                                                         "Entry Type" = FILTER("Initial Entry"),
                                                                         "Posting Date" = FIELD("Date Filter")));
            Caption = 'Original Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(77; "Remaining Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Pmt. Disc. Possible';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
                CALCFIELDS(Amount, "Original Amount");

                IF "Remaining Pmt. Disc. Possible" * Amount < 0 THEN
                    FIELDERROR("Remaining Pmt. Disc. Possible", STRSUBSTNO(Text000, FIELDCAPTION(Amount)));

                IF ABS("Remaining Pmt. Disc. Possible") > ABS("Original Amount") THEN
                    FIELDERROR("Remaining Pmt. Disc. Possible", STRSUBSTNO(Text001, FIELDCAPTION("Original Amount")));
            end;
        }
        field(78; "Pmt. Disc. Tolerance Date"; Date)
        {
            Caption = 'Pmt. Disc. Tolerance Date';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
            end;
        }
        field(79; "Max. Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Max. Payment Tolerance';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
                CALCFIELDS(Amount, "Remaining Amount");

                IF "Max. Payment Tolerance" * Amount < 0 THEN
                    FIELDERROR("Max. Payment Tolerance", STRSUBSTNO(Text000, FIELDCAPTION(Amount)));

                IF ABS("Max. Payment Tolerance") > ABS("Remaining Amount") THEN
                    FIELDERROR("Max. Payment Tolerance", STRSUBSTNO(Text001, FIELDCAPTION("Remaining Amount")));
            end;
        }
        field(80; "Last Issued Reminder Level"; Integer)
        {
            Caption = 'Last Issued Reminder Level';
        }
        field(81; "Accepted Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Accepted Payment Tolerance';
        }
        field(82; "Accepted Pmt. Disc. Tolerance"; Boolean)
        {
            Caption = 'Accepted Pmt. Disc. Tolerance';
        }
        field(83; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Pmt. Tolerance (LCY)';
        }
        field(84; "Amount to Apply"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount to Apply';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
                CALCFIELDS("Remaining Amount");

                IF "Amount to Apply" * "Remaining Amount" < 0 THEN
                    FIELDERROR("Amount to Apply", STRSUBSTNO(Text000, FIELDCAPTION("Remaining Amount")));

                IF ABS("Amount to Apply") > ABS("Remaining Amount") THEN
                    FIELDERROR("Amount to Apply", STRSUBSTNO(Text001, FIELDCAPTION("Remaining Amount")));
            end;
        }
        field(85; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(86; "Applying Entry"; Boolean)
        {
            Caption = 'Applying Entry';
        }
        field(87; Reversed; Boolean)
        {
            BlankZero = true;
            Caption = 'Reversed';
        }
        field(88; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(89; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "Cust. Ledger Entry";
        }
        field(90; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(172; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
            end;
        }
        field(173; "Applies-to Ext. Doc. No."; Code[35])
        {
            Caption = 'Applies-to Ext. Doc. No.';
        }
        field(288; "Recipient Bank Account"; Code[10])
        {
            Caption = 'Recipient Bank Account';
        }
        field(289; "Message to Recipient"; Text[140])
        {
            Caption = 'Message to Recipient';

            trigger OnValidate()
            begin
                TESTFIELD(Open, TRUE);
            end;
        }
        field(290; "Exported to Payment File"; Boolean)
        {
            Caption = 'Exported to Payment File';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = true;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(1200; "Direct Debit Mandate ID"; Code[35])
        {
            Caption = 'Direct Debit Mandate ID';
        }
        field(1201; "Party Name"; Text[50])
        {
        }
        field(1202; "Entry No. From Cust. Ledger"; Integer)
        {
            TableRelation = "Cust. Ledger Entry";
        }
        field(1203; "Entry No. From Vend Ledger"; Integer)
        {
            TableRelation = "Vendor Ledger Entry";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Party Name", "Document Type", "Document No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'must have the same sign as %1';
        Text001: Label 'must not be larger than %1';

    [Scope('Onprem')]
    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Entry No."));
    end;

    [Scope('Onprem')]
    procedure CopyFromCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        "Entry From" := "Entry From"::Customer;
        VALIDATE("Party No.", CustLedgEntry."Customer No.");
        "Posting Date" := CustLedgEntry."Posting Date";
        "Document Date" := CustLedgEntry."Document Date";
        "Document Type" := CustLedgEntry."Document Type";
        "Document No." := CustLedgEntry."Document No.";
        "External Document No." := CustLedgEntry."External Document No.";
        "Entry No. From Cust. Ledger" := CustLedgEntry."Entry No.";
        Description := CustLedgEntry.Description;
        "Currency Code" := CustLedgEntry."Currency Code";
        CustLedgEntry.CALCFIELDS("Debit Amount");
        "Debit Amount" := CustLedgEntry."Debit Amount";
        CustLedgEntry.CALCFIELDS("Credit Amount");
        "Credit Amount" := CustLedgEntry."Credit Amount";
        CustLedgEntry.CALCFIELDS("Debit Amount (LCY)");
        "Debit Amount (LCY)" := CustLedgEntry."Debit Amount (LCY)";
        CustLedgEntry.CALCFIELDS("Credit Amount (LCY)");
        "Credit Amount (LCY)" := CustLedgEntry."Credit Amount (LCY)";
        CustLedgEntry.CALCFIELDS(Amount);
        Amount := CustLedgEntry.Amount;
        CustLedgEntry.CALCFIELDS("Amount (LCY)");
        "Amount (LCY)" := CustLedgEntry."Amount (LCY)";
        CustLedgEntry.CALCFIELDS("Remaining Amount");
        "Remaining Amount" := CustLedgEntry."Remaining Amount";
        CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
        "Remaining Amt. (LCY)" := CustLedgEntry."Remaining Amt. (LCY)";
        "Sales/Purch. (LCY)" := CustLedgEntry."Sales (LCY)";
        "Profit (LCY)" := CustLedgEntry."Profit (LCY)";
        "Inv. Discount (LCY)" := CustLedgEntry."Inv. Discount (LCY)";
        "Posting Group" := CustLedgEntry."Customer Posting Group";
        "Global Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
        "Global Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
        "Dimension Set ID" := CustLedgEntry."Dimension Set ID";
        "Source Code" := CustLedgEntry."Source Code";
        "On Hold" := CustLedgEntry."On Hold";
        "Applies-to Doc. Type" := CustLedgEntry."Applies-to Doc. Type";
        "Applies-to Doc. No." := CustLedgEntry."Applies-to Doc. No.";
        "Due Date" := CustLedgEntry."Due Date";
        "Pmt. Discount Date" := CustLedgEntry."Pmt. Discount Date";
        "Applies-to ID" := CustLedgEntry."Applies-to ID";
        "Journal Batch Name" := CustLedgEntry."Journal Batch Name";
        "Reason Code" := CustLedgEntry."Reason Code";
        "Direct Debit Mandate ID" := CustLedgEntry."Direct Debit Mandate ID";
        "User ID" := USERID;
        "Bal. Account Type" := CustLedgEntry."Bal. Account Type";
        "Bal. Account No." := CustLedgEntry."Bal. Account No.";
        "IC Partner Code" := CustLedgEntry."IC Partner Code";
        Prepayment := CustLedgEntry.Prepayment;
        "Recipient Bank Account" := CustLedgEntry."Recipient Bank Account";
        "Message to Recipient" := CustLedgEntry."Message to Recipient";
        "Applies-to Ext. Doc. No." := CustLedgEntry."Applies-to Ext. Doc. No.";
        "Payment Method Code" := CustLedgEntry."Payment Method Code";
        "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
    end;

    [Scope('Onprem')]
    procedure CopyFromVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        "Entry From" := "Entry From"::Vendor;
        VALIDATE("Party No.", VendLedgEntry."Vendor No.");
        "Posting Date" := VendLedgEntry."Posting Date";
        "Document Date" := VendLedgEntry."Document Date";
        "Document Type" := VendLedgEntry."Document Type";
        "Document No." := VendLedgEntry."Document No.";
        "External Document No." := VendLedgEntry."External Document No.";
        Description := VendLedgEntry.Description;
        "Entry No. From Vend Ledger" := VendLedgEntry."Entry No.";
        "Currency Code" := VendLedgEntry."Currency Code";
        VendLedgEntry.CALCFIELDS("Debit Amount");
        "Debit Amount" := VendLedgEntry."Debit Amount";
        VendLedgEntry.CALCFIELDS("Credit Amount");
        "Credit Amount" := VendLedgEntry."Credit Amount";
        VendLedgEntry.CALCFIELDS("Debit Amount (LCY)");
        "Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
        VendLedgEntry.CALCFIELDS("Credit Amount (LCY)");
        "Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
        VendLedgEntry.CALCFIELDS(Amount);
        Amount := VendLedgEntry.Amount;
        VendLedgEntry.CALCFIELDS("Amount (LCY)");
        "Amount (LCY)" := VendLedgEntry."Amount (LCY)";
        VendLedgEntry.CALCFIELDS("Remaining Amount");
        "Remaining Amount" := VendLedgEntry."Remaining Amount";
        VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
        "Remaining Amt. (LCY)" := VendLedgEntry."Remaining Amt. (LCY)";
        "Sales/Purch. (LCY)" := VendLedgEntry."Purchase (LCY)";
        "Inv. Discount (LCY)" := VendLedgEntry."Inv. Discount (LCY)";
        "Posting Group" := VendLedgEntry."Vendor Posting Group";
        "Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
        "Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
        "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
        "Source Code" := VendLedgEntry."Source Code";
        "On Hold" := VendLedgEntry."On Hold";
        "Applies-to Doc. Type" := VendLedgEntry."Applies-to Doc. Type";
        "Applies-to Doc. No." := VendLedgEntry."Applies-to Doc. No.";
        "Due Date" := VendLedgEntry."Due Date";
        "Pmt. Discount Date" := VendLedgEntry."Pmt. Discount Date";
        "Applies-to ID" := VendLedgEntry."Applies-to ID";
        "Journal Batch Name" := VendLedgEntry."Journal Batch Name";
        "Reason Code" := VendLedgEntry."Reason Code";
        "User ID" := USERID;
        "Bal. Account Type" := VendLedgEntry."Bal. Account Type";
        "Bal. Account No." := VendLedgEntry."Bal. Account No.";
        "IC Partner Code" := VendLedgEntry."IC Partner Code";
        Prepayment := VendLedgEntry.Prepayment;
        "Recipient Bank Account" := VendLedgEntry."Recipient Bank Account";
        "Message to Recipient" := VendLedgEntry."Message to Recipient";
        "Applies-to Ext. Doc. No." := VendLedgEntry."Applies-to Ext. Doc. No.";
        "Payment Method Code" := VendLedgEntry."Payment Method Code";
        "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
    end;
}

