table 50006 "Product&Salesperson Posting Gr"
{
    DrillDownPageID = 50006;
    LookupPageID = 50006;

    fields
    {
        field(1; "Customer No."; Code[10])
        {
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                Customer.SETRANGE(Customer."No.", "Customer No.");
                IF Customer.FINDFIRST THEN
                    "Customer Name" := Customer.Name;
            end;
        }
        field(2; "Customer Name"; Text[50])
        {
        }
        field(3; "Product Segment Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('PRODUCT SEGMENT'));
        }
        field(4; "Area Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('AREA CODE'));
        }
        field(5; "Inventory Posting Group"; Code[10])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(6; "Current Salesperson"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(7; "Last Date Modified"; Date)
        {
        }
        field(8; "Last Modified By"; Code[50])
        {
        }
        field(9; "New Area Code"; Code[20])
        {
            Description = 'to be used for salesperson update';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('AREA CODE'));
        }
        field(10; "Region Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(11; "New Region Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(12; "State Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Product Segment Code", "Inventory Posting Group", "Area Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Date Modified" := TODAY;
        "Last Modified By" := USERID;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
        "Last Modified By" := USERID;
    end;

    var
        Customer: Record Customer;
}

