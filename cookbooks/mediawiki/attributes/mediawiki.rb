set[:mediawiki][:login]                   = "WikiSysop"

set_unless[:mediawiki][:db_host]              = "localhost"
set_unless[:mediawiki][:db_name]              = "wikidb"
set_unless[:mediawiki][:db_login]             = "wikiuser"
set_unless[:mediawiki][:db_password]          = generate_random_password 20

set_unless[:mediawiki][:service_email]        = "restart"
set_unless[:mediawiki][:service_web]          = "restart"
set_unless[:mediawiki][:system_stack]         = "restart"
