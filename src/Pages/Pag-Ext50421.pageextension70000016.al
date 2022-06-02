pageextension 50421 "pageextension70000016" extends "Posted Purch. Invoice Subform"
{

    //Unsupported feature: Property Insertion (Permissions) on ""Posted Purch. Invoice Subform"(Page 139)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "FilteredTypeField(Control 37)".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 15".


        //Unsupported feature: Property Deletion (Name) on "FilteredTypeField(Control 37)".


        //Unsupported feature: Property Deletion (CaptionML) on "FilteredTypeField(Control 37)".


        //Unsupported feature: Property Deletion (ToolTipML) on "FilteredTypeField(Control 37)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "FilteredTypeField(Control 37)".


        //Unsupported feature: Property Deletion (Visible) on "FilteredTypeField(Control 37)".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 15".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 15".


        //Unsupported feature: Property Deletion (Visible) on "Control 15".

        addlast(content)
        {
            field("VAT Base 1"; Rec."VAT Base 1")
            {
                ApplicationArea = all;
            }
            field("Exempt Amount"; Rec."Exempt Amount")
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
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = all;
            }
            field("RBI Product Code"; Rec."RBI Product Code")
            {
                ApplicationArea = all;
            }
            field("TDS Group"; Rec."TDS Group")
            {
                ApplicationArea = all;
            }
            field("TDS%"; Rec."TDS%")
            {
                ApplicationArea = all;
            }
            field("TDS Type"; Rec."TDS Type")
            {
                ApplicationArea = all;
            }
            // field(FilteredTypeField; FormatType)
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Type';
            //     ToolTip = 'Specifies the type of transaction that was posted with the line.';
            //     //Visible = IsFoundation;
            // }
        }
        // addafter("Control 34")
        // {
        //     field("Job Task No."; "Job Task No.") // filed is already defined 
        //     {
        //         ApplicationArea = Jobs;
        //         ToolTip = 'Specifies the number of the related job task.';
        //         Visible = false;
        //     }
        // }


        addafter(FilteredTypeField)
        {
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
                ApplicationArea = all;

            }
        }
        // moveafter("Control 2"; "Control 4")
        // moveafter("Control 34"; "Control 20")
        // moveafter("Control 36"; "Control 15")
        // moveafter("Control 15"; "Control 11")
    }
    actions
    {
        addafter(DocAttach)
        {
            action("VAT Identifier Correction")
            {
                Image = Correct;

                trigger OnAction()
                begin
                    PurchInvLine.RESET;
                    PurchInvLine.SETRANGE("Document No.", Rec."Document No.");
                    PurchInvLine.SETRANGE("Line No.", Rec."Line No.");
                    IF PurchInvLine.FINDFIRST THEN
                        REPORT.RUNMODAL(50096, TRUE, TRUE, PurchInvLine);
                end;
            }
        }
    }

    var
        PurchInvLine: Record "Purch. Inv. Line";
}

