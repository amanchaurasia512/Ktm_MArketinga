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
            field("User ID"; "User ID")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Purchase Consignment No."; "Purchase Consignment No.")
            {
                ApplicationArea = All;
            }
            field("Letter of Credit/Telex Trans."; "Letter of Credit/Telex Trans.")
            {
                ApplicationArea = All;
            }
            field(PragyapanPatra; PragyapanPatra)
            {
                ApplicationArea = All;
            }
            field("Party Type"; "Party Type")
            {
                ApplicationArea = All;
            }
            field("Nepali Date"; "Nepali Date")
            {
                ApplicationArea = All;
            }
            field(Delete; Delete)
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