set[:sugarce_funambol][:sugar_version]                     = "5.5.2"

set[:sugarce_funambol][:funambol_pkg_name]                 = "funambol-8.5.1.sfx.gz"
set[:sugarce_funambol][:funambol_jc_name]                  = "mysql-connector-java-5.1.12-bin.jar"
set[:sugarce_funambol][:connector_name]                    = "funambol-sugarcrm-connector-8.0.5.s4j"

set[:sugarce_funambol][:funambol_data_dir]                 = "/opt"

set_unless[:sugarce_funambol][:sugar_login]                = "admin"

set_unless[:sugarce_funambol][:sugar_db_host]              = "localhost"
set_unless[:sugarce_funambol][:sugar_db_name]              = "sugarcrm"
set_unless[:sugarce_funambol][:sugar_db_login]             = "sugarcrm"
set_unless[:sugarce_funambol][:sugar_db_password]          = generate_random_password 20

set_unless[:sugarce_funambol][:funambol_db_host]           = "localhost"
set_unless[:sugarce_funambol][:funambol_db_name]           = "funambol"
set_unless[:sugarce_funambol][:funambol_db_login]          = "funambol"
set_unless[:sugarce_funambol][:funambol_db_password]       = generate_random_password 20

set_unless[:sugarce_funambol][:domain_name]                = ""

set_unless[:sugarce_funambol][:service_email]              = "restart"
set_unless[:sugarce_funambol][:service_web]                = "restart"
set_unless[:sugarce_funambol][:system_stack]               = "restart"
