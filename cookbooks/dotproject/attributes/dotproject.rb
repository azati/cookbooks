set[:dotproject][:login]                       = "admin"

set_unless[:dotproject][:db_host]              = "localhost"
set_unless[:dotproject][:db_login]             = "dp_user"
set_unless[:dotproject][:db_password]          = generate_random_password 20
set_unless[:dotproject][:db_name]              = "dotproject"

set_unless[:dotproject][:service_email]        = "restart"
set_unless[:dotproject][:service_web]          = "restart"
set_unless[:dotproject][:system_stack]         = "restart"
