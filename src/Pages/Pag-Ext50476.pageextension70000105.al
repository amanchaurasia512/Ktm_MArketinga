pageextension 50476 "pageextension70000105" extends "Sales Prices"
{

    //Unsupported feature: Code Insertion on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //begin
    /*
    //KMT2016CU5 >>
    "Sales Type" := "Sales Type"::"Customer Price Group";
    "Unit of Measure Code" := 'C/S';
    //KMT2016CU5 <<
    */
    //end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Sales Type" := Rec."Sales Type"::"Customer Price Group";
        Rec."Unit of Measure Code" := 'C/S';
    end;
}

