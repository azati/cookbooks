set[:redmine][:dir]                         = "/var/redmine"
set[:redmine][:svn_dir]                     = "/var/svn"

set_unless[:redmine][:login]                = "admin"
set_unless[:redmine][:password]             = generate_random_password 8

set_unless[:redmine][:db_host]              = "localhost"
set_unless[:redmine][:db_login]             = "redmine"
set_unless[:redmine][:db_password]          = generate_random_password 20
set_unless[:redmine][:db_name]              = "redmine"

set_unless[:redmine][:service_email]        = "restart"
set_unless[:redmine][:service_web]          = "restart"
set_unless[:redmine][:system_stack]         = "restart"

set_unless[:redmine][:certificates][:path]         = "/usr/local/nginx/conf"
set_unless[:redmine][:certificates][:private_key]  = ""
set_unless[:redmine][:certificates][:cert]         = ""
set_unless[:redmine][:certificates][:ca_cert]      = ""
