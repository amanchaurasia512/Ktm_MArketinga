tableextension 50439 "Sales & Receivables Setup_ktm" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Apply Cust. Ledg. Dim. Wise"; Boolean)
        {
        }
        field(50001; "Different Bill-to/Cust-to bill"; Text[20])
        {
            TableRelation = "Customer Posting Group";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(50002; "Skip Product Group Check"; Boolean)
        {
        }
        field(50003; "First Reminder Days"; Integer)
        {
        }
        field(50004; "Second Reminder Days"; Integer)
        {
        }
        field(50005; "Third Reminder Days"; Integer)
        {
        }
        field(50006; "Sender Name"; Text[100])
        {
        }
        field(50007; "Recipients Email"; Text[250])
        {
        }
        field(50008; "Email Subject"; Text[100])
        {
        }
        field(50009; "Message Body"; Text[250])
        {
        }
        field(50010; "First Reminder Email"; Text[100])
        {
        }
        field(50011; "Second Reminder Email"; Text[100])
        {
        }
        field(50012; "Third Reminder Email"; Text[100])
        {
        }
        field(50013; "Damage Location"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50014; "Populate Damage Location"; Boolean)
        {
            Description = 'Setup to auto insert location code in sales order if the value is true';
        }
        field(50015; "Restrict Invoicing from Damage"; Boolean)
        {
            Description = 'setup to restrict invoicing from damage location';
        }
        field(50016; "Default Transfer-from Code"; Code[10])
        {
            Caption = 'Default Transfer-from Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        field(50017; "Default Transfer-to Code"; Code[10])
        {
            Caption = 'Default Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        field(50018; "Default Item Jnl. Template"; Code[10])
        {
            TableRelation = "Item Journal Template";
        }
        field(50019; "Default Item Jnl. Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Default Item Jnl. Template"));
        }
        field(60003; "Show Description From"; Option)
        {
            OptionCaption = 'Default,Posting Groups';
            OptionMembers = Default,"Posting Groups";
        }
    }
}

