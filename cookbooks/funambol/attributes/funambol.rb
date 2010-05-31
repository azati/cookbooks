set[:funambol][:data_dir]                           = "/opt"

set_unless[:funambol][:db_host]                     = "localhost"
set_unless[:funambol][:db_name]                     = "funambol"
set_unless[:funambol][:db_login]                    = "funambol"
set_unless[:funambol][:db_password]                 = generate_random_password 20

set[:funambol][:pkg_name]                           = "funambol-8.5.1.sfx.gz"
set[:funambol][:jc_name]                            = "mysql-connector-java-5.1.12-bin.jar"
