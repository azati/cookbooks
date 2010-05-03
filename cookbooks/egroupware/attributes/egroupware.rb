set[:egroupware][:files_path]                   = "/var/egroup-files"
set[:egroupware][:backup_path]                  = "/var/egroup-backup"

set_unless[:egroupware][:db_host]              = "localhost"
set_unless[:egroupware][:db_login]             = "egroupware"
set_unless[:egroupware][:db_password]          = generate_random_password 20
set_unless[:egroupware][:db_name]              = "egroupware"

set_unless[:egroupware][:encrypted_password]   = ""

set_unless[:egroupware][:service_email]        = "restart"
set_unless[:egroupware][:service_web]          = "restart"
set_unless[:egroupware][:system_stack]         = "restart"