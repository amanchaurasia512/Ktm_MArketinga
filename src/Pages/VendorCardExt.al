pageextension 50523 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        modify("Post Code")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }

        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify(Receiving)
        {
            Visible = false;
        }
        modify("Block Payment Tolerance")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        { Visible = false; }
        modify("Our Account No.")
        { Visible = false; }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify("Partner Type")
        { Visible = false; }
        modify("Prepayment %")
        {
            Visible = false;
        }
        modify("Invoice Disc. Code")
        { Visible = false; }
        addafter(Name)
        {
            field("Name2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }

        }
        addafter("Search Name")
        {
            field("TDS Balance (Open)"; Rec."TDS Balance (Open)")
            {
                CaptionML = ENU = 'TDS Balnce';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Vendor Posting Group")
        {  //already there
            // field("Application Method";"Application Method")
            // {
            //     ApplicationArea = All;
            // }
            // field("Currency Code";"Currency Code")
            // {
            //     ApplicationArea = All;
            // }
            field("Pragyapan Patra Mandatory"; Rec."Pragyapan Patra Mandatory")
            {
                ApplicationArea = All;
            }
            field("Applicable Item Charges"; Rec."Applicable Item Charges")
            {
                ToolTip = 'Specifies the value of the Applicable Item Charges field.';
                ApplicationArea = All;
            }
            field("Also Customer"; Rec."Also Customer")
            {
                ToolTip = 'Specifies the value of the Also Customer field.';
                ApplicationArea = All;
            }
            group(Communication)
            {
                Visible = false;
                CaptionML = ENU = 'Communcation';
                //already there
                // field("Phone No."; "Phone No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Home Page"; "Home Page")
                // {
                //     ApplicationArea = All;
                // }
                // field("IC Partner Code"; "IC Partner Code")
                // {
                //     ApplicationArea = All;
                // }

            }
            Group(Invoicings)
            {
                Visible = false;
                CaptionML = ENU = 'Invoicing';
                //already there
                // field("Pay-to Vendor No."; "Pay-to Vendor No.")
                // {
                //     ApplicationArea = All;
                // }
                // field(GLN; GLN)
                // {
                //     ApplicationArea = All;
                // }

            }
        }
        addafter("Language Code")
        {
            group(IRD)
            {
                Visible = false;
                field("Consigment No. Mandatory"; Rec."Consigment No. Mandatory")
                {
                    ApplicationArea = All;
                }

            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Ledger E&ntries")
        {
            action("To Cust-Vend Ledger Entries")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = Copy;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    CustVendLedgEntry: Record "Cust-Vend Ledger";
                    LastEntryNo: Integer;
                    Text001: TextConst ENU = 'Check the Also Customer Field to perform this action';
                    Text002: TextConst ENU = 'Is this Vendor present in the Customer?';
                    Text003: TextConst ENU = 'Do you want to proceed?';
                begin
                    IF NOT Rec."Also Customer" THEN
                        ERROR(Text001);

                    IF CONFIRM(Text002, TRUE) THEN BEGIN
                        IF CONFIRM(Text003, TRUE) THEN BEGIN
                            LastEntryNo := 0;
                            IF Rec."Also Customer" THEN BEGIN
                                CustVendLedgEntry.RESET;
                                IF CustVendLedgEntry.FINDLAST THEN
                                    LastEntryNo := CustVendLedgEntry."Entry No.";
                                VendLedgEntry.RESET;
                                VendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                                IF VendLedgEntry.FINDFIRST THEN
                                    REPEAT
                                        CustVendLedgEntry.RESET;
                                        CustVendLedgEntry.SETRANGE("Entry No. From Vend Ledger", VendLedgEntry."Entry No.");
                                        IF NOT CustVendLedgEntry.FINDFIRST THEN BEGIN
                                            LastEntryNo += 1;
                                            CustVendLedgEntry.INIT;
                                            CustVendLedgEntry."Entry No." := LastEntryNo;
                                            CustVendLedgEntry.CopyFromVendLedgEntry(VendLedgEntry);
                                            CustVendLedgEntry.INSERT(TRUE);
                                        END;
                                    UNTIL VendLedgEntry.NEXT = 0;
                                MESSAGE('Task Performed Successfully');
                            END;
                        END;
                    END;
                end;
            }
        }
    }

    var
        myInt: Integer;
}