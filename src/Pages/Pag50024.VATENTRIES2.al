page 50024 "VAT ENTRIES 2"
{
    PageType = List;
    SourceTable = "VAT Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Base; Rec.Base)
                {
                    ApplicationArea = all;
                }
                field("VAT Base 1"; Rec."VAT Base 1")
                {
                    ApplicationArea = all;
                }
                field("Exempt Amount"; Rec."Exempt Amount")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
            }
            group(general)
            {
                Editable = false;
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(PragyapanPatra; Rec.PragyapanPatra)
                {
                    ApplicationArea = all;
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = all;
                }
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    ApplicationArea = all;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = all;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Internal Ref. No."; Rec."Internal Ref. No.")
                {
                    ApplicationArea = all;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = all;
                }
                field("Unrealized Amount"; Rec."Unrealized Amount")
                {
                    ApplicationArea = all;
                }
                field("Unrealized Base"; Rec."Unrealized Base")
                {
                    ApplicationArea = all;
                }
                field("Remaining Unrealized Amount"; Rec."Remaining Unrealized Amount")
                {
                    ApplicationArea = all;
                }
                field("Remaining Unrealized Base"; Rec."Remaining Unrealized Base")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = all;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = all;
                }
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    ApplicationArea = all;
                }
                field("Tax Group Used"; Rec."Tax Group Used")
                {
                    ApplicationArea = all;
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = all;
                }
                field("Tax on Tax"; Rec."Tax on Tax")
                {
                    ApplicationArea = all;
                }
                field("Sales Tax Connection No."; Rec."Sales Tax Connection No.")
                {
                    ApplicationArea = all;
                }
                field("Unrealized VAT Entry No."; Rec."Unrealized VAT Entry No.")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    ApplicationArea = all;
                }
                field("Additional-Currency Base"; Rec."Additional-Currency Base")
                {
                    ApplicationArea = all;
                }
                field("Add.-Currency Unrealized Amt."; Rec."Add.-Currency Unrealized Amt.")
                {
                    ApplicationArea = all;
                }
                field("Add.-Currency Unrealized Base"; Rec."Add.-Currency Unrealized Base")
                {
                    ApplicationArea = all;
                }
                field("VAT Base Discount %"; Rec."VAT Base Discount %")
                {
                    ApplicationArea = all;
                }
                field("Add.-Curr. Rem. Unreal. Amount"; Rec."Add.-Curr. Rem. Unreal. Amount")
                {
                    ApplicationArea = all;
                }
                field("Add.-Curr. Rem. Unreal. Base"; Rec."Add.-Curr. Rem. Unreal. Base")
                {
                    ApplicationArea = all;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = all;
                }
                field("Add.-Curr. VAT Difference"; Rec."Add.-Curr. VAT Difference")
                {
                    ApplicationArea = all;
                }
                field("Ship-to/Order Address Code"; Rec."Ship-to/Order Address Code")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = all;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = all;
                }
                field("EU Service"; Rec."EU Service")
                {
                    ApplicationArea = all;
                }
                field("Exclude PP in VAT Book"; Rec."Exclude PP in VAT Book")
                {
                    ApplicationArea = all;
                }
                field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
                {
                    ApplicationArea = all;
                }
                field("Purchase Consignment No."; Rec."Purchase Consignment No.")
                {
                    ApplicationArea = all;
                }
                field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
                {
                    ApplicationArea = all;
                }
                field("RBI Product Code"; Rec."RBI Product Code")
                {
                    ApplicationArea = all;
                }
                field("Free Item Vendor No."; Rec."Free Item Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Free Item Vendor Name"; Rec."Free Item Vendor Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}



