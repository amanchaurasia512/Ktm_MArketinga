page 50006 "Product&Salesperson Posting Gr"
{
    PageType = List;
    SourceTable = "Product&Salesperson Posting Gr";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Product Segment Code"; Rec."Product Segment Code")
                {
                    ApplicationArea = all;
                }
                field("Area Code"; Rec."Area Code")
                {
                    ApplicationArea = all;
                }
                field("Current Salesperson"; Rec."Current Salesperson")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("New Area Code"; Rec."New Area Code")
                {
                    ApplicationArea = all;
                }
                field("Region Code"; Rec."Region Code")
                {
                    ApplicationArea = all;
                }
                field("State Code"; Rec."State Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Salesperson Update")
            {
                Image = PersonInCharge;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    //UpdateSalesPerson: Report "50073";
                    ProductSalesperson: Record "Product&Salesperson Posting Gr";
                    IsUpdated: Boolean;
                    NewAreaCode: Code[20];
                    NewRegionCode: Code[20];
                begin
                    IF NOT CONFIRM('Do you want to proceed?', FALSE) THEN
                        EXIT;
                    CurrPage.SETSELECTIONFILTER(ProductSalesperson);
                    NewAreaCode := '';
                    IF ProductSalesperson.FINDSET THEN
                        REPEAT
                            ProductSalesperson.TESTFIELD("New Area Code");
                            //UpdateSalesPerson.SalesPersonUpdate(ProductSalesperson."Product Segment Code", ProductSalesperson."Customer No.", ProductSalesperson."Area Code", ProductSalesperson."New Area Code", IsUpdated);
                            IF IsUpdated THEN BEGIN
                                NewAreaCode := ProductSalesperson."New Area Code";
                                NewRegionCode := ProductSalesperson."New Region Code";
                                ProductSalesperson."New Area Code" := '';
                                ProductSalesperson."New Region Code" := '';
                                ProductSalesperson.RENAME(ProductSalesperson."Customer No.", ProductSalesperson."Product Segment Code",
                                                        ProductSalesperson."Inventory Posting Group", NewAreaCode);
                                MESSAGE('Salesperson has been updated for %1 with new salesperson code %2', ProductSalesperson.RECORDID, NewAreaCode);
                            END;
                        UNTIL ProductSalesperson.NEXT = 0;
                end;
            }
        }
    }
}

