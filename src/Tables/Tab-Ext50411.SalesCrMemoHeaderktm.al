tableextension 50411 "Sales Cr.Memo Header_ktm" extends "Sales Cr.Memo Header"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50000; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Product Code';
            TableRelation = "Inventory Posting Group";
        }
        field(50001; "Transfer Receipt No."; Code[20])
        {
            Enabled = false;
            TableRelation = "Transfer Receipt Header" WHERE("Source Document No." = FILTER(<> ''));
        }
        field(50501; "Posting Time"; Time)
        {
            Description = 'NP15.1001';
        }
        field(50502; "Printed By"; Code[50])
        {
            Description = 'NP15.1001';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                // UserMgt.LookupUserID("User ID");
            end;
        }
        field(70000; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(70001; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(70002; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(70003; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(70004; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(70005; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(70006; "Phone No."; Text[100])
        {
        }
    }
}

