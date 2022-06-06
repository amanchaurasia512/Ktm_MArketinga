pageextension 50516 "Posted Purchase Invoices Ext" extends "Posted Purchase Invoices"
{

    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            //already there
            // field("Posting Date";"Posting Date")
            // {
            //     ApplicationArea = All;
            // }    
        }
        addafter("Order Address Code")
        {

            //already defined
            // field("Order No."; "Order No.")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Location Code")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Purchase Consignment No."; Rec."Purchase Consignment No.")
            {
                ApplicationArea = All;
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = All;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = All;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ApplicationArea = All;
            }
            field(Delete; Rec.Delete)
            {
                ApplicationArea = All;
            }
            //already defined
            //     field("Vendor Invoice No."; "Vendor Invoice No.")
            //     {
            //         ApplicationArea = All;
            //    }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}