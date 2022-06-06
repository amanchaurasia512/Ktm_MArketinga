pageextension 50512 "Posted Sales Cr Memo Ext " extends "Posted Sales Credit Memo" //OriginalId
{
    Editable = false;

    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }

        addafter("Bill-to Contact")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        addafter(Approvals)
        {
            action("Create Transfer Order")
            {
                Promoted = true;
                Visible = true;
                PromotedIsBig = true;
                Image = CreateDocument;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    IRDMgt: Codeunit "IRD Mgt.";
                BEGIN
                    IF NOT CONFIRM('Do you want to create transfer order for credit memo %1?', FALSE, Rec."No.") THEN
                        EXIT;
                    IRDMgt.CreateTransferFromSalesCreditMemo(Rec);
                end;
            }
        }
        addafter(Print)
        {
            action("Old Print")
            {
                CaptionML = ENU = 'Old Print';
                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", Rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN
                        REPORT.RUN(50099, TRUE, TRUE, SalesCrMemoHeader);
                end;
            }
        }
    }
}