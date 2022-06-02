pageextension 50428 "pageextension70000027" extends "G/L Account Card"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 11".


        //Unsupported feature: Property Modification (SourceExpr) on "SubCategoryDescription(Control 13)".

        // modify("Control 11.OnLookup")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 11".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 11".

        // modify(SubCategoryDescription)
        // {
        //     Visible = false;
        // }
        // modify(SubCategoryDescription)
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (Name) on "SubCategoryDescription(Control 13)".


        //Unsupported feature: Property Deletion (CaptionML) on "SubCategoryDescription(Control 13)".


        //Unsupported feature: Property Deletion (ToolTipML) on "SubCategoryDescription(Control 13)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "SubCategoryDescription(Control 13)".

        addlast(content)
        {
            //field("Account Category"; "Account Category")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the category of the G/L account.';

            //     trigger OnLookup(var Text: Text): Boolean
            //     begin
            //         //UpdateAccountSubcategoryDescription;
            //     end;
            //}
            // field(SubCategoryDescription; SubCategoryDescription)  // already defined everything in base page
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Account Subcategory';
            //     ToolTip = 'Specifies the subcategory of the account category of the G/L account.';

            //     trigger OnLookup(var Text: Text): Boolean
            //     begin
            //         LookupAccountSubCategory;
            //         UpdateAccountSubcategoryDescription;
            //     end;

            //     trigger OnValidate()
            //     begin
            //         ValidateAccountSubCategory(SubCategoryDescription);
            //         UpdateAccountSubcategoryDescription;
            //     end;
            // }
            field("Demand loan code Mandatory"; Rec."Demand loan code Mandatory")
            {
                ApplicationArea = all;
            }
            field("LC Code Mandatory"; Rec."LC Code Mandatory")
            {
                ApplicationArea = all;
            }
        }

        //moveafter("Control 6"; "Control 8")
    }
}

