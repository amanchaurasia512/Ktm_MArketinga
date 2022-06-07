report 50453 "Post And Print Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PostAndPrintVoucher.rdlc';
    Caption = 'G/L Register';

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
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
            column(SourceDesc____Voucher_; SourceDesc + 'Voucher')
            {
            }
            column(G_L_Register__TABLECAPTION__________GLRegFilter; "G/L Register".TABLECAPTION + ': ' + GLRegFilter)
            {
            }
            column(GLRegFilter; GLRegFilter)
            {
            }
            column(G_L_Register__No__; "No.")
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
            column(Dim1Name; Dim1Name)
            {
            }
            column(Dim2Name; Dim2Name)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = SORTING("Entry No.");
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
                column(Cheque_No______ChequeNo______Dated______FORMAT_ChequeDate_; 'Cheque No: ' + ChequeNo + '  Dated: ' + FORMAT(ChequeDate))
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

                trigger OnAfterGetRecord()
                var
                    ClosingDate: Date;
                begin
                    IF NOT GLAcc.GET("G/L Account No.") THEN
                        GLAcc.INIT;


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

                    GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                    BankAccountNo := FindGLAccNo("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                    IF BankAccountNo <> '' THEN
                        GLAccName += ', ' + BankAccountNo;
                    EmpName := FindEmpName("Entry No.");
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
                        InitTextVariable;
                        TotalDebitAmt += "Debit Amount";
                        FormatNoText(NumberText, ABS(TotalDebitAmt), '');
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

                    // to get number into words
                    IF DebitAmountTotal <> 0 THEN BEGIN
                        NumberToText.InitTextVariable;
                        NumberToText.FormatNoText(TextVar1, DebitAmountTotal, '');

                    END ELSE BEGIN
                        NumberToText.InitTextVariable;
                        NumberToText.FormatNoText(TextVar1, CreditAmountTotal, '');

                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                    CurrReport.CREATETOTALS(Amount);

                    NUMLines := 13;
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                    DebitAmountTotal := 0;
                    CreditAmountTotal := 0;
                    //TestField := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PostingDate := "G/L Register"."Creation Date";
                NepaliDate := STPLmgt.getNepaliDate(PostingDate);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS("G/L Entry".Amount);

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
                Info1 := RespCenter.Name + ',' + Address + ',' + 'Ph. No.:' + PhoneNo;
                Info2 := 'Fax :' + FaxNo + ',' + 'Email :' + Email;
                CompanyVAT := CompanyInfo."VAT Registration No.";
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

    trigger OnInitReport()
    begin
        GLSetup.GET;
        HRSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        IF Dimension.GET(GLSetup."Global Dimension 1 Code") THEN
            Dim1Name := Dimension.Name;
        IF Dimension.GET(GLSetup."Global Dimension 2 Code") THEN
            Dim2Name := Dimension.Name;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        HRSetup: Record "Human Resources Setup";
        GLAcc: Record "G/L Account";
        GLRegFilter: Text[250];
        Customer: Record Customer;
        CustomerName: Text[250];
        CustomerAddress: Text[50];
        CustomerNumber: Text[30];
        CustomerVAT: Text[20];
        CompanyInfo: Record "Company Information";
        CreditAmount: Decimal;
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center";
        Address: Text[50];
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
        GLAccName: Text[100];
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
        Dim1ValueName: Text[50];
        Dim2ValueName: Text[50];

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
    procedure FormatNoText(var NoText: Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundred: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        /*
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        
        IF No < 1 THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526)
        ELSE BEGIN
          FOR Exponent := 4 DOWNTO 1 DO BEGIN
            PrintExponent := FALSE;
            IF No > 99999 THEN BEGIN
              Ones := No DIV (POWER(100,Exponent - 1) * 10);
              Hundreds := 0;
            END ELSE BEGIN
              Ones := No DIV POWER(1000,Exponent - 1);
              Hundreds := Ones DIV 100;
            END;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            IF Hundreds > 0 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text16527);
            END;
            IF Tens >= 2 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              IF Ones > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            END ELSE
              IF (Tens * 10 + Ones) > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            IF PrintExponent AND (Exponent > 1) THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            IF No > 99999 THEN
              No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100,Exponent - 1) * 10
            ELSE
              No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
          END;
        END;
        
        IF CurrencyCode <> '' THEN BEGIN
          Currency.GET(CurrencyCode);
          AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + '');//Currency."Currency Numeric Description");
        END ELSE
          AddToNoText(NoText,NoTextIndex,PrintExponent,'RUPEES');
        
        AddToNoText(NoText,NoTextIndex,PrintExponent,Text16528);
        
        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
          AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[TensDec]);
          IF OnesDec > 0 THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[OnesDec]);
        END ELSE
          IF (TensDec * 10 + OnesDec) > 0 THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[TensDec * 10 + OnesDec])
          ELSE
            AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526);
        IF (CurrencyCode <> '') THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + '')//Currency."Currency Decimal Description" + ' ONLY')
        ELSE
          AddToNoText(NoText,NoTextIndex,PrintExponent,' PAISA ONLY');
         */

    end;

    [Scope('OnPrem')]
    procedure AddToNoText(var NoText: Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        /*
        PrintExponent := TRUE;
        
        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
          NoTextIndex := NoTextIndex + 1;
          IF NoTextIndex > ARRAYLEN(NoText) THEN
            ERROR(Text16529,AddText);
        END;
        
        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText,'<');
        */

    end;

    [Scope('OnPrem')]
    procedure InitTextVariable()
    begin
        /*
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;
        
        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;
        
        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
        */

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
                //AccName := Bank.Name;
                AccNo := Bank."Bank Account No.";
            END ELSE BEGIN
                //GLAccount.GET("G/L Account No.");
                //AccName := GLAccount.Name;
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
        BranchName: Text[50];
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
        CostRevName: Text[50];
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

        IF "Source Type" = "Source Type"::" " THEN
            Description := GLEntry.Description;
        EXIT(Description);
    end;
}

