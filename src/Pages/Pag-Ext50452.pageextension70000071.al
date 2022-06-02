pageextension 50452 "pageextension70000071" extends "Purch. Invoice Subform"
{
    layout
    {
        addlast(content)
        {
            field("FA Item Charge"; Rec."FA Item Charge")
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
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Party No."; Rec."Party No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ApplicationArea = all;
            }
        }

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Item; //KMT2016CU5
        UpdateTypeText;
    end;


}

