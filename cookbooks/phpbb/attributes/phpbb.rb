set[:phpbb][:login]                   = "admin"

set_unless[:phpbb][:db_host]              = "localhost"
set_unless[:phpbb][:db_name]              = "phpbb"
set_unless[:phpbb][:db_login]             = "phpbb"
set_unless[:phpbb][:db_password]          = generate_random_password 20

set_unless[:phpbb][:service_email]        = "restart"
set_unless[:phpbb][:service_web]          = "restart"
set_unless[:phpbb][:system_stack]         = "restart"