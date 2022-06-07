report 50454 "Posted Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostedVoucher.rdlc';
    Caption = 'Voucher';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = "Document No.", "Posting Date";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyInfo.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
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
            column(EmpName; EmpName)
            {
            }
            column(BranchName; Dim1ValueName)
            {
            }
            column(CostRevName; Dim2ValueName)
            {
            }
            column(DocumentNo; DocumentNo)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(NepaliDate; NepaliDate)
            {
            }
            column(SourceDesc____Voucher_; SourceDesc)
            {
            }
            column(G_L_Entry__Amount; "G/L Entry".Amount)
            {
            }
            column(G_L_RegisterCaption; G_L_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Entry__Posting_Date_Caption; G_L_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(G_L_Entry__Document_Type_Caption; G_L_Entry__Document_Type_CaptionLbl)
            {
            }
            column(G_L_Entry__Document_No__Caption; "G/L Entry".FIELDCAPTION("Document No."))
            {
            }
            column(G_L_Entry__G_L_Account_No__Caption; "G/L Entry".FIELDCAPTION("G/L Account No."))
            {
            }
            column(GLAcc_NameCaption; GLAcc_NameCaptionLbl)
            {
            }
            column(G_L_Entry_DescriptionCaption; "G/L Entry".FIELDCAPTION(Description))
            {
            }
            column(G_L_Entry__VAT_Amount_Caption; "G/L Entry".FIELDCAPTION("VAT Amount"))
            {
            }
            column(G_L_Entry__Gen__Posting_Type_Caption; G_L_Entry__Gen__Posting_Type_CaptionLbl)
            {
            }
            column(G_L_Entry__Gen__Bus__Posting_Group_Caption; G_L_Entry__Gen__Bus__Posting_Group_CaptionLbl)
            {
            }
            column(G_L_Entry__Gen__Prod__Posting_Group_Caption; G_L_Entry__Gen__Prod__Posting_Group_CaptionLbl)
            {
            }
            column(G_L_Entry_AmountCaption; "G/L Entry".FIELDCAPTION(Amount))
            {
            }
            column(G_L_Entry__Entry_No__Caption; "G/L Entry".FIELDCAPTION("Entry No."))
            {
            }
            column(G_L_Register__No__Caption; G_L_Register__No__CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(CrText; CrText)
            {
            }
            column(GLAccName; GLAccName)
            {
            }
            column(DrText; DrText)
            {
            }
            column(G_L_Entry__Debit_Amount_; "Debit Amount")
            {
            }
            column(G_L_Entry__Credit_Amount_; "Credit Amount")
            {
            }
            column(DebitAmountTotal; DebitAmountTotal)
            {
            }
            column(CreditAmountTotal; CreditAmountTotal)
            {
            }
            column(Description1; Description1)
            {
            }
            column(Cheque_No______ChequeNo______Dated______FORMAT_ChequeDate_; GLEntry."External Document No.")
            {
            }
            column(LCNo__; "LCNo.")
            {
            }
            column(Bank_LCNo__; "Bank LCNo.")
            {
            }
            column(G_L_Entry__G_L_Entry___Transaction_No__; "G/L Entry"."Transaction No.")
            {
            }
            column(ChequeDate; ChequeDate)
            {
            }
            column(Narration1; Narration1)
            {
            }
            column(G_L_Entry__Posting_Date_; FORMAT("Posting Date"))
            {
            }
            column(G_L_Entry__Document_Type_; "Document Type")
            {
            }
            column(G_L_Entry__Document_No__; "Document No.")
            {
            }
            column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
            {
            }
            column(GLAcc_Name; GLAcc.Name)
            {
            }
            column(G_L_Entry_Description; Description)
            {
            }
            column(G_L_Entry__VAT_Amount_; "VAT Amount")
            {
            }
            column(G_L_Entry__Gen__Posting_Type_; "Gen. Posting Type")
            {
            }
            column(G_L_Entry__Gen__Bus__Posting_Group_; "Gen. Bus. Posting Group")
            {
            }
            column(G_L_Entry__Gen__Prod__Posting_Group_; "Gen. Prod. Posting Group")
            {
            }
            column(G_L_Entry_Amount; Amount)
            {
            }
            column(G_L_Entry__Entry_No__; "Entry No.")
            {
            }
            column(CustomerAddress; CustomerAddress)
            {
            }
            column(CustomerNumber; CustomerNumber)
            {
            }
            column(CreditAmount; CreditAmount)
            {
            }
            column(CustomerVAT; CustomerVAT)
            {
            }
            column(Narration; Narration)
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(GLEntry__Source_Type_; GLEntry."Source Type")
            {
            }
            column(TextVar_1______TextVar_2_; TextVar[1] + ' ' + TextVar[2])
            {
                AutoFormatType = 1;
            }
            column(TextVar1_1______TextVar1_2_; TextVar1[1] + ' ' + TextVar1[2])
            {
                AutoFormatType = 1;
            }
            column(G_L_Entry_Amount_Control41; Amount)
            {
            }
            column(Narration_Caption; Narration_CaptionLbl)
            {
            }
            column(G_L_Entry_Amount_Control41Caption; G_L_Entry_Amount_Control41CaptionLbl)
            {
            }
            column(Dim1Name; Dim1Name)
            {
            }
            column(Dim2Name; Dim2Name)
            {
            }
            column(ShowDimension; ShowDimension)
            {
            }
            column(DimensionText1; DimensionText[1])
            {
            }
            column(DimensionText2; DimensionText[2])
            {
            }
            column(DimensionText3; DimensionText[3])
            {
            }
            column(DimensionText4; DimensionText[4])
            {
            }
            column(DimensionText5; DimensionText[5])
            {
            }
            column(DimensionText6; DimensionText[6])
            {
            }
            column(DimensionText7; DimensionText[7])
            {
            }
            column(DimensionText8; DimensionText[8])
            {
            }
            column(ShowReceivedBy; ShowReceivedBy)
            {
            }
            column(VendOpeningBal; VendOpeningBal)
            {
            }
            column(BalAccountNo_GLEntry; "G/L Entry"."Bal. Account No.")
            {
            }
            column(SourceNo_GLEntry; "G/L Entry"."Source No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                ClosingDate: Date;
            begin
                IF (SourceCodeSetup."Inventory Post Cost" = "Source Code") OR (SourceCodeSetup."Unapplied Sales Entry Appln." = "Source Code") THEN
                    CurrReport.SKIP;
                IF Amount = 0 THEN
                    CurrReport.SKIP;
                PostingDate := "Posting Date";
                NepaliDate := STPLmgt.getNepaliDate(PostingDate);

                IF GLAcc.GET("G/L Account No.") THEN;

                IF "Source Code" IN [SourceCodeSetup."Payment Journal", SourceCodeSetup."Cash Receipt Journal"] THEN
                    ShowReceivedBy := TRUE;
                IF "Source Type" = "Source Type"::Customer THEN BEGIN
                    CreditAmount := "G/L Entry"."Credit Amount";
                    DocumentNo := "G/L Entry"."Document No.";
                    Narration := "G/L Entry".Narration;
                    Narration1 := "G/L Entry".Narration;
                    Customer.SETRANGE("No.", "Source No.");
                    IF Customer.FIND('-') THEN BEGIN
                        CustomerName := Customer.Name + ' ' + Customer."Name 2";
                        CustomerAddress := Customer.Address;
                        CustomerNumber := Customer."Phone No.";
                        CustomerVAT := Customer."VAT Registration No.";
                    END;
                END ELSE BEGIN
                    CreditAmount := 0;
                    DocumentNo := '';
                    ChequeNo := '';
                    CustomerName := '';
                    CustomerAddress := '';
                    CustomerNumber := '';
                    CustomerVAT := '';
                END;
                //VNC2016CU5 >>
                Vendor.RESET;
                IF "Source Type" = "Source Type"::Vendor THEN BEGIN
                    Vendor.SETRANGE("No.", "Source No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        Vendor.CALCFIELDS("Balance (LCY)");
                        VendOpeningBal := Vendor."Balance (LCY)";
                        //MESSAGE(FORMAT(VendOpeningBal));
                    END;
                END;
                //VNC2016CU5 <<

                GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                BankAccountNo := FindGLAccNo("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                IF BankAccountNo <> '' THEN
                    GLAccName += ', ' + BankAccountNo;
                EmpName := FindEmpName("Dimension Set ID");
                Dim1ValueName := FindDim1("Dimension Set ID");
                Dim2ValueName := FindDim2("Dimension Set ID");
                NarrationText := GetNarration("Entry No.");
                Description1 := GetDescription("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                IF Amount < 0 THEN BEGIN
                    CrText := 'To';
                    DrText := '';
                END ELSE BEGIN
                    CrText := '';
                    DrText := 'Dr';
                END;

                SourceDesc := '';
                IF "Source Code" <> '' THEN BEGIN
                    SourceCode.GET("Source Code");
                    SourceDesc := SourceCode.Description;
                END;

                PageLoop := PageLoop - 1;
                LinesPrinted := LinesPrinted + 1;

                ChequeNo := '';
                ChequeDate := 0D;

                IF (ChequeNo <> '') AND (ChequeDate <> 0D) THEN BEGIN
                    PageLoop := PageLoop - 1;
                    LinesPrinted := LinesPrinted + 1;
                END;
                IF PostingDate <> "Posting Date" THEN BEGIN
                    PostingDate := "Posting Date";
                    TotalDebitAmt := 0;
                END;
                IF DocumentNo <> "Document No." THEN BEGIN
                    DocumentNo := "Document No.";
                    TotalDebitAmt := 0;
                END;

                IF PostingDate = "Posting Date" THEN BEGIN
                    TotalDebitAmt += "Debit Amount";
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                END;
                IF ISSERVICETIER THEN BEGIN
                    IF (PrePostingDate <> "Posting Date") OR (PreDocumentNo <> "Document No.") THEN BEGIN
                        DebitAmountTotal := 0;
                        CreditAmountTotal := 0;
                        PrePostingDate := "Posting Date";
                        PreDocumentNo := "Document No.";
                    END;

                    DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                    CreditAmountTotal := CreditAmountTotal + "Credit Amount";
                END;

                IF DebitAmountTotal <> 0 THEN BEGIN
                    NumberToText.InitTextVariable;
                    NumberToText.FormatNoText(TextVar1, DebitAmountTotal, '');

                END ELSE BEGIN
                    NumberToText.InitTextVariable;
                    NumberToText.FormatNoText(TextVar1, CreditAmountTotal, '');

                END;

                IF ShowDimension THEN
                    GetDimensions("Dimension Set ID");
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(Amount);

                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
                //TestField := 0;
                // SETFILTER("Source Code",'<>%1&<>%2&<>%3&<>%4',SourceCodeSetup."Sales Entry Application",
                //                                    SourceCodeSetup."Purchase Entry Application",
                //                                    SourceCodeSetup."Unapplied Sales Entry Appln.",
                //                                    SourceCodeSetup."Unapplied Purch. Entry Appln.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Show Dimension"; ShowDimension)
                    {
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

    trigger OnInitReport()
    begin
        GLSetup.GET;
        HRSetup.GET;
        CompanyInfo.GET;
        SourceCodeSetup.GET;
        CompanyInfo.CALCFIELDS(Picture);
        IF Dimension.GET(GLSetup."Global Dimension 1 Code") THEN
            Dim1Name := Dimension.Name;
        IF Dimension.GET(GLSetup."Global Dimension 2 Code") THEN
            Dim2Name := Dimension.Name;
    end;

    trigger OnPreReport()
    begin
        //to get information from responsibility center
        UserSetup.GET(USERID);

        RespCenter.RESET;
        RespCenter.SETRANGE(Code, UserSetup."Default Responsibility Center");
        IF RespCenter.FIND('-') THEN BEGIN
            Address := RespCenter.Address;
            PhoneNo := RespCenter."Phone No.";
            FaxNo := RespCenter."Fax No.";
            Email := RespCenter."E-Mail";
        END;
        Info1 := CompanyInfo.Address + ',' + 'Ph. No.:' + CompanyInfo."Phone No.";
        Info2 := 'Fax :' + CompanyInfo."Fax No." + ',' + 'Email :' + CompanyInfo."E-Mail";
        CompanyVAT := CompanyInfo."VAT Registration No.";
    end;

    var
        GLSetup: Record "General Ledger Setup";
        HRSetup: Record "Human Resources Setup";
        GLAcc: Record "G/L Account";
        Customer: Record Customer;
        CustomerName: Text[250];
        CustomerAddress: Text[50];
        CustomerNumber: Text[100];
        CustomerVAT: Text[20];
        CompanyInfo: Record "Company Information";
        CreditAmount: Decimal;
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center";
        Dim1ValueName: Text[50];
        Address: Text[100];
        PhoneNo: Text[30];
        FaxNo: Text[30];
        Email: Text[80];
        Info1: Text[200];
        Info2: Text[200];
        CompanyVAT: Text[20];
        DocumentNo: Code[20];
        PostingDate: Date;
        NepaliDate: Text[20];
        STPLmgt: Codeunit "IRD Mgt.";
        Narration: Text[250];
        SourceCode: Record "Source Code";
        GLEntry: Record "G/L Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLAccName: Text;
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[50];
        ChequeDate: Date;
        OnesText: Text[30];
        TensText: Text[30];
        ExponentText: Text[30];
        PrintLineNarration: Boolean;
        TotalDebitAmt: Decimal;
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrePostingDate: Date;
        PreDocumentNo: Code[20];
        "BankNo.": Record "Bank Account";
        BankAccountNo: Text[30];
        EmpName: Text[50];
        Dim2ValueName: Text[50];
        City: Text[50];
        NarrationText: Text[250];
        "LCNo.": Code[20];
        "Bank LCNo.": Code[20];
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
        Narration1: Text[250];
        CheckNo: Code[50];
        TestField: Integer;
        NumberToText: Codeunit "IRD Mgt.";
        TextVar: array[2] of Text[80];
        TextVar1: array[2] of Text[80];
        TestText: Text[250];
        Amount: Decimal;
        Description1: Text[50];
        G_L_RegisterCaptionLbl: Label 'G/L Register';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        G_L_Entry__Posting_Date_CaptionLbl: Label 'Posting Date';
        G_L_Entry__Document_Type_CaptionLbl: Label 'Document Type';
        GLAcc_NameCaptionLbl: Label 'Name';
        G_L_Entry__Gen__Posting_Type_CaptionLbl: Label 'Gen. Posting Type';
        G_L_Entry__Gen__Bus__Posting_Group_CaptionLbl: Label 'Gen. Bus. Posting Group';
        G_L_Entry__Gen__Prod__Posting_Group_CaptionLbl: Label 'Gen. Prod. Posting Group';
        G_L_Register__No__CaptionLbl: Label 'Register No.';
        TotalCaptionLbl: Label 'Total';
        Narration_CaptionLbl: Label 'Narration:';
        G_L_Entry_Amount_Control41CaptionLbl: Label 'Total';
        Dim1Name: Text[50];
        Dim2Name: Text[50];
        Dimension: Record Dimension;
        DimensionText: array[8] of Text[100];
        ShowDimension: Boolean;
        ShowReceivedBy: Boolean;
        VendOpeningBal: Decimal;
        Vendor: Record Vendor;
        SourceCodeSetup: Record "Source Code Setup";

    [Scope('OnPrem')]
    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[100]
    var
        AccName: Text[100];
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
        FALedgerEntry: Record "FA Ledger Entry";
        FA: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        "BankAccNo.": Text[30];
    begin
        IF "Source Type" = "Source Type"::Vendor THEN
            IF VendLedgerEntry.GET("Entry No.") THEN BEGIN
                Vend.GET("Source No.");
                AccName := Vend.Name;
            END ELSE BEGIN
                GLAccount.GET("G/L Account No.");
                AccName := GLAccount.Name;
            END
        ELSE
            IF "Source Type" = "Source Type"::Customer THEN
                IF CustLedgerEntry.GET("Entry No.") THEN BEGIN
                    Cust.GET("Source No.");
                    AccName := Cust.Name + ' ' + Cust."Name 2";
                END ELSE BEGIN
                    GLAccount.GET("G/L Account No.");
                    AccName := GLAccount.Name;
                END
            ELSE
                IF "Source Type" = "Source Type"::"Bank Account" THEN
                    IF BankLedgerEntry.GET("Entry No.") THEN BEGIN
                        Bank.GET("Source No.");
                        AccName := Bank.Name;

                    END ELSE BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END
                ELSE
                    IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
                        FALedgerEntry.RESET;
                        FALedgerEntry.SETCURRENTKEY("G/L Entry No.");
                        FALedgerEntry.SETRANGE("G/L Entry No.", "Entry No.");
                        IF FALedgerEntry.FINDFIRST THEN BEGIN
                            FA.GET("Source No.");
                            AccName := FA.Description;
                        END ELSE BEGIN
                            GLAccount.GET("G/L Account No.");
                            AccName := GLAccount.Name;
                        END;
                    END ELSE BEGIN
                        GLAccount.GET("G/L Account No.");
                        AccName := GLAccount.Name;
                    END;

        IF "Source Type" = "Source Type"::" " THEN BEGIN
            GLAccount.GET("G/L Account No.");
            AccName := GLAccount.Name;
        END;

        EXIT(AccName);
    end;

    [Scope('OnPrem')]
    procedure FindGLAccNo("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[30]
    var
        AccNo: Text[30];
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
    begin
        IF "Source Type" = "Source Type"::"Bank Account" THEN
            IF BankLedgerEntry.GET("Entry No.") THEN BEGIN
                Bank.GET("Source No.");
                AccNo := Bank."Bank Account No.";
            END ELSE BEGIN
            END;
        EXIT(AccNo);
    end;

    [Scope('OnPrem')]
    procedure FindEmpName(DimensionSetID: Integer): Text[50]
    var
        EmployeeName: Text[50];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DimSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        DimSetEntry.SETRANGE("Dimension Set ID", DimensionSetID);
        DimSetEntry.SETRANGE("Dimension Code", HRSetup."Employee Dimension");
        IF DimSetEntry.FINDFIRST THEN BEGIN
            DimensionCode := DimSetEntry."Dimension Code";
            DimensionValueCode := DimSetEntry."Dimension Value Code";
            DimensionValue.RESET;
            DimensionValue.SETRANGE(DimensionValue.Code, DimensionValueCode);
            IF DimensionValue.FINDFIRST THEN
                EmployeeName := DimensionValue.Name;
        END;
        EXIT(EmployeeName);
    end;

    [Scope('OnPrem')]
    procedure FindDim1(DimensionSetID: Integer): Text[50]
    var
        Dim1Name: Text[50];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DimSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        DimSetEntry.SETRANGE("Dimension Set ID", DimensionSetID);
        DimSetEntry.SETRANGE("Dimension Code", GLSetup."Global Dimension 1 Code");
        IF DimSetEntry.FINDFIRST THEN BEGIN
            DimensionCode := DimSetEntry."Dimension Code";
            DimensionValueCode := DimSetEntry."Dimension Value Code";
            DimensionValue.RESET;
            DimensionValue.SETRANGE(DimensionValue.Code, DimensionValueCode);
            IF DimensionValue.FINDFIRST THEN
                Dim1Name := DimensionValue.Name;
        END;
        EXIT(Dim1Name);
    end;

    [Scope('OnPrem')]
    procedure FindDim2(DimensionSetID: Integer): Text[50]
    var
        Dim2Name: Text[50];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DimSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
    begin
        DimSetEntry.SETRANGE("Dimension Set ID", DimensionSetID);
        DimSetEntry.SETRANGE("Dimension Code", GLSetup."Global Dimension 2 Code");
        IF DimSetEntry.FINDFIRST THEN BEGIN
            DimensionCode := DimSetEntry."Dimension Code";
            DimensionValueCode := DimSetEntry."Dimension Value Code";
            DimensionValue.RESET;
            DimensionValue.SETRANGE(DimensionValue.Code, DimensionValueCode);
            IF DimensionValue.FINDFIRST THEN
                Dim2Name := DimensionValue.Name;
        END;
        EXIT(Dim2Name);
    end;

    [Scope('OnPrem')]
    procedure GetNarration("Entry No.": Integer): Text[250]
    var
        Narration: Text[250];
        GLEntry1: Record "G/L Entry";
    begin
        GLEntry1.SETRANGE(GLEntry1."Entry No.", "Entry No.");
        IF GLEntry1.FINDFIRST THEN
            Narration := GLEntry1.Narration;

        EXIT(Narration);
    end;

    [Scope('OnPrem')]
    procedure FindCustomerName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]): Text[50]
    var
        CustName: Text[50];
        Customer: Record Customer;
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
    begin
        IF "Source Type" = "Source Type"::Customer THEN
            IF CustomerLedgerEntry.GET("Entry No.") THEN BEGIN
                Customer.GET("Source No.");
                //AccName := Bank.Name;
                CustName := Customer.Name;
            END;
        EXIT(CustName);
    end;

    [Scope('OnPrem')]
    procedure GetDescription("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    var
        Description: Text[50];
    begin
        IF "Source Type" = "Source Type"::Vendor THEN BEGIN
            IF GLEntry.GET("Entry No.") THEN
                Description := GLEntry.Description
        END ELSE
            IF "Source Type" = "Source Type"::Customer THEN BEGIN
                IF GLEntry.GET("Entry No.") THEN
                    Description := GLEntry.Description;
            END ELSE
                IF "Source Type" = "Source Type"::"Bank Account" THEN BEGIN
                    IF GLEntry.GET("Entry No.") THEN
                        Description := GLEntry.Description;
                END ELSE
                    IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
                        IF GLEntry.GET("Entry No.") THEN
                            Description := GLEntry.Description
                    END ELSE
                        Description := GLEntry.Description;

        IF "Source Type" = "Source Type"::" " THEN BEGIN
            IF GLEntry.GET("Entry No.") THEN
                Description := GLEntry.Description;
        END;
        EXIT(Description);
    end;

    local procedure GetDimensions(DimSetID: Integer)
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        i: Integer;
    begin
        CLEAR(DimensionText);
        DimensionSetEntry.RESET;
        DimensionSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        IF DimensionSetEntry.FINDSET THEN
            REPEAT
                DimensionSetEntry.CALCFIELDS("Dimension Value Name");
                i += 1;
                DimensionText[i] := DimensionSetEntry."Dimension Code" + ' : ' + DimensionSetEntry."Dimension Value Name";
            UNTIL DimensionSetEntry.NEXT = 0;
    end;
}

