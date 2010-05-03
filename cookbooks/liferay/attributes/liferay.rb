set[:liferay][:data_dir]                        = "/opt/liferay-data"

set_unless[:liferay][:login]                = "test@liferay.com"

set_unless[:liferay][:db_host]              = "localhost"
set_unless[:liferay][:db_name]              = "lportal"
set_unless[:liferay][:db_login]             = "liferay"
set_unless[:liferay][:db_password]          = generate_random_password 20

set_unless[:liferay][:service_email]        = "restart"
set_unless[:liferay][:service_web]          = "restart"
set_unless[:liferay][:system_stack]         = "restart"