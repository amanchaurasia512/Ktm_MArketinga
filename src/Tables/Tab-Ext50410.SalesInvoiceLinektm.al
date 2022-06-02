tableextension 50410 "Sales Invoice Line_ktm" extends "Sales Invoice Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Bill-to Customer No."(Field 68)".


        //Unsupported feature: Property Modification (Editable) on ""Dimension Set ID"(Field 480)".

        field(50501; "Localized VAT Identifier"; Option)
        {
            Description = 'NP15.1001';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(50502; "Returned Document No."; Code[20])
        {
        }
        field(50602; "RBI Product Code"; Code[10])
        {
        }
        field(70000; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(70001; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(70002; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(70003; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(70004; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(70005; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
    }


    //Unsupported feature: Property Modification (Id) on "SalesInvoiceHeader(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //SalesInvoiceHeader : 1002;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SalesInvoiceHeader : 1999;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Currency(Variable 1003)".

    //var
    //>>>> ORIGINAL VALUE:
    //Currency : 1003;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Currency : 1998;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DimMgt(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //DimMgt : 1001;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DimMgt : 1997;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "UOMMgt(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //UOMMgt : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //UOMMgt : 1996;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "DeferralUtilities(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //DeferralUtilities : 1000;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DeferralUtilities : 1995;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PriceDescriptionTxt(Variable 1004)".

    //var
    //>>>> ORIGINAL VALUE:
    //PriceDescriptionTxt : 1004;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PriceDescriptionTxt : 1994;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "PriceDescriptionWithLineDiscountTxt(Variable 1066)".

    //var
    //>>>> ORIGINAL VALUE:
    //PriceDescriptionWithLineDiscountTxt : 1066;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PriceDescriptionWithLineDiscountTxt : 1993;
    //Variable type has not been exported.

    var
        Item: Record Item;
}

