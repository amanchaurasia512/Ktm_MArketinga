tableextension 50448 "Default Dimension_ktm" extends "Default Dimension"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Table Caption"(Field 6)".

        modify(ParentId)
        {
            TableRelation = IF ("Table ID" = CONST(15)) "G/L Account".Id ELSE
            IF ("Table ID" = CONST(18)) Customer.Id ELSE
            IF ("Table ID" = CONST(23)) Vendor.Id ELSE
            IF ("Table ID" = CONST(5200)) Employee.Id;
        }
        field(50000; Salesperson; Text[50])
        {
        }
    }
}

