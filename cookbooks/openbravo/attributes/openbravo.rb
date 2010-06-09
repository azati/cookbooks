set[:openbravo][:dir]                         = "/var/openbravo"
set[:openbravo][:attach_path]                 = "/var/openbravo_attachments"
set[:openbravo][:src_path]                    = "/var/openbravo_src"

set[:openbravo][:pkg_name]                    = "OpenbravoERP-2.50MP18.tar.bz2"
set[:openbravo][:pkgfolder_name]              = "OpenbravoERP-2.50MP18"

set[:openbravo][:ant_home]                    = "/usr/share/ant"
set[:openbravo][:ant_opts]                    = "-Xmx2048m -Xms512m -XX:MaxPermSize=512m"

set_unless[:openbravo][:db_host]              = "localhost"
set_unless[:openbravo][:db_name]              = "openbravo"
set_unless[:openbravo][:db_password]          = generate_random_password 20
set_unless[:openbravo][:db_user]              = "tad"

set_unless[:openbravo][:domain_name]          = ""

set_unless[:openbravo][:login]                = "Openbravo"

set_unless[:openbravo][:service_email]        = "restart"
set_unless[:openbravo][:service_web]          = "restart"
set_unless[:openbravo][:system_stack]         = "restart"

set_unless[:openbravo][:encrypted_password]   = ""