set[:zencart][:login]                       = "admin"

set_unless[:zencart][:db_host]              = "localhost"
set_unless[:zencart][:db_name]              = "zencart"
set_unless[:zencart][:db_login]             = "zencartuser"
set_unless[:zencart][:db_password]          = generate_random_password 20

set_unless[:zencart][:encrypted_password]   = ""

set_unless[:zencart][:service_email]        = "restart"
set_unless[:zencart][:service_web]          = "restart"
set_unless[:zencart][:system_stack]         = "restart"
