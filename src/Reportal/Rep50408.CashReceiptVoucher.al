report 50408 "Cash Receipt Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CashReceiptVoucher.rdlc';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = "Entry No.", "Document Type", "Posting Date";
            RequestFilterHeading = 'Receipt Voucher';
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(ContactNo; ContactNo)
            {
            }
            column(CustomerAddress1; CustomerAddress1)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(CustomerVAT; CustomerVAT)
            {
            }
            column(NepaliDate; NepaliDate)
            {
            }
            column(CompInfo_Picture_Control1000000018; CompInfo.Picture)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(Address; Address)
            {
            }
            column(PhoneNo; PhoneNo)
            {
            }
            column(FaxNo; FaxNo)
            {
            }
            column(Email; Email)
            {
            }
            column(Info1; Info1)
            {
            }
            column(Info2; Info2)
            {
            }
            column(CompanyVAT; CompanyVAT)
            {
            }
            column(CustomerAmount; CustomerAmount)
            {
            }
            column(CustomerDescription; CustomerDescription)
            {
            }
            column(GLEntry_Narration; Narration)
            {
            }
            column(GLEntry_Account_Type; "G/L Entry"."Bal. Account Type")
            {
            }
            column(GLEntry_Account_No; AccCode)
            {
            }
            column(GLEntry_Description; Description)
            {
            }
            column(GLEntry_Debit_Amount; "Debit Amount")
            {
            }
            column(GLEntry_Credit_Amount; "Credit Amount")
            {
            }
            column(GLEntry_Document_No__; VoucNo)
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(AccName; AccName)
            {
            }
            column(PostingDateText; PostDate)
            {
            }
            column(RemarksText; RemarksText)
            {
            }
            column(GLEntry_Cheque_No; "External Document No.")
            {
            }
            column(CustomerAddress; CustomerAddress)
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(GLEntry_Debit_Amount__Control1000000041; "Debit Amount")
            {
            }
            column(GLEntry_Credit_Amount__Control1000000042; "Credit Amount")
            {
            }
            column(GLEntry_LineCaption; Gen__Journal_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(GLEntry_Account_Type_Caption; FIELDCAPTION("Bal. Account Type"))
            {
            }
            column(GLEntry_Account_No__Caption; Gen__Journal_Line__Account_No__CaptionLbl)
            {
            }
            column(GLEntry_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(GLEntry_Debit_Amount_Caption; Gen__Journal_Line__Debit_Amount_CaptionLbl)
            {
            }
            column(GLEntry_Credit_Amount_Caption; Gen__Journal_Line__Credit_Amount_CaptionLbl)
            {
            }
            column(GLEntry_Document_No__Caption; Gen__Journal_Line__Document_No__CaptionLbl)
            {
            }
            column(Acc__NameCaption; Acc__NameCaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(GLEntry_Posting_Date; "Posting Date")
            {
            }
            column(GLEntry_Document_No_; "Document No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //KMT2016CU5 >>
                IF ("G/L Entry"."Source Code" = 'UNAPPSALES') OR ("G/L Entry"."Source Code" = 'UNAPPPURCH') THEN
                    CurrReport.SKIP;
                //KMT2016CU5 <<
                VoucNo := "Document No.";
                PostDate := FORMAT("Posting Date");
                CustomerAddress := GetCustomerAddress("Bal. Account No.", "Bal. Account Type");
                CustomerAddress1 := GetCustomerAddress("Bal. Account No.", "Bal. Account Type");
                BankAccountNo := GetBankAccountNo("Bal. Account Type", "Bal. Account No.");
                ContactNo := GetContactNo("Bal. Account No.", "Bal. Account Type");
                CustomerName := GetCustomerName("Bal. Account No.", "Bal. Account Type");
                CustomerVAT := GetVATNo("Bal. Account No.", "Bal. Account Type");
                CustomerAmount := GetCustomerAmount("Bal. Account No.", "Bal. Account Type");
                CustomerDescription := GetDescription("Bal. Account No.", "Bal. Account Type");
                Narration := "G/L Entry".Narration;

                IF ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") THEN BEGIN
                    GLAccount.RESET;
                    GLAccount.SETRANGE("No.", "Bal. Account No.");
                    IF GLAccount.FIND('-') THEN
                        AccName := GLAccount.Name;
                END ELSE
                    IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") THEN BEGIN
                        BankAcc.RESET;
                        BankAcc.SETRANGE("No.", "Bal. Account No.");
                        IF BankAcc.FIND('-') THEN BEGIN
                            BankAccPostGrp.RESET;
                            BankAccPostGrp.SETRANGE(Code, BankAcc."Bank Acc. Posting Group");
                            IF BankAccPostGrp.FIND('-') THEN BEGIN
                                AccCode := BankAccPostGrp."G/L Bank Account No.";
                                GLAccount.GET(AccCode);
                                AccName := GLAccount.Name;
                            END;
                        END;
                    END ELSE
                        IF ("Bal. Account Type" = "Bal. Account Type"::Customer) THEN BEGIN
                            Cust.RESET;
                            Cust.SETRANGE("No.", "Bal. Account No.");
                            IF Cust.FIND('-') THEN BEGIN
                                CustomerAddress := Cust.Address;
                                CustPostGrp.RESET;
                                CustPostGrp.SETRANGE(Code, Cust."Customer Posting Group");
                                IF CustPostGrp.FIND('-') THEN BEGIN
                                    AccCode := CustPostGrp."Receivables Account";
                                    GLAccount.GET(AccCode);
                                    AccName := GLAccount.Name;
                                END;
                            END;
                        END ELSE
                            IF ("Bal. Account Type" = "Bal. Account Type"::Vendor) THEN BEGIN
                                Vend.RESET;
                                Vend.SETRANGE("No.", "Bal. Account No.");
                                IF Vend.FIND('-') THEN BEGIN
                                    VendPostGrp.RESET;
                                    VendPostGrp.SETRANGE(Code, Vend."Vendor Posting Group");
                                    IF VendPostGrp.FIND('-') THEN BEGIN
                                        AccCode := VendPostGrp."Payables Account";
                                        GLAccount.GET(AccCode);
                                        AccName := GLAccount.Name;

                                    END;
                                END;
                            END ELSE
                                IF ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset") THEN BEGIN
                                    FixAst.RESET;
                                    FixAst.SETRANGE("No.", "Bal. Account No.");
                                    IF FixAst.FIND('-') THEN BEGIN
                                        FAPostGrp.RESET;
                                        FAPostGrp.SETRANGE(Code, FixAst."FA Posting Group");
                                        IF FAPostGrp.FIND('-') THEN BEGIN
                                            AccCode := FAPostGrp."Acquisition Cost Account";
                                            GLAccount.GET(AccCode);
                                            AccName := GLAccount.Name;
                                        END;
                                    END;
                                END;
                NepaliDate := STPLMgt.getNepaliDate("Posting Date");
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Document No.");

                AccName := '';

                //to get information from responsibility center
                UserSetup.GET(USERID);

                RespCenter.RESET;
                RespCenter.SETRANGE(Code, UserSetup."Default Responsibility Center");
                IF RespCenter.FIND('-') THEN BEGIN
                    BranchName := RespCenter.Name;
                    Address := RespCenter.Address;
                    PhoneNo := RespCenter."Phone No.";
                    FaxNo := RespCenter."Fax No.";
                    Email := RespCenter."E-Mail";
                END;

                Info1 := BranchName + ',' + Address + ',' + 'Ph. No.:' + PhoneNo;
                Info2 := 'Fax :' + FaxNo + ',' + 'Email :' + Email;
                CompanyVAT := CompInfo."VAT Registration No.";
                CLEAR(CustomerAmount);
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
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total for ';
        CompInfo: Record "Company Information";
        GLAccount: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FixAst: Record "Fixed Asset";
        AccName: Text[50];
        PostingDateText: Text[60];
        RemarksText: Text[250];
        CustPostGrp: Record "Customer Posting Group";
        VendPostGrp: Record "Vendor Posting Group";
        BankAccPostGrp: Record "Bank Account Posting Group";
        FAPostGrp: Record "FA Posting Group";
        AccCode: Code[20];
        VoucNo: Code[20];
        PostDate: Text[20];
        CustomerAddress: Text[50];
        BankAccountNo: Text[30];
        ContactNo: Text[30];
        CustomerAddress1: Text[50];
        CustomerName: Text[50];
        CustomerVAT: Text[20];
        NepaliDate: Code[10];
        STPLMgt: Codeunit "IRD Mgt.";
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center";
        BranchName: Text[50];
        Address: Text[50];
        PhoneNo: Text[30];
        FaxNo: Text[30];
        Email: Text[80];
        Info1: Text[200];
        Info2: Text[200];
        CompanyVAT: Text[20];
        CustomerAmount: Decimal;
        CustomerDescription: Text[50];
        Narration: Text[250];
        Gen__Journal_LineCaptionLbl: Label 'Gen. Journal Line';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Gen__Journal_Line__Account_No__CaptionLbl: Label 'Account No.';
        Gen__Journal_Line__Debit_Amount_CaptionLbl: Label 'Debit Amount (NPR)';
        Gen__Journal_Line__Credit_Amount_CaptionLbl: Label 'Credit Amount (NPR)';
        Gen__Journal_Line__Document_No__CaptionLbl: Label 'Voucher No.';
        Acc__NameCaptionLbl: Label 'Account Name';
        Posting_DateCaptionLbl: Label 'Posting Date';

    [Scope('OnPrem')]
    procedure GetCustomerAddress("Account No.": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Text[50]
    var
        Cust: Record Customer;
        CustomerAddress: Text[50];
    begin
        IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
            Cust.RESET;
            Cust.SETRANGE("No.", "Account No.");
            IF Cust.FIND('-') THEN
                CustomerAddress := Cust.Address;

            EXIT(CustomerAddress);
        END
    end;

    [Scope('OnPrem')]
    procedure GetBankAccountNo("Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No": Code[20]): Text[30]
    var
        AccNo: Text[30];
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
    begin

        IF "Account Type" = "Account Type"::"Bank Account" THEN
            //IF BankLedgerEntry.GET("Entry No.") THEN BEGIN
            Bank.GET("Account No");
        //AccName := Bank.Name;
        AccNo := Bank."Bank Account No.";
        EXIT(AccNo);
    end;

    [Scope('OnPrem')]
    procedure GetContactNo("Account No": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Text[30]
    var
        Cust: Record Customer;
        "PhoneNo.": Text[30];
    begin
        IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
            Cust.RESET;
            Cust.SETRANGE("No.", "Account No");
            IF Cust.FIND('-') THEN
                "PhoneNo." := Cust."Phone No.";

            EXIT("PhoneNo.");
        END
    end;

    [Scope('OnPrem')]
    procedure GetCustomerName("Account No": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Text[50]
    var
        Cust: Record Customer;
        CustomerName: Text[50];
    begin
        IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
            Cust.RESET;
            Cust.SETRANGE("No.", "Account No");
            IF Cust.FIND('-') THEN
                CustomerName := Cust.Name;

            EXIT(CustomerName);
        END
    end;

    [Scope('OnPrem')]
    procedure GetVATNo("Account No": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Text[20]
    var
        Cust: Record Customer;
        VatNo: Text[20];
    begin
        IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
            Cust.RESET;
            Cust.SETRANGE("No.", "Account No");
            IF Cust.FIND('-') THEN
                VatNo := Cust."VAT Registration No.";

            EXIT(VatNo);
        END
    end;

    [Scope('OnPrem')]
    procedure GetCustomerAmount("Account No": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Decimal
    var
        Amount: Decimal;
    begin
        IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
            Amount := "G/L Entry"."Credit Amount";

            EXIT(Amount);
        END;
    end;

    [Scope('OnPrem')]
    procedure GetDescription("Account No": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"): Text[50]
    var
        Description: Text[50];
    begin
        IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
            Description := "G/L Entry".Description;

            EXIT(Description);
        END;
    end;
}

