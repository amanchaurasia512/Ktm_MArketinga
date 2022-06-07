report 50415 "Credit Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CreditNote.rdlc';
    Caption = 'Credit Note';

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
            column(SourceDesc____Voucher_; SourceDesc + ' Voucher')
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
            column(Dim1Name; Dim1Name)
            {
            }
            column(Dim2Name; Dim2Name)
            {
            }
            column(NameCaption; NameCaption)
            {
            }
            column(VATAmt; VATAmt)
            {
            }
            column(TotalAmt; TotalAmt)
            {
            }
            column(NarrationText; NarrationText)
            {
            }
            column(TDSAmt; TDSAmt)
            {
            }

            trigger OnAfterGetRecord()
            var
                ClosingDate: Date;
            begin
                TDSAmt := 0; //Q1.0
                "G/L Entry".SETFILTER("Source Code", '<>%1', 'SALESAPPL');//aakrista
                //KMT2016CU5 >>
                DocumentNo := "G/L Entry"."Document No.";
                GLAccName := '';
                //NarrationText := '';
                IF "G/L Entry".Narration = '' THEN
                    NarrationText := "G/L Entry".Description
                ELSE
                    NarrationText := "G/L Entry".Narration;

                IF "G/L Entry"."External Document No." <> '' THEN
                    NarrationText += ',Bill No. :' + "G/L Entry"."External Document No.";

                IF ("G/L Entry"."Source Code" = 'UNAPPSALES') OR ("G/L Entry"."Source Code" = 'UNAPPPURCH') THEN
                    CurrReport.SKIP;
                //KMT2016CU5 <<
                PostingDate := "Posting Date";
                NepaliDate := IRDMgt.getNepaliDate(PostingDate);

                VATAmt += "G/L Entry"."VAT Amount";
                IF "G/L Entry".Amount > 0 THEN
                    DebitAmountTotal += "G/L Entry"."Debit Amount";
                IF "G/L Entry".Amount < 0 THEN
                    CreditAmountTotal += "G/L Entry"."Credit Amount";
                IF GLAcc.GET("G/L Account No.") THEN BEGIN
                    GLAccName := GLAcc.Name;
                END;
                //KMT2016CU5 >>
                IF CustomerName = '' THEN BEGIN
                    IF "G/L Entry"."Party Type" = "G/L Entry"."Party Type"::Customer THEN BEGIN
                        Customer.SETRANGE("No.", "Party No.");
                        IF Customer.FIND('-') THEN BEGIN
                            CustomerName := Customer.Name + ' ' + Customer."Name 2";
                            NameCaption := 'Customer';
                            IF (Customer."Address 2" <> '') AND (Customer.City <> '') THEN
                                CustomerAddress := Customer.Address + ',' + Customer."Address 2" + ',' + Customer.City
                            ELSE
                                CustomerAddress := Customer.Address + ',' + Customer.City;
                            CustomerNumber := Customer."Phone No.";
                            CustomerVAT := Customer."VAT Registration No.";
                        END;
                    END;
                    IF "G/L Entry"."Source Type" = "G/L Entry"."Source Type"::Customer THEN BEGIN
                        //MESSAGE('%1',"Source Type");
                        DocumentNo := "G/L Entry"."Document No.";
                        Customer.SETRANGE("No.", "Source No.");
                        IF Customer.FIND('-') THEN BEGIN    // '-' meaning findfirst
                            CustomerName := Customer.Name + ' ' + Customer."Name 2";
                            //MESSAGE('%1',CustomerName);
                            NameCaption := 'Customer';
                            IF (Customer."Address 2" <> '') AND (Customer.City <> '') THEN
                                CustomerAddress := Customer.Address + ',' + Customer."Address 2" + ',' + Customer.City
                            ELSE
                                CustomerAddress := Customer.Address + ',' + Customer.City;
                            CustomerNumber := Customer."Phone No.";
                            CustomerVAT := Customer."VAT Registration No.";
                        END;
                    END;
                END;
                IF "G/L Entry"."Source Type" = "G/L Entry"."Source Type"::Vendor THEN BEGIN
                    IF Vend.GET("G/L Entry"."Source No.") THEN
                        GLAccName := Vend.Name;
                END;
                //KMT2016CU5 <<
                /*IF DebitAmountTotal <> 0 THEN BEGIN
                 NumberToText.InitTextVariable;
                 NumberToText.FormatNoText(TextVar1, DebitAmountTotal,'');
                
                END ELSE BEGIN
                 NumberToText.InitTextVariable;
                 NumberToText.FormatNoText(TextVar1, CreditAmountTotal,'');
                END;
                */

                TDSRec.RESET; //Q1.0
                TDSRec.SETRANGE("Document No.", "G/L Entry"."Document No.");
                IF TDSRec.FINDSET THEN
                    TDSAmt += TDSRec."TDS Amount";

                IF DebitAmountTotal <> 0 THEN BEGIN
                    NumberToText.InitTextVariable;
                    NumberToText.FormatNoText(TextVar1, (DebitAmountTotal - TDSAmt), '');

                END ELSE BEGIN
                    NumberToText.InitTextVariable;
                    NumberToText.FormatNoText(TextVar1, (CreditAmountTotal - TDSAmt), '');
                END;

            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(Amount);

                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
                TotalAmt := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Show Dimension"; ShowDimensions)
                {
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
        CompanyInfo.CALCFIELDS(Picture);
        Address := CompanyInfo.Address;
        PhoneNo := CompanyInfo."Phone No.";
        FaxNo := CompanyInfo."Fax No.";
        Email := CompanyInfo."E-Mail";

        IF Dimension.GET(GLSetup."Global Dimension 1 Code") THEN
            Dim1Name := Dimension.Name;
        IF Dimension.GET(GLSetup."Global Dimension 2 Code") THEN
            Dim2Name := Dimension.Name;
    end;

    trigger OnPreReport()
    begin
        //to get information from responsibility center
        UserSetup.GET(USERID);

        Info1 := Address + ',' + 'Ph. No.:' + PhoneNo;
        Info2 := 'Fax :' + FaxNo + ',' + 'Email :' + Email;
        CompanyVAT := CompanyInfo."VAT Registration No.";
    end;

    var
        GLSetup: Record "General Ledger Setup";
        HRSetup: Record "Human Resources Setup";
        GLAcc: Record "G/L Account";
        Customer: Record Customer;
        CustomerName: Text[250];
        CustomerAddress: Text[100];
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
        IRDMgt: Codeunit "IRD Mgt.";
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
        ShowDimensions: Boolean;
        NameCaption: Text;
        Vendor: Record Vendor;
        VATAmt: Decimal;
        TotalAmt: Decimal;
        GLEntry1: Record "G/L Entry";
        Vend: Record Vendor;
        TDSRec: Record "TDS Entry";
        TDSAmt: Decimal;
}

