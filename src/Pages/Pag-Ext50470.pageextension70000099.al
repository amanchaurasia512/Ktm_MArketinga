pageextension 50470 "pageextension70000099" extends "Purchase Return Order Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "FilteredTypeField(Control 29)".

        // modify(FilteredTypeField)
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (Name) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (CaptionML) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (ToolTipML) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (TableRelation) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (Visible) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (Editable) on "FilteredTypeField(Control 29)".


        //Unsupported feature: Property Deletion (LookupPageID) on "FilteredTypeField(Control 29)".

        addlast(content)
        {
            // field(FilteredTypeField; TypeAsText)
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Type';
            //     Editable = CurrPageIsEditable;
            //     LookupPageID = "Option Lookup List";
            //     TableRelation = "Option Lookup Buffer"."Option Caption" WHERE(Lookup Type=CONST(Purchases));
            //     ToolTip = 'Specifies the type of transaction that will be posted with the document line. If you select Comment, then you can enter any text in the Description field, such as a message to a customer. ';
            //     Visible = IsFoundation;

            //     trigger OnValidate()
            //     begin
            //         TempOptionLookupBuffer.SetCurrentType(Type);
            //         IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText, TempOptionLookupBuffer."Lookup Type"::Purchases) THEN
            //             VALIDATE(Type, TempOptionLookupBuffer.ID);
            //         TempOptionLookupBuffer.ValidateOption(TypeAsText);
            //         UpdateEditableOnRow;
            //         UpdateTypeText;
            //         DeltaUpdateTotals;
            //     end;
            // }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
        }

        //moveafter("Control 2"; "Control 4")
    }
}

