set[:rails3bundle][:base_dir]                    = "/var"
set[:rails3bundle][:appname]                     = "rails"
set[:rails3bundle][:dir]                         = "/var/rails"

set_unless[:rails3bundle][:db_host]              = "localhost"
set_unless[:rails3bundle][:db_login]             = "rails3bundle"
set_unless[:rails3bundle][:db_password]          = generate_random_password 20
set_unless[:rails3bundle][:db_name_development]  = "rails3bundle_development"
set_unless[:rails3bundle][:db_name_production]   = "rails3bundle_production"
set_unless[:rails3bundle][:db_name_test]         = "rails3bundle_test"

set_unless[:rails3bundle][:domain_name]          = ""

set_unless[:rails3bundle][:service_email]        = "restart"
set_unless[:rails3bundle][:service_web]          = "restart"
set_unless[:rails3bundle][:system_stack]         = "restart"

set_unless[:rails3bundle][:certificates][:path]         = "/usr/local/nginx/conf"
set_unless[:rails3bundle][:certificates][:private_key]  = ""
set_unless[:rails3bundle][:certificates][:cert]         = ""
set_unless[:rails3bundle][:certificates][:ca_cert]      = ""
