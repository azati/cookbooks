set[:magento][:version]                     = "1.4.1.1"
set[:magento][:installer_version]           = "1.3.2.1"

set_unless[:magento][:login]                = "admin"
set_unless[:magento][:salt]                 = generate_random_password 2

set_unless[:magento][:db_host]              = "localhost"
set_unless[:magento][:db_login]             = "magento"
set_unless[:magento][:db_password]          = generate_random_password 20
set_unless[:magento][:db_name]              = "magento"

set_unless[:magento][:encryption_key]       = generate_random_password 20

set_unless[:magento][:domain_name]          = ""

set_unless[:magento][:service_email]        = "restart"
set_unless[:magento][:service_web]          = "restart"
set_unless[:magento][:system_stack]         = "restart"
