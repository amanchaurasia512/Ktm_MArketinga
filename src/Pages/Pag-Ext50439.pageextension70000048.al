pageextension 50439 "pageextension70000048" extends "Item Journal"
{
    layout
    {
        // modify("Control 21")
        // {
        //     Visible = false;
        // }
        // modify("Control 19")
        // {
        //     Visible = false;
        // }

        addlast(content)
        {

            field("Transfer Receipt No."; Rec."Transfer Receipt No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            // {
            //     Visible = true;
            // }
            // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
            // {
            //     Visible = true;
            // }
            field("ShortcutDimCode[3]"; ShortcutDimCode[3])
            {
                ApplicationArea = all;
                CaptionClass = '1,2,3';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                              "Dimension Value Type" = CONST(Standard),
                                                              Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                end;
            }
            field("ShortcutDimCode[4]"; ShortcutDimCode[4])
            {
                ApplicationArea = all;
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                              "Dimension Value Type" = CONST(Standard),
                                                              Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                end;
            }
            field("ShortcutDimCode[5]"; ShortcutDimCode[5])
            {
                ApplicationArea = all;
                CaptionClass = '1,2,5';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                              "Dimension Value Type" = CONST(Standard),
                                                              Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                end;
            }
            field("ShortcutDimCode[6]"; ShortcutDimCode[6])
            {
                ApplicationArea = all;
                CaptionClass = '1,2,6';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                             "Dimension Value Type" = CONST(Standard),
                                                              Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                end;
            }
            field("ShortcutDimCode[7]"; ShortcutDimCode[7])
            {
                ApplicationArea = all;
                CaptionClass = '1,2,7';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                              "Dimension Value Type" = CONST(Standard),
                                                              Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                end;
            }
            field("ShortcutDimCode[8]"; ShortcutDimCode[8])
            {
                ApplicationArea = all;
                CaptionClass = '1,2,8';
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                              "Dimension Value Type" = CONST(Standard),
                                                              Blocked = CONST(false));
                Visible = false;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                end;
            }
        }
    }
}

