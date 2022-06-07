report 50419 "Customer Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerDetails.rdlc';

    dataset
    {
        dataitem("Product&Salesperson Posting Gr"; "Product&Salesperson Posting Gr")
        {
            RequestFilterFields = "Customer No.", "Product Segment Code", "Area Code";
            column(AllFilters; AllFilters)
            {
            }
            column(ReportHeading; ReportHeading)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaption)
            {
            }
            column(Company_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyVATNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CustomerNo_ProductSalespersonPostingGr; "Product&Salesperson Posting Gr"."Customer No.")
            {
            }
            column(CustomerName_ProductSalespersonPostingGr; "Product&Salesperson Posting Gr"."Customer Name")
            {
            }
            column(ProductSegmentCode_ProductSalespersonPostingGr; "Product&Salesperson Posting Gr"."Product Segment Code")
            {
            }
            column(AreaCode_ProductSalespersonPostingGr; "Product&Salesperson Posting Gr"."Area Code")
            {
            }
            column(InventoryPostingGroup_ProductSalespersonPostingGr; "Product&Salesperson Posting Gr"."Inventory Posting Group")
            {
            }
            column(CurrentSalesperson_ProductSalespersonPostingGr; "Product&Salesperson Posting Gr"."Current Salesperson")
            {
            }
            column(Address_Customer; Customer.Address)
            {
            }
            column(Address2_Customer; Customer."Address 2")
            {
            }
            column(City_Customer; Customer.City)
            {
            }
            column(Contact_Customer; Customer.Contact)
            {
            }
            column(PhoneNo_Customer; Customer."Phone No.")
            {
            }
            column(CustomerPriceGroup_Customer; Customer."Customer Price Group")
            {
            }
            column(VATRegistrationNo_Customer; Customer."VAT Registration No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Customer.GET("Customer No.");
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
        AllFilters := "Product&Salesperson Posting Gr".GETFILTERS;
        CompanyInfo.GET;
    end;

    var
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        AllFilters: Text;
        CurrReport_PAGENOCaption: Label 'Page';
        ReportHeading: Label 'Product Wise Customer List';
}

