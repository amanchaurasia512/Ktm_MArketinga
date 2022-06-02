tableextension 50456 "Prepay Inv. Line Buffer_ktm" extends "Prepayment Inv. Line Buffer"
{
    fields
    {

        //Unsupported feature: Property Deletion (CaptionML) on ""Tax Area Code"(Field 24)".

        field(50502; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales,Prepayments';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales",Prepayments;
        }
    }

    [IntegrationEvent(TRUE, false)]
    procedure OnAfterPrepareSalesPrepmt(SalesLine: Record "Sales Line")
    begin
    end;
}

