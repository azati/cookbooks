set[:orangehrm][:login]                   = "demo"

set_unless[:orangehrm][:encrypted_password]   = ""

set_unless[:orangehrm][:db_host]              = "localhost"
set_unless[:orangehrm][:db_name]              = "orangehrm"
set_unless[:orangehrm][:db_login]             = "orangehrm"
set_unless[:orangehrm][:db_password]          = generate_random_password 20

set_unless[:orangehrm][:service_email]        = "restart"
set_unless[:orangehrm][:service_web]          = "restart"
set_unless[:orangehrm][:system_stack]         = "restart"