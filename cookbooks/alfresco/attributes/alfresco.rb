set[:alfresco][:data_dir]                    = "/opt/AlfrescoData"

set[:alfresco][:openoffice_path]             = "/usr/bin/soffice"
set[:alfresco][:imagemagick_path]            = "/usr"
set[:alfresco][:swftools_path]               = "/usr/bin/pdf2swf"

set_unless[:alfresco][:login]                = "admin"

set_unless[:alfresco][:db_host]              = "localhost"
set_unless[:alfresco][:db_name]              = "alfresco"
set_unless[:alfresco][:db_login]             = "alfresco"
set_unless[:alfresco][:db_password]          = generate_random_password 20

set_unless[:alfresco][:domain_name]          = ""

set_unless[:alfresco][:encrypted_password]   = ""

set_unless[:alfresco][:service_email]        = "restart"
set_unless[:alfresco][:service_web]          = "restart"
set_unless[:alfresco][:system_stack]         = "restart"