pageextension 50427 "pageextension70000026" extends "Chart of Accounts"
{

    //Unsupported feature: Property Insertion (Permissions) on ""Chart of Accounts"(Page 16)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 16".

        // modify("Control 18")
        // {
        //     Visible = false;
        // }

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 16".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 16".

        // modify("Control 9")
        // {
        //     Visible = false;
        // }
        // modify("Control 11")
        // {
        //     Visible = false;
        // }
        addlast(content)
        {
            // field(Balance; Balance)
            // {
            //     ApplicationArea = Basic, Suite;
            //     BlankZero = true;
            //     ToolTip = 'Specifies the balance on this account.';
            // }
            // field("Account Category"; "Account Category")
            // {
            //     ApplicationArea = Basic, Suite;
            //     ToolTip = 'Specifies the category of the G/L account.';
            //     Visible = false;
            // }
            // field("Account Subcategory Descript."; "Account Subcategory Descript.")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Account Subcategory';
            //     DrillDown = false;
            //     ToolTip = 'Specifies the subcategory of the account category of the G/L account.';
            // }
        }

        // moveafter("Control 4"; "Control 6")
    }
    actions
    {

        modify(SetDimensionFilter)
        {
            trigger OnAfterAction()
            begin
                GLEntry.SETRANGE("G/L Account No.", '2262100');
                GLEntry.SETFILTER("Localized VAT Identifier", '%1|%2',
                GLEntry."Localized VAT Identifier"::"Taxable Import Purchase", GLEntry."Localized VAT Identifier"::"Exempt Purchase");
                GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
                //GLEntry.SETRANGE("Document No.", 'PPI73/74-00005');
                GLEntry.MODIFYALL("G/L Account No.", '2262200');
                MESSAGE('done.');
            end;
        }
        //Unsupported feature: Property Modification (Level) on "SetDimensionFilter(Action 13)".


        //Unsupported feature: Property Modification (Name) on "SetDimensionFilter(Action 13)".



        //Unsupported feature: Code Insertion (VariableCollection) on ""Update GL"(Action 13).OnAction".

        //trigger (Variable: GLEntry)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;





        //Unsupported feature: Property Deletion (Ellipsis) on "SetDimensionFilter(Action 13)".


        //Unsupported feature: Property Deletion (CaptionML) on "SetDimensionFilter(Action 13)".


        //Unsupported feature: Property Deletion (ToolTipML) on "SetDimensionFilter(Action 13)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "SetDimensionFilter(Action 13)".


        //Unsupported feature: Property Deletion (Image) on "SetDimensionFilter(Action 13)".



        // addlast(Creation)
        // {
        //     action(SetDimensionFilter_ktm)
        //     {
        //         ApplicationArea = Dimensions;
        //         Caption = 'Set Dimension Filter';
        //         Ellipsis = true;
        //         Image = "Filter";
        //         ToolTip = 'Limit the entries according to the dimension filters that you specify. NOTE: If you use a high number of dimension combinations, this function may not work and can result in a message that the SQL server only supports a maximum of 2100 parameters.';

        //         trigger OnAction()
        //         begin
        //             SETFILTER("Dimension Set ID Filter", DimensionSetIDFilter.LookupFilter);
        //         end;
        //     }
        // }
        // moveafter("Action 33"; "Action 23")
    }

    var
        GLEntry: Record "G/L Entry";
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
}

