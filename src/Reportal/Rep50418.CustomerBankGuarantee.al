report 50418 "Customer Bank Guarantee"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerBankGuarantee.rdlc';
    Caption = 'Customer Bank Guarantee ';

    dataset
    {
        dataitem("Area"; "Area")
        {
            RequestFilterFields = "Customer No.";
            column(AllFilter; AllFilter)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddr; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyVatRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CustomerNo_BankGuaranteeDetails; "Area"."Customer No.")
            {
            }
            column(StartDateAD_BankGuaranteeDetails; StartDate)
            {
            }
            column(EndDateAD_BankGuaranteeDetails; EndDate)
            {
            }
            column(BGAmount_BankGuaranteeDetails; "Area"."BG Amount")
            {
            }
            column(CustomerName_BankGuaranteeDetails; "Area"."Customer Name")
            {
            }
            column(ShortcutDimension1Code_BankGuaranteeDetails; "Area"."Shortcut Dimension 1 Code")
            {
            }
            column(ReminderDays_BankGuaranteeDetails; "Area"."Reminder Days")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Area".CALCFIELDS("Start Date (BS)");
                "Area".CALCFIELDS("End Date (BS)");

                StartDate := FORMAT("Area"."Start Date (AD)") + '(' + "Area"."Start Date (BS)" + ')';
                EndDate := FORMAT("Area"."End Date (AD)") + '(' + "Area"."End Date (BS)" + ')';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        AllFilter := "Area".GETFILTERS;
        CompanyInfo.GET;
    end;

    var
        AllFilter: Text;
        SMTPMailSetup: Record "SMTP Mail Setup";
        ReminderDays: Integer;
        CompanyInfo: Record "Company Information";
        StartDate: Text;
        EndDate: Text;
}

