pageextension 50525 "Vat Entires" extends "VAT Entries"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {

            field("VAT Base 1"; Rec."VAT Base 1")
            {
                ToolTip = 'Specifies the value of the VAT Base Amt 13% field.';
                ApplicationArea = All;
            }
            field("Exempt Amount"; Rec."Exempt Amount")
            {
                ToolTip = 'Specifies the value of the Vat Base Amt 0% field.';
                ApplicationArea = All;
            }

        }
        addafter("EU Service")
        {

            field("External Document No."; Rec."External Document No.")
            {
                ToolTip = 'Specifies the value of the External Document No. field.';
                ApplicationArea = All;
            }
            field(PragyapanPatra; Rec.PragyapanPatra)
            {
                ToolTip = 'Specifies the value of the PragyapanPatra field.';
                ApplicationArea = All;
            }
            field("Letter of Credit/Telex Trans."; Rec."Letter of Credit/Telex Trans.")
            {
                ToolTip = 'Specifies the value of the Letter of Credit/Telex Trans. field.';
                ApplicationArea = All;
            }
            field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
            {
                ToolTip = 'Specifies the value of the Localized VAT Identifier field.';
                ApplicationArea = All;
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ToolTip = 'Specifies the value of the RBI Product Code field.';
                ApplicationArea = All;
            }
            field("Free Item Vendor No."; Rec."Free Item Vendor No.")
            {
                ToolTip = 'Specifies the value of the Free Item Vendor No. field.';
                ApplicationArea = All;
            }
            field("Free Item Vendor Name"; Rec."Free Item Vendor Name")
            {
                ToolTip = 'Specifies the value of the Free Item Vendor Name field.';
                ApplicationArea = All;
            }
            field("Exclude PP in VAT Book"; Rec."Exclude PP in VAT Book")
            {
                ToolTip = 'Specifies the value of the Exclude PP in VAT Book field.';
                ApplicationArea = All;
                Visible = false;
            }

        }

    }


    actions
    {
        // Add changes to page actions here
        addafter(IncomingDocAttachFile)
        {
            action("Old Vat")
            {
                // RunObject=Report 50029; //Report is missing
                Promoted = true;
                PromotedIsBig = true;
                Image = Calculate;
                PromotedCategory = Process;
            }
            action("New Vat")
            {
                //RunObject=Report 50095; //Report is mising
                Promoted = true;
                PromotedIsBig = true;
                Image = Calculate;
                PromotedCategory = Process;
            }
            action("Vat Entries")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = process;
                trigger OnAction()
                begin
                    PAGE.RUN(50024);
                end;
            }
        }
    }

    var
        myInt: Integer;
}