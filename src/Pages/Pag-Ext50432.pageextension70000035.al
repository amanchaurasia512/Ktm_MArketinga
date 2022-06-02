pageextension 50432 "pageextension70000035" extends "Purchase Journal"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 27".

        // modify(ShortcutDimCode6)
        // {

        //     //Unsupported feature: Property Modification (SourceExpr) on "ShortcutDimCode6(Control 35)".

        //     Visible = true;
        // }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 27".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 27".


        //Unsupported feature: Property Deletion (Visible) on "Control 27".

        // modify("Control 69")
        // {
        //     Visible = false;
        // }
        // modify("Control 73")
        // {
        //     Visible = false;
        // }
        // modify("Control 20")
        // {
        //     Visible = false;
        // }
        // modify("Control 22")
        // {
        //     Visible = false;
        // }
        // modify("Control 75")
        // {
        //     Visible = false;
        // }
        // modify("Control 77")
        // {
        //     Visible = false;
        // }
        // modify("Control 24")
        // {
        //     Visible = false;
        // }
        // modify("Control 26")
        // {
        //     Visible = false;
        // }
        // modify("Control 71")
        // {
        //     Visible = false;
        // }
        // modify("Control 51")
        // {
        //     Visible = false;
        // }
        // modify("Control 79")
        // {
        //     Visible = false;
        // }
        // modify("Control 3")
        // {
        //     Visible = false;
        // }
        modify(ShortcutDimCode6)
        {
            Visible = false;  //in above code visible is true
        }

        //Unsupported feature: Property Deletion (Name) on "ShortcutDimCode6(Control 35)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "ShortcutDimCode6(Control 35)".


        //Unsupported feature: Property Deletion (CaptionClass) on "ShortcutDimCode6(Control 35)".


        //Unsupported feature: Property Deletion (TableRelation) on "ShortcutDimCode6(Control 35)".

        addlast(content)
        {
            field("Amount(LCY)"; Rec."Amount (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the total amount in local currency (including VAT) that the journal line consists of.';
                // Visible = AmountVisible;
            }
            field("Sales/Purch.(LCY)"; Rec."Sales/Purch. (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the line''s net amount (the amount excluding VAT) if you are using this journal line for an invoice.';
                Visible = false;
            }
            field("Inv. Discount(LCY)"; Rec."Inv. Discount (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the amount of the invoice discount if you are using this journal line for an invoice.';
                Visible = false;
            }
            field("PaymentTermsCode"; Rec."Payment Terms Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                Visible = false;
            }
            field("Due Date_ktm"; Rec."Due Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the due date on the entry.';
                Visible = false;
            }
            field("Pmt. Discount Date_ktm"; Rec."Pmt. Discount Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                Visible = false;
            }
            field("Payment Discount %_ktm"; Rec."Payment Discount %")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                Visible = false;
            }
            // field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type") //already defined
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
            //     //Visible = NOT IsSimplePage;
            // }
            field("Applies-to Doc.No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                //Visible = NOT IsSimplePage;
            }
            field("Applies-toID"; Rec."Applies-to ID")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
                Visible = false;
            }
            field("OnHold"; Rec."On Hold")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.';
            }
            field("ReasonCode"; Rec."Reason Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                Visible = false;
            }

            field("Comment_ktm"; Rec.Comment)
            {
                ApplicationArea = Comments;
                ToolTip = 'Specifies a comment about the activity on the journal line. Note that the comment is not carried forward to posted entries.';
                Visible = false;
            }
            //  field(ShortcutDimCode6; ShortcutDimCode[6]) //cannot modified the and code in same page
            // {
            //     ApplicationArea = Dimensions;
            //     CaptionClass = '1,2,6';
            //     TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
            //                                                   Dimension Value Type=CONST(Standard),
            //                                                   Blocked=CONST(No));
            //     Visible = DimVisible6;

            //     trigger OnValidate()
            //     begin
            //         ValidateShortcutDimCode(6, ShortcutDimCode[6]);

            //         OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 6);
            //     end;
            // }
        }
        // moveafter("Control 18"; "Control 1000")
        // moveafter(ShortcutDimCode5; ShortcutDimCode7)
        // moveafter(ShortcutDimCode8; ShortcutDimCode6)
    }
}

