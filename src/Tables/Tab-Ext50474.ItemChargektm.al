tableextension 50474 "Item Charge_ktm" extends "Item Charge"
{
    fields
    {
        field(50000; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50001; "Include in Purchase Amount"; Boolean)
        {
            Description = 'if the value is true, the item charge amount will be added to the purchase amount in landed cost sheet report';
        }
        field(50002; "Exclude PP in VAT Book"; Boolean)
        {
            Description = 'if the item charge is true then its value will be displayed in different line in purchase vat book';
        }
        field(50003; "Applicable TDS Posting Groups"; Code[100])
        {

            trigger OnLookup()
            var
                TDSPostingGr: Record "TDS Posting Group";
            begin
                //SRT Sept 5th 2019 >>
                TDSPostingGr.RESET;
                IF PAGE.RUNMODAL(0, TDSPostingGr) = ACTION::LookupOK THEN BEGIN
                    IF STRPOS("Applicable TDS Posting Groups", TDSPostingGr.Code) = 0 THEN
                        IF "Applicable TDS Posting Groups" <> '' THEN
                            "Applicable TDS Posting Groups" += '|' + TDSPostingGr.Code
                        ELSE
                            "Applicable TDS Posting Groups" := TDSPostingGr.Code;
                END;
                //SRT Sept 5th 2019
            end;
        }
        field(50004; "Show in VAT Book"; Boolean)
        {
        }
    }
}

