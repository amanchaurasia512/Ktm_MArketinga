tableextension 50440 "Purchases & Payables Setup_ktm" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50501; "Purchase Consignment Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(60003; "Show Description From"; Option)
        {
            OptionCaption = 'Default,Posting Groups';
            OptionMembers = Default,"Posting Groups";
        }
        field(60004; "Item Charge VAT Book"; Text[50])
        {
        }
    }
}

