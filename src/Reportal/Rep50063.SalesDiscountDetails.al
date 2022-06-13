report 50063 "Sales Discount Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SalesDiscountDetails.rdlc';

    dataset
    {
        dataitem("Value Entry";"Value Entry")
        {
            DataItemTableView = WHERE ("Item Ledger Entry Type"=FILTER(Sale),
                                      "Discount Amount"=FILTER(<>0));
            RequestFilterFields = "Posting Date","Item No.","Gen. Prod. Posting Group";
            column(AllFilters;AllFilters)
            {
            }
            column(ItemLedgerEntryType_ValueEntry;"Value Entry"."Item Ledger Entry Type")
            {
            }
            column(ItemNo_ValueEntry;"Value Entry"."Item No.")
            {
            }
            column(GenProdPostingGroup_ValueEntry;"Value Entry"."Gen. Prod. Posting Group")
            {
            }
            column(PostingDate_ValueEntry;FORMAT("Value Entry"."Posting Date"))
            {
            }
            column(DocumentNo_ValueEntry;"Value Entry"."Document No.")
            {
            }
            column(DocumentType_ValueEntry;"Value Entry"."Document Type")
            {
            }
            column(ItemName_ValueEntry;"Value Entry"."Item Name")
            {
            }
            column(InvoicedQuantity_ValueEntry;"Value Entry"."Invoiced Quantity")
            {
            }
            column(SalesAmountActual_ValueEntry;"Value Entry"."Sales Amount (Actual)")
            {
            }
            column(DiscountAmount_ValueEntry;"Value Entry"."Discount Amount")
            {
            }
            column(CostPostedtoGL_ValueEntry;"Value Entry"."Cost Posted to G/L")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Value Entry"."Invoiced Quantity" := -"Value Entry"."Invoiced Quantity";
                "Value Entry"."Cost Posted to G/L" := -"Value Entry"."Cost Posted to G/L";
                "Value Entry"."Discount Amount" := -"Value Entry"."Discount Amount";
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
        AllFilters := "Value Entry".GETFILTERS;
    end;

    var
        AllFilters: Text;
}

