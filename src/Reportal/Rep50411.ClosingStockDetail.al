report 50411 "Closing Stock Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ClosingStockDetail.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Inventory Posting Group", "Sub-Category", "Date Filter";
            column(CompanyName; CompanyRec.Name)
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(InventoryPostingGroup_Item; Item."Inventory Posting Group")
            {
            }
            column(filters; Filters)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                column(PostingDate_ItemLedgerEntry; FORMAT("Item Ledger Entry"."Posting Date"))
                {
                }
                column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
                {
                }
                column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
                {
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                }
                column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
                {
                }
                column(InvoicedQuantity_ItemLedgerEntry; "Item Ledger Entry"."Invoiced Quantity")
                {
                }
                column(CostAmountExpected_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Expected)")
                {
                }
                column(CostAmountActual_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Actual)")
                {
                }
                column(CostAmountNonInvtbl_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Non-Invtbl.)")
                {
                }
                column(CostAmountExpectedACY_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Expected) (ACY)")
                {
                }
                column(CostAmountActualACY_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Actual) (ACY)")
                {
                }
                column(CostAmountNonInvtblACY_ItemLedgerEntry; "Item Ledger Entry"."Cost Amount (Non-Invtbl.)(ACY)")
                {
                }
                column(Rate; Rate)
                {
                }
                column(InvoiceAmountofRemaining; InvoiceAmountofRemaining)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //IF "Remaining Quantity" =0 THEN
                    //  CurrReport.SKIP;

                    CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");

                    IF "Invoiced Quantity" <> 0 THEN
                        Rate := ("Cost Amount (Actual)" + "Item Ledger Entry"."Cost Amount (Expected)") / "Item Ledger Entry".Quantity;

                    //MESSAGE(FORMAT("Item Ledger Entry"."Remaining Quantity"));
                end;

                trigger OnPreDataItem()
                begin
                    SETFILTER("Posting Date", Item.GETFILTER("Date Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS(Inventory);

                IF Inventory = 0 THEN
                    ;//  CurrReport .SKIP;
                //MESSAGE(FORMAT(Inventory));
                ItemLedgerRec.RESET;
                ItemLedgerRec.SETRANGE("Item No.", "No.");
                ItemLedgerRec.SETFILTER("Posting Date", GETFILTER("Date Filter"));
                ItemLedgerRec.CALCSUMS(Quantity);
                IF ItemLedgerRec.Quantity = 0 THEN
                    CurrReport.SKIP;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyRec.GET;
        Filters := Item.GETFILTERS;
    end;

    var
        CompanyRec: Record "Company Information";
        Filters: Text;
        Rate: Decimal;
        InvoiceAmountofRemaining: Decimal;
        ItemLedgerRec: Record "Item Ledger Entry";
}

