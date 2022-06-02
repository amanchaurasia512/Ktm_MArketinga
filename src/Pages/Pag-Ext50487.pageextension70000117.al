pageextension 50487 "pageextension70000117" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        // modify(FilteredTypeField)
        // {

        //     //Unsupported feature: Property Modification (SourceExpr) on "FilteredTypeField(Control 29)".

        //     Visible = false;
        // }


        //Unsupported feature: Property Deletion (Name) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (CaptionML) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (ToolTipML) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (TableRelation) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (Editable) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (LookupPageID) on "FilteredTypeField(Control 29)".

        // modify("Control 52")
        // {
        //     Visible = false;
        // }
        // modify("Control 50.OnValidate")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (Visible) on "Control 50".

        // addafter("FA Posting Type")
        // {
        //     field(FilteredTypeField; TypeAsText) //already defined
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Type';
        //         Editable = CurrPageIsEditable;
        //         LookupPageID = "Option Lookup List";
        //         TableRelation = "Option Lookup Buffer"."Option Caption" WHERE(Lookup Type=CONST(Purchases));
        //         ToolTip = 'Specifies the type of transaction that will be posted with the document line. If you select Comment, then you can enter any text in the Description field, such as a message to a customer. ';
        //         Visible = IsFoundation;

        //         trigger OnValidate()
        //         begin
        //             TempOptionLookupBuffer.SetCurrentType(Type);
        //             IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText, TempOptionLookupBuffer."Lookup Type"::Sales) THEN
        //                 VALIDATE(Type, TempOptionLookupBuffer.ID);
        //             TempOptionLookupBuffer.ValidateOption(TypeAsText);
        //             UpdateEditableOnRow;
        //             UpdateTypeText;
        //             DeltaUpdateTotals;
        //         end;
        //     }
        // }
        addafter("Total Amount Excl. VAT")
        {
            // field("Line Discount Amount"; "Line Discount Amount") //already define
            // {
            //     ApplicationArea = Basic, Suite;
            //     BlankZero = true;
            //     Editable = NOT IsCommentLine;
            //     Enabled = NOT IsCommentLine;
            //     ToolTip = 'Specifies the discount amount that is granted for the item on the line.';

            //     trigger OnValidate()
            //     begin
            //         DeltaUpdateTotals;
            //     end;
        }

        addafter("Line Discount %")
        {
            field("VAT Base 1"; Rec."VAT Base 1")
            {
                ApplicationArea = all;
            }
            field("Exempt Amount"; Rec."Exempt Amount")
            {
                ApplicationArea = all;
            }
        }
        // moveafter("Control 2"; "Control 4")
    }
}

