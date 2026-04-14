resource_group_name = "rg-secure-free-lab"
location            = "westeurope"

tags = {
  environment = "dev"
  project     = "secure-lab"
  owner       = "Vitalii Korneliuk"
}

vnet_name               = "vnet-secure"
vnet_address_space      = ["10.0.0.0/16"]
subnet_name             = "subnet-secure"
subnet_address_prefixes = ["10.0.1.0/24"]
nsg_name                = "nsg-secure"
storage_account_name    = "securestoragelab12345"
allowed_admin_ip        = "84.40.152.152/32"