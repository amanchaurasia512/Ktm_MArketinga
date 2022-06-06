pageextension 50532 "Sales & Recv Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Default Posting Date")
        {
            field("Skip Product Group Check"; Rec."Skip Product Group Check")
            {
                CaptionML = ENU = 'Skip same Product Group';
                ApplicationArea = All;
            }
        }
        addbefore("Check Prepmt. when Posting")
        {
            field("Show Description From"; Rec."Show Description From")
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Debit Mandate Nos.")
        {
            group("Customer BG Reminder")
            {

                field("Sender Name"; Rec."Sender Name")
                {
                    ToolTip = 'Specifies the value of the Sender Name field.';
                    ApplicationArea = All;
                }
                field("First Reminder Days"; Rec."First Reminder Days")
                {
                    ToolTip = 'Specifies the value of the First Reminder Days field.';
                    ApplicationArea = All;
                }
                field("Second Reminder Days"; Rec."Second Reminder Days")
                {
                    ToolTip = 'Specifies the value of the Second Reminder Days field.';
                    ApplicationArea = All;
                }
                field("Third Reminder Days"; Rec."Third Reminder Days")
                {
                    ToolTip = 'Specifies the value of the Third Reminder Days field.';
                    ApplicationArea = All;
                }
                field("First Reminder Email"; Rec."First Reminder Email")
                {
                    ToolTip = 'Specifies the value of the First Reminder Email field.';
                    ApplicationArea = All;
                }
                field("Second Reminder Email"; Rec."Second Reminder Email")
                {
                    ToolTip = 'Specifies the value of the Second Reminder Email field.';
                    ApplicationArea = All;
                }
                field("Third Reminder Email"; Rec."Third Reminder Email")
                {
                    ToolTip = 'Specifies the value of the Third Reminder Email field.';
                    ApplicationArea = All;
                }
                field("Populate Damage Location"; Rec."Populate Damage Location")
                {
                    ToolTip = 'Specifies the value of the Populate Damage Location field.';
                    ApplicationArea = All;
                }
                field("Damage Location"; Rec."Damage Location")
                {
                    ToolTip = 'Specifies the value of the Damage Location field.';
                    ApplicationArea = All;
                }
                field("Restrict Invoicing from Damage"; Rec."Restrict Invoicing from Damage")
                {
                    ToolTip = 'Specifies the value of the Restrict Invoicing from Damage field.';
                    ApplicationArea = All;
                    CaptionML = ENU = 'Restrict Invoicing from Damage Location';
                }
                field("Default Transfer-from Code"; Rec."Default Transfer-from Code")
                {
                    ToolTip = 'Specifies the value of the Default Transfer-from Code field.';
                    ApplicationArea = All;
                }
                field("Default Transfer-to Code"; Rec."Default Transfer-to Code")
                {
                    ToolTip = 'Specifies the value of the Default Transfer-to Code field.';
                    ApplicationArea = All;
                }
                field("Default Item Jnl. Template"; Rec."Default Item Jnl. Template")
                {
                    ToolTip = 'Specifies the value of the Default Item Jnl. Template field.';
                    ApplicationArea = All;
                }
                field("Default Item Jnl. Batch"; Rec."Default Item Jnl. Batch")
                {
                    ToolTip = 'Specifies the value of the Default Item Jnl. Batch field.';
                    ApplicationArea = All;
                }
            }

        }
        addafter("Job Queue Category Code")
        {
            field("Apply Cust. Ledg. Dim. Wise"; Rec."Apply Cust. Ledg. Dim. Wise")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}