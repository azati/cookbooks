set[:otrs][:dir]                                = "/opt/otrs"
set[:otrs][:user]                               = "otrs"
set[:otrs][:login]                              = "root@localhost"

set_unless[:otrs][:db_host]                     = "localhost"
set_unless[:otrs][:db_name]                     = "otrs"
set_unless[:otrs][:db_login]                    = "otrs"
set_unless[:otrs][:db_password]                 = generate_random_password 20

set_unless[:otrs][:encrypted_password]   = ""

set_unless[:otrs][:service_email]        = "restart"
set_unless[:otrs][:service_web]          = "restart"
set_unless[:otrs][:system_stack]         = "restart"
