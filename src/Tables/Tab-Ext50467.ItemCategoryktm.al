tableextension 50467 "Item Category_ktm" extends "Item Category"
{
    fields
    {
        field(4; "Def. Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Def. Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(5; "Def. Inventory Posting Group"; Code[10])
        {
            Caption = 'Def. Inventory Posting Group';
            TableRelation = "Inventory Posting Group".Code;
        }
        field(6; "Def. Tax Group Code"; Code[10])
        {
            Caption = 'Def. Tax Group Code';
            TableRelation = "Tax Group".Code;
        }
        field(7; "Def. Costing Method"; Option)
        {
            Caption = 'Def. Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(8; "Def. VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Def. VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(50000; "Integrate to Bizom"; Boolean)
        {
        }
    }
}

