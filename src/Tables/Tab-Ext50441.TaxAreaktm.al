tableextension 50441 "Tax Area_ktm" extends "Tax Area"
{
    fields
    {
        field(50000; "Source No."; Code[20])
        {
        }
        field(50001; "Posted Sales Invoice"; Code[20])
        {
        }
        field(50002; "Transport Name"; Text[100])
        {
        }
        field(50003; "Bilty No."; Code[20])
        {
        }
        field(50004; "Booking Date"; Date)
        {
        }
        field(50005; "Mail Sent"; Boolean)
        {
        }
        field(50006; Posted; Boolean)
        {
        }
        field(50007; "Posted By"; Code[50])
        {
        }
        field(50008; "Posted Time"; Time)
        {
        }
        field(50009; "Transport No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                IF Vendor.GET("Transport No.") THEN
                    "Transport Name" := Vendor.Name
                ELSE
                    "Transport Name" := '';
            end;
        }
    }
}

