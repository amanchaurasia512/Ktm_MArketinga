pageextension 50420 "pageextension70000015" extends "Posted Purchase Invoice"
{
    Editable = false;

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Purchase Invoice"(Page 138)".


    //Unsupported feature: Property Insertion (ModifyAllowed) on ""Posted Purchase Invoice"(Page 138)".

    layout
    {

        //Unsupported feature: Property Modification (Level) on "Control 51".


        //Unsupported feature: Property Modification (Level) on "Control 29".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 29".


        //Unsupported feature: Property Modification (Level) on "Control 6".


        //Unsupported feature: Property Modification (Level) on "Control 100".


        //Unsupported feature: Property Modification (Level) on "Control 58".


        //Unsupported feature: Property Modification (Level) on "Control 54".


        //Unsupported feature: Property Modification (Level) on "Control 78".


        //Unsupported feature: Property Modification (Level) on "Control 64".


        //Unsupported feature: Property Modification (Level) on "Control 102".


        //Unsupported feature: Property Modification (Level) on "Control 28".


        //Unsupported feature: Property Deletion (CaptionML) on "Control 29".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 29".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 29".


        //Unsupported feature: Property Deletion (Importance) on "Control 29".


        //Unsupported feature: Property Deletion (Editable) on "Control 29".

        // modify("Control 35")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            field("Buy-from County_ktm"; Rec."Buy-from County")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'County';
                Editable = false;
                Importance = Additional;
                ToolTip = 'Specifies the state, province or county as a part of the address.';
            }
            field("Buy-from Country/Region Code_ktm"; Rec."Buy-from Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Country/Region';
                Editable = false;
                Importance = Additional;
                ToolTip = 'Specifies the country or region of the ship-to address.';
            }
            field("<VAT Base Amount>"; Rec."VAT Base 1")
            {
                Caption = 'Vat Base Amt 13%';
                Visible = true;
            }
            field("Exempt Amount"; Rec."Exempt Amount")
            {
                ApplicationArea = all;
            }

            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = all;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = all;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = all;
            }
            field("Nepali Date"; Rec."Nepali Date")
            {
                ApplicationArea = all;
            }
        }


        //moveafter("Control 51"; "Control 6")
    }
    actions
    {
        modify(Vendor)
        {

            //Unsupported feature: Property Modification (Name) on "Vendor(Action 37)".

            Caption = 'Localized VAT Identifier Correction';

            //Unsupported feature: Property Modification (Image) on "Vendor(Action 37)".
            // Promoted = true;
            // PromotedCategory = Process;
            // PromotedIsBig = true;
        }

        //Unsupported feature: Property Modification (Level) on ""Update Document"(Action 68)".




        //Unsupported feature: Property Deletion (ShortCutKey) on "Vendor(Action 37)".


        //Unsupported feature: Property Deletion (ToolTipML) on "Vendor(Action 37)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Vendor(Action 37)".


        //Unsupported feature: Property Deletion (RunObject) on "Vendor(Action 37)".


        //Unsupported feature: Property Deletion (RunPageLink) on "Vendor(Action 37)".

        addfirst(Creation)
        {
            action(Vendor_ktm)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = Page 26;
                RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the vendor on the purchase document.';
            }
            action("Update LC")
            {
                Image = Update;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Update LC for Purchase Invoice";
                RunPageLink = "No." = FIELD("No.");
            }
            action("Localized VAT Identifier Correction")
            {
                ApplicationArea = All;
                Image = Update;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PurchInvHeader.RESET;//aakrista
                    PurchInvHeader.SETRANGE("No.", Rec."No.");
                    IF PurchInvHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(50092, TRUE, TRUE, PurchInvHeader);
                end;
            }

        }

        // moveafter("Action 39";Navigate)
    }


    //Unsupported feature: Property Modification (Id) on "PurchInvHeader(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //PurchInvHeader : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PurchInvHeader : 1986;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ApplicationAreaMgmtFacade(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApplicationAreaMgmtFacade : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApplicationAreaMgmtFacade : 1987;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "FormatAddress(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //FormatAddress : 1008;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //FormatAddress : 1988;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "HasIncomingDocument(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //HasIncomingDocument : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //HasIncomingDocument : 1990;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsOfficeAddin(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsOfficeAddin : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsOfficeAddin : 1991;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsFoundationEnabled(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsFoundationEnabled : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsFoundationEnabled : 1992;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsBuyFromCountyVisible(Variable 1007)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsBuyFromCountyVisible : 1007;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsBuyFromCountyVisible : 1993;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsPayToCountyVisible(Variable 1006)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsPayToCountyVisible : 1006;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsPayToCountyVisible : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "IsShipToCountyVisible(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //IsShipToCountyVisible : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //IsShipToCountyVisible : 1995;
    //Variable type has not been exported.

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        PurchInvHeader: Record "Purch. Inv. Header";
}

