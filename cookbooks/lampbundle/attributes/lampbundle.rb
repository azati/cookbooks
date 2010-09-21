set_unless[:lampbundle][:db_host]              = "localhost"
set_unless[:lampbundle][:db_login]             = "lampbundle"
set_unless[:lampbundle][:db_password]          = generate_random_password 20
set_unless[:lampbundle][:db_name]              = "lampbundle"

set_unless[:lampbundle][:domain_name]          = ""

set_unless[:lampbundle][:service_email]        = "restart"
set_unless[:lampbundle][:service_web]          = "restart"
set_unless[:lampbundle][:system_stack]         = "restart"
