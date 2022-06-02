pageextension 50429 "pageextension70000028" extends "Reverse Entries"
{

    //Unsupported feature: Property Modification (InsertAllowed) on ""Reverse Entries"(Page 179)".


    //Unsupported feature: Property Modification (DeleteAllowed) on ""Reverse Entries"(Page 179)".

    actions
    {
        modify(Reverse)
        {
            trigger OnAfterAction()
            begin
                ReverseEntry.RESET;
                ReverseEntry.SETFILTER("Document No.", '<>%1', Rec."Document No.");
                IF ReverseEntry.FINDFIRST THEN
                    ERROR('Different documents are not allowed to be posted');
                Post_ktm(false);
            end;
        }

        modify("Reverse and &Print")
        {
            trigger OnAfterAction()
            begin
                ReverseEntry.RESET;
                ReverseEntry.SETFILTER("Document No.", '<>%1', Rec."Document No.");
                IF ReverseEntry.FINDFIRST THEN
                    ERROR('Different documents are not allowed to be posted');
                Post_ktm(TRUE);
            end;
        }

    }
    procedure Post_ktm(PrintRegister: Boolean)  //local procedure copied form base file
    var
        ReversalPost: Codeunit "Reversal-Post";
    begin
        ReversalPost.SetPrint(PrintRegister);
        ReversalPost.Run(Rec);
        CurrPage.Update(false);
        CurrPage.Close;
    end;

    var
        ReverseEntry: Record "Reversal Entry";


}

