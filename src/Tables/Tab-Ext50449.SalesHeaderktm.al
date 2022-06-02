tableextension 50449 "Sales Header_ktm" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                "Sell-to Customer Template Code" := '';
                "Sell-to Customer Name" := Cust.Name;
                "Sell-to Customer Name 2" := Cust."Name 2";
                "Sell-to Address" := Cust.Address;
                "Sell-to Address 2" := Cust."Address 2";
                "Sell-to City" := Cust.City;
                "Sell-to Post Code" := Cust."Post Code";
                "Sell-to County" := Cust.County;
                "Phone No." := Cust."Phone No.";
                "Sell-to Country/Region Code" := Cust."Country/Region Code";
                IF NOT SkipSellToContact THEN
                    "Sell-to Contact" := Cust.Contact;
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "Tax Area Code" := Cust."Tax Area Code";
                "Tax Liable" := Cust."Tax Liable";
                "VAT Registration No." := Cust."VAT Registration No.";
                "VAT Country/Region Code" := Cust."Country/Region Code";
                "Shipping Advice" := Cust."Shipping Advice";
                "Responsibility Center" := UserSetupMgt.GetRespCenter(0, Cust."Responsibility Center");
                VALIDATE("Location Code", UserSetupMgt.GetLocation(0, Cust."Location Code", "Responsibility Center"));
                IF "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                    "Location Code" := 'DHUMBARAHI';   //KMT2016CU5
                "Inventory Posting Group" := '';
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Assigned User ID", USERID);   //KMT2016CU5
                IF "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
                    "Location Code" := 'DHUMBARAHI';   //KMT2016CU5
            end;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                TESTFIELD(Status, Status::Open);
                BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
                SalesSetup.GET;
                UserSetup.GET(USERID);
                GetCust("Bill-to Customer No.");
                IF CustPostingGr.GET(Cust."Customer Posting Group") THEN begin
                    IF (UserSetup."Allow Different Customer Post") AND (CustPostingGr.Claim) THEN
                        BilltoCustomerNoChanged := FALSE
                    ELSE
                        BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
                end;
            end;
        }
        modify("Shortcut Dimension 2 Code")
        {
            trigger OnAfterValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                "Salesperson Code" := "Shortcut Dimension 2 Code";
            end;
        }
        modify("Customer Price Group")
        {
            trigger OnAfterValidate()
            begin
                SalesLineRec.RESET;
                SalesLineRec.SETRANGE("Document Type", "Document Type");
                SalesLineRec.SETRANGE("Document No.", "No.");
                IF SalesLineRec.FINDFIRST THEN
                    REPEAT
                        SalesLineRec.VALIDATE("Customer Price Group", "Customer Price Group");
                        SalesLineRec.MODIFY;
                    UNTIL SalesLineRec.NEXT = 0;
                MessageIfSalesLinesExist(FIELDCAPTION("Customer Price Group"));
            end;
        }

        //Unsupported feature: Code Insertion (VariableCollection) on ""Bill-to Customer No."(Field 4).OnValidate".

        //trigger (Variable: SalesSetup)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;

        //Unsupported feature: Code Insertion (VariableCollection) on ""Customer Price Group"(Field 34).OnValidate".

        //trigger (Variable: SalesLineRec)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;

        field(50000; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Product Code';
            TableRelation = "Inventory Posting Group";

            trigger OnValidate()
            begin
                ValidateSalepersonCodeByProductSegment();  //KMT2016CU5
            end;
        }
        field(50001; "Transfer Receipt No."; Code[20])
        {
            Enabled = false;
            TableRelation = "Transfer Receipt Header" WHERE("Source Document No." = FILTER(<> ''));

            trigger OnValidate()
            begin
                IRDMgt.CreateSalesLineBasedOnTransferReceiptNo(Rec, "Transfer Receipt No.");
            end;
        }
        field(50700; Note; Text[250])
        {
        }
        field(70000; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(70001; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(70002; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(70003; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(70004; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(70005; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(70006; "Phone No."; Text[100])
        {
        }
    }
    trigger OnInsert()
    begin
        VALIDATE("Payment Instructions Id", O365SalesInvoiceMgmt.GetDefaultPaymentInstructionsId);

        SETVIEW('');
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header", "Document Type", "No.");

        IF "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
            "Location Code" := 'DHUMBARAHI';   //KMT2016CU5
    end;

    //Unsupported feature: Code Modification on "EmailRecords(PROCEDURE 135)".


    local procedure "<--KMT2016CU5-->"()
    begin
    end;

    procedure ValidateSalepersonCodeByProductSegment()
    var
        Text100: Label 'There is no salesperson for the %1 product for %2 in product- wise salesperson table.';
        CustomerCrLimit: Record "Customer Credit Limit Detail";
        IrdMgt: Codeunit "IRD Mgt.";
    begin
        VALIDATE("Shortcut Dimension 1 Code", '');
        VALIDATE("Shortcut Dimension 2 Code", '');
        "Salesperson Code" := '';
        ProductWiseSalesPerson.RESET;
        // ProductWiseSalesPerson.SETRANGE("Customer No.", "Sell-to Customer No.");
        ProductWiseSalesPerson.SETRANGE("Inventory Posting Group", "Inventory Posting Group");
        IF ProductWiseSalesPerson.FINDFIRST THEN BEGIN
            VALIDATE("Shortcut Dimension 1 Code", ProductWiseSalesPerson."Product Segment Code");
            VALIDATE("Shortcut Dimension 2 Code", ProductWiseSalesPerson."Area Code");
            VALIDATE("Shortcut Dimension 4 Code", ProductWiseSalesPerson."Region Code");
            "Salesperson Code" := ProductWiseSalesPerson."Area Code";
        END ELSE
            MESSAGE(Text100, "Inventory Posting Group", "Sell-to Customer Name");

        //SRT Dec 31st 2019 >>  getting payment terms code for customer credit limit master
        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
            CustomerCrLimit.RESET;
            CustomerCrLimit.SETRANGE("Customer No.", "Bill-to Customer No.");
            CustomerCrLimit.SETRANGE("Global Dimension 1 Code", "Shortcut Dimension 1 Code");
            CustomerCrLimit.SETRANGE("Skip Credit Limit Control", FALSE);
            IF CustomerCrLimit.FINDFIRST THEN BEGIN
                IF CustomerCrLimit."Payment Terms Code" <> '' THEN
                    VALIDATE("Payment Terms Code", CustomerCrLimit."Payment Terms Code")
            END;
        END;

        IrdMgt.CheckCustomerCreditLimit(Rec) // check customer credit at the time of product code validation
        //SRT Dec 31st 2019 <<
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        UserSetup: Record "User Setup";
        CustPostingGr: Record "Customer Posting Group";

    var
        SalesLineRec: Record "Sales Line";


    //Unsupported feature: Property Modification (Id) on "ApprovalsMgmt(Variable 1082)".

    //var
    //>>>> ORIGINAL VALUE:
    //ApprovalsMgmt : 1082;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ApprovalsMgmt : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "WhseSourceHeader(Variable 1073)".

    //var
    //>>>> ORIGINAL VALUE:
    //WhseSourceHeader : 1073;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //WhseSourceHeader : 1997;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalesLineReserve(Variable 1066)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesLineReserve : 1066;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesLineReserve : 1998;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PostingSetupMgt(Variable 1085)".

    //var
    //>>>> ORIGINAL VALUE:
    //PostingSetupMgt : 1085;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PostingSetupMgt : 1999;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ShippingAdviceErr(Variable 1029)".

    //var
    //>>>> ORIGINAL VALUE:
    //ShippingAdviceErr : 1029;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ShippingAdviceErr : 1994;
    //Variable type has not been exported.

    var
        ProductWiseSalesPerson: Record "Product&Salesperson Posting Gr";
        IRDMgt: Codeunit "IRD Mgt.";
        SkipSellToContact: Boolean;
        Cust: Record Customer;
        UserSetupMgt: Codeunit "User Setup Management";
        BilltoCustomerNoChanged: Boolean;

        O365SalesInvoiceMgmt: Codeunit "O365 Sales Invoice Mgmt";
        ArchiveManagement: Codeunit ArchiveManagement;

}

