set[:joomla][:login]                   = "admin"

set_unless[:joomla][:db_host]              = "localhost"
set_unless[:joomla][:db_login]             = "joomla"
set_unless[:joomla][:db_password]          = generate_random_password 20
set_unless[:joomla][:db_name]              = "joomla"

set_unless[:joomla][:encrypted_password]   = ""

set_unless[:joomla][:service_email]        = "restart"
set_unless[:joomla][:service_web]          = "restart"
set_unless[:joomla][:system_stack]         = "restart"