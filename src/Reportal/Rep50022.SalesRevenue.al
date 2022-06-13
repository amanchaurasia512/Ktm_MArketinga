report 50022 "Sales Revenue"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SalesRevenue.rdlc';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
                                WHERE("Gen. Posting Type" = CONST(Sale));
            column(FORMAT_PostingDateFrom____To____FORMAT_PostingDateTo________BranchCode________CostRevenueCode; FORMAT(PostingDateFrom) + ' To ' + FORMAT(PostingDateTo) + ' / ' + GD1Code + ' / ' + GD2Code)
            {
            }
            column(V1_Amount; -1 * Amount)
            {
            }
            column(V1__VAT_Amount_; -1 * "VAT Amount")
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
                IncludeCaption = true;
            }
            column(G_L_Entry__Global_Dimension_2_Code_; "Global Dimension 2 Code")
            {
                IncludeCaption = true;
            }
            column(G_L_Entry__Gen__Prod__Posting_Group_; "Gen. Prod. Posting Group")
            {
            }
            column(GD1; GD1Value)
            {
            }
            column(GD2; GD2Value)
            {
            }
            column(G_L_Entry_Entry_No_; "Entry No.")
            {
            }
            column(G_L_Entry_Gen__Bus__Posting_Group; "Gen. Bus. Posting Group")
            {
            }

            trigger OnAfterGetRecord()
            begin
                GD1Value := '';
                GD2Value := '';

                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 1 Code");
                IF DimensionValue.FINDFIRST THEN
                    GD1Value := DimensionValue.Name;

                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "Global Dimension 2 Code");
                IF DimensionValue.FINDFIRST THEN
                    GD2Value := DimensionValue.Name;
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("Posting Date", '%1..%2', PostingDateFrom, PostingDateTo);
                SETFILTER("Global Dimension 1 Code", GD1Code);
                SETFILTER("Global Dimension 2 Code", GD2Code);
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
                field(PostingDateFrom; PostingDateFrom)
                {
                    Caption = 'Posting Date From';
                }
                field(PostingDateTo; PostingDateTo)
                {
                    Caption = 'Posting Date To';
                }
                field(GD1Code; GD1Code)
                {
                    CaptionClass = '1,3,1';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1));
                }
                field(GD2Code; GD2Code)
                {
                    CaptionClass = '1,3,2';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(2));
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

    var
        PostingDateFrom: Date;
        PostingDateTo: Date;
        GD1Code: Code[250];
        GD2Code: Code[250];
        TotalAmount: Decimal;
        DimensionValue: Record "Dimension Value";
        GD1Value: Text[50];
        GD2Value: Text[50];
}

