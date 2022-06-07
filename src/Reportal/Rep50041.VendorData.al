report 50041 "Vendor Data"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VendorData.rdlc';

    dataset
    {
        dataitem(DataItem1; Table23)
        {
            RequestFilterFields = "No.";
            column(No_Customer; Vendor."No.")
            {
            }
            column(Name_Customer; Vendor.Name)
            {
            }
            column(Address_Customer; Vendor.Address)
            {
            }
            column(Address2_Customer; Vendor."Address 2")
            {
            }
            column(City_Customer; Vendor.City)
            {
            }
            column(Contact_Customer; Vendor.Contact)
            {
            }
            column(PhoneNo_Customer; Vendor."Phone No.")
            {
            }
            column(VATRegistrationNo_Customer; Vendor."VAT Registration No.")
            {
            }
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
}

