table 50001 "Invoice Materialize View"
{
    Caption = 'Invoice Materialize View';

    fields
    {
        field(1; "Table ID"; Integer)
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Sales Invoice,Sales Credit Memo';
            OptionMembers = "Sales Invoice","Sales Credit Memo";
        }
        field(3; "Bill No"; Code[20])
        {
        }
        field(4; "Fiscal Year"; Text[30])
        {
        }
        field(5; "Bill Date"; Date)
        {
        }
        field(6; "Posting Time"; Time)
        {
        }
        field(7; "Source Type"; Option)
        {
            OptionCaption = 'Customer';
            OptionMembers = Customer;
        }
        field(8; "Customer Code"; Code[20])
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer;
        }
        field(9; "Source Code"; Code[10])
        {
        }
        field(10; "Customer Name"; Text[50])
        {
        }
        field(11; "VAT Registration No."; Code[20])
        {
        }
        field(12; Amount; Decimal)
        {
        }
        field(13; Discount; Decimal)
        {
        }
        field(14; "Taxable Amount"; Decimal)
        {
        }
        field(15; "TAX Amount"; Decimal)
        {
        }
        field(16; "Total Amount"; Decimal)
        {
        }
        field(17; "Created By"; Code[50])
        {
        }
        field(18; "Is Bill Printed"; Boolean)
        {
        }
        field(19; "Is Bill Active"; Boolean)
        {
        }
        field(20; "Printed By"; Code[50])
        {
        }
        field(21; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(22; "Is Printed"; Integer)
        {
        }
        field(23; "Printed Time"; Time)
        {
        }
        field(24; "Non Taxable Amount"; Decimal)
        {
        }
        field(44; "Entered By"; Code[50])
        {
        }
        field(200; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(201; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50000; "Sync Status"; Option)
        {
            OptionCaption = 'Not Valid,Pending,Sync In Progress,Sync Completed';
            OptionMembers = "Not Valid",Pending,"Sync In Progress","Sync Completed";
        }
        field(50001; "Synced Date"; Date)
        {
        }
        field(50002; "Synced Time"; Time)
        {
        }
        field(50003; "Sync with IRD"; Boolean)
        {
        }
        field(50004; "Is RealTime"; Boolean)
        {
        }
        field(50005; "CBMS Sync. Response"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Bill No", "Fiscal Year")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

