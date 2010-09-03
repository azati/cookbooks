set_unless[:tomcat6bundle][:db_host]              = "localhost"
set_unless[:tomcat6bundle][:db_login]             = "tomcat6bundle"
set_unless[:tomcat6bundle][:db_password]          = generate_random_password 20
set_unless[:tomcat6bundle][:db_name]              = "tomcat6bundle"

set_unless[:tomcat6bundle][:domain_name]          = ""

set_unless[:tomcat6bundle][:service_email]        = "restart"
set_unless[:tomcat6bundle][:service_web]          = "restart"
set_unless[:tomcat6bundle][:system_stack]         = "restart"
