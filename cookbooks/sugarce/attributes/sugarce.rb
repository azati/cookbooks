set_unless[:sugarce][:login]                = "admin"

set_unless[:sugarce][:db_host]              = "localhost"
set_unless[:sugarce][:db_login]             = "sugarcrm"
set_unless[:sugarce][:db_password]          = generate_random_password 20
set_unless[:sugarce][:db_name]              = "sugarcrm"

set_unless[:sugarce][:domain_name]          = ""

set_unless[:sugarce][:service_email]        = "restart"
set_unless[:sugarce][:service_web]          = "restart"
set_unless[:sugarce][:system_stack]         = "restart"
