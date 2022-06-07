report 50073 "Salesperson Change Batch Job"
{
    Permissions = TableData 21 = rm,
                  TableData 32 = rm,
                  TableData 112 = rm,
                  TableData 113 = rm,
                  TableData 114 = rm,
                  TableData 5802 = rm;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group()
                {
                    Visible = false;
                    field("Product Segment Code"; ProductSegment)
                    {
                        TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                    }
                    field("Customer No."; CustNo)
                    {
                        TableRelation = Customer;
                    }
                    field("Area Person"; AreaCode)
                    {
                        TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                    }
                    field("New Area Person"; SalesPerson)
                    {
                        Caption = 'New Area Person';
                        TableRelation = Salesperson/Purchaser;
                    }
                }
            }
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
        //(AssignSalesPersonFromGlobalDim2) function needs to be executed for the very first time
        //because we have to pass all the global dim2 value of the selected records to its salesperson code field
        //AssignSalesPersonFromGlobalDim2;

        ProductSalesperson.RESET;
        ProductSalesperson.SETFILTER("New Area Code",'<>%1','');
        IF NOT JobQueueActive THEN BEGIN
          ProgressWindow.OPEN(Text000);
          ProgressWindow.UPDATE(1,ProductSalesperson.COUNT);
        END;
        IF ProductSalesperson.FINDFIRST THEN REPEAT
          IsUpdated := FALSE;
          ProcessingCount += 1;
          NewAreaCode := '';
          SalesPersonUpdate(ProductSalesperson."Product Segment Code",ProductSalesperson."Customer No.",ProductSalesperson."Area Code",ProductSalesperson."New Area Code",IsUpdated);
          IF IsUpdated THEN BEGIN
            IF ProductSalesperson."New Area Code" <> '' THEN BEGIN
                NewAreaCode := ProductSalesperson."New Area Code";
                ProductSalesperson."New Area Code" := '';
                ProductSalesperson.RENAME(ProductSalesperson."Customer No.",ProductSalesperson."Product Segment Code",
                                        ProductSalesperson."Inventory Posting Group",NewAreaCode);
                COMMIT;
              END;
          END;
          IF NOT JobQueueActive THEN
            ProgressWindow.UPDATE(2,ProcessingCount);
        UNTIL ProductSalesperson.NEXT = 0;
        IF NOT JobQueueActive THEN
          MESSAGE('Executed Successfully');
    end;

    var
        CustNo: Code[20];
        SalesPerson: Code[20];
        ProductSegment: Code[20];
        AreaCode: Code[20];
        ProductSalesperson: Record "50006";
        Text000: Label 'Total Count #1##########\Processing #2############';
        ProgressWindow: Dialog;
        ProcessingCount: Integer;
        IsUpdated: Boolean;
        NewAreaCode: Code[20];

    [Scope('Internal')]
    procedure AssignSalesPersonFromGlobalDim2()
    var
        CustLedgEntry: Record "21";
        ProductwiseSalesPerson: Record "50006";
        ItemLedgEntries: Record "32";
        ValueEntries: Record "5802";
        GLEntry: Record "17";
        SalesInvHdr: Record "112";
        SalesInvLine: Record "113";
        Customer: Record "18";
        SalesCrMemoHdr: Record "114";
        DetailedCustLedgEntry: Record "379";
    begin
        Customer.RESET;
        IF Customer.FINDFIRST THEN REPEAT
          SalesInvHdr.RESET;
          SalesInvHdr.SETRANGE("Sell-to Customer No.",Customer."No.");
          IF SalesInvHdr.FINDFIRST THEN REPEAT
            SalesInvHdr."Salesperson Code" := SalesInvHdr."Shortcut Dimension 2 Code";
            SalesInvHdr.MODIFY;

            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE("Customer No.",Customer."No.");
            CustLedgEntry.SETFILTER("Global Dimension 2 Code",'<>%1','');
            IF CustLedgEntry.FINDFIRST THEN REPEAT
              CustLedgEntry."Salesperson Code" := CustLedgEntry."Global Dimension 2 Code";
              CustLedgEntry.MODIFY;
            UNTIL CustLedgEntry.NEXT = 0;

            ValueEntries.RESET;
            ValueEntries.SETRANGE("Source Type",ValueEntries."Source Type"::Customer);
            ValueEntries.SETRANGE("Source No.",Customer."No.");
            ValueEntries.SETFILTER("Global Dimension 2 Code",'<>%1','');
            IF ValueEntries.FINDFIRST THEN REPEAT
              ValueEntries."Salespers./Purch. Code" := ValueEntries."Global Dimension 2 Code";
              ValueEntries.MODIFY;
              ItemLedgEntries.RESET;
              ItemLedgEntries.SETRANGE("Entry No.",ValueEntries."Item Ledger Entry No.");
              IF ItemLedgEntries.FINDFIRST THEN BEGIN
                ItemLedgEntries."Salespers./Purch. Code" := ItemLedgEntries."Global Dimension 2 Code";
                ItemLedgEntries.MODIFY;
              END;
            UNTIL ValueEntries.NEXT = 0;
          UNTIL SalesInvHdr.NEXT = 0;

          SalesCrMemoHdr.RESET;
          SalesCrMemoHdr.SETRANGE("Sell-to Customer No.",Customer."No.");
          SalesCrMemoHdr.SETRANGE("Shortcut Dimension 2 Code",'<>%1','');
          IF SalesCrMemoHdr.FINDFIRST THEN REPEAT
            SalesCrMemoHdr."Salesperson Code" := SalesCrMemoHdr."Shortcut Dimension 2 Code";
            SalesCrMemoHdr.MODIFY;
          UNTIL SalesCrMemoHdr.NEXT = 0;
        UNTIL Customer.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SalesPersonUpdate(ProductSegmentCode: Code[20];CustomerNo: Code[20];CurrentAreaCode: Code[20];NewAreaCode: Code[20];var Updated: Boolean)
    var
        CustLedgEntry: Record "21";
        ProductwiseSalesPerson: Record "50006";
        ItemLedgEntries: Record "32";
        ValueEntries: Record "5802";
        GLEntry: Record "17";
        SalesInvHdr: Record "112";
        SalesInvLine: Record "113";
        Customer: Record "18";
        SalesCrMemoHdr: Record "114";
    begin
        SalesInvHdr.RESET;
        SalesInvHdr.SETRANGE("Sell-to Customer No.",CustomerNo);
        SalesInvHdr.SETFILTER("Shortcut Dimension 1 Code",ProductSegmentCode);
        SalesInvHdr.SETFILTER("Salesperson Code",CurrentAreaCode);
        SalesInvHdr.MODIFYALL("Salesperson Code",NewAreaCode);

        CustLedgEntry.RESET;
        CustLedgEntry.SETRANGE("Customer No.",CustomerNo);
        CustLedgEntry.SETFILTER("Global Dimension 1 Code",ProductSegmentCode);
        CustLedgEntry.SETRANGE("Salesperson Code",CurrentAreaCode);
        //CustLedgEntry.FINDFIRST;
        CustLedgEntry.MODIFYALL("Salesperson Code",NewAreaCode);

        ItemLedgEntries.RESET;
        ItemLedgEntries.SETRANGE("Source Type",ItemLedgEntries."Source Type"::Customer);
        ItemLedgEntries.SETRANGE("Source No.",CustomerNo);
        ItemLedgEntries.SETRANGE("Global Dimension 1 Code",ProductSegmentCode);
        ItemLedgEntries.SETFILTER("Salespers./Purch. Code",CurrentAreaCode);
        //ItemLedgEntries.FINDFIRST;
        ItemLedgEntries.MODIFYALL("Salespers./Purch. Code",NewAreaCode);

        ValueEntries.RESET;
        ValueEntries.SETRANGE("Source Type",ValueEntries."Source Type"::Customer);
        ValueEntries.SETRANGE("Source No.",CustomerNo);
        ValueEntries.SETRANGE("Global Dimension 1 Code",ProductSegmentCode);
        ValueEntries.SETRANGE("Salespers./Purch. Code",CurrentAreaCode);
        //ValueEntries.FINDFIRST;
        ValueEntries.MODIFYALL("Salespers./Purch. Code",NewAreaCode);

        SalesCrMemoHdr.RESET;
        SalesCrMemoHdr.SETFILTER("Sell-to Customer No.",CustomerNo);
        SalesCrMemoHdr.SETFILTER("Shortcut Dimension 1 Code",ProductSegmentCode);
        SalesCrMemoHdr.SETFILTER("Salesperson Code",CurrentAreaCode);
        //SalesCrMemoHdr.FINDFIRST;
        SalesCrMemoHdr.MODIFYALL("Salesperson Code",NewAreaCode);
        Updated := TRUE;//aakrista
    end;

    local procedure JobQueueActive(): Boolean
    begin
        EXIT(NOT GUIALLOWED);
    end;
}

