page 50005 "Document Class Master List"
{
    PageType = List;
    SourceTable = "Document Class Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Doc. Class Type"; Rec."Doc. Class Type")
                {
                    ApplicationArea = all;
                }
                field("Doc. Class No."; Rec."Doc. Class No.")
                {
                    ApplicationArea = all;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = all;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = all;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Purchases Invoices")
            {
                Image = Invoice;

                trigger OnAction()
                begin
                    PurchaseInvoices.RESET;

                    IF Rec."Doc. Class Type" = Rec."Doc. Class Type"::PragyapanPatra THEN BEGIN
                        PurchaseInvoices.SETRANGE(PragyapanPatra, Rec."Doc. Class No.");
                        IF PurchaseInvoices.FINDFIRST THEN BEGIN
                            PostedPurchaseInvoice.SETTABLEVIEW(PurchaseInvoices);
                            PostedPurchaseInvoice.RUN;
                        END;
                    END
                    ELSE
                        IF Rec."Doc. Class Type" = Rec."Doc. Class Type"::"Letter of Credit/Telex Transfer" THEN BEGIN
                            PurchaseInvoices.SETRANGE("Letter of Credit/Telex Trans.", Rec."Doc. Class No.");
                            IF PurchaseInvoices.FINDFIRST THEN BEGIN
                                PostedPurchaseInvoice.SETTABLEVIEW(PurchaseInvoices);
                                PostedPurchaseInvoice.RUN;
                            END;
                        END;
                end;
            }
        }
    }

    var
        PurchaseInvoices: Record "Purch. Inv. Header";
        PostedPurchaseInvoice: Page "Posted Purchase Invoice";
}

