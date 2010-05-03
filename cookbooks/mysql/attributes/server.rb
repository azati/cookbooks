set[:mysql][:dir]                       = "/etc/mysql"

set_unless[:mysql][:host]               = "localhost"
set_unless[:mysql][:root_password]      = ""

set_unless[:mysql][:log_slow_queries]           = "/var/log/mysql-slow.log"
set_unless[:mysql][:long_query_time]            = 7

set_unless[:mysql][:max_connections]            = 500
set_unless[:mysql][:wait_timeout]               = 10
set_unless[:mysql][:connect_timeout]            = 30
set_unless[:mysql][:max_connect_errors]         = 100

set_unless[:mysql][:key_buffer]                 = "256M"
set_unless[:mysql][:max_allowed_packet]         = "2M"
set_unless[:mysql][:table_cache]                = 512
set_unless[:mysql][:sort_buffer_size]           = "64M"
set_unless[:mysql][:join_buffer_size]           = "128M"

set_unless[:mysql][:read_buffer_size]           = "8M"
set_unless[:mysql][:read_rnd_buffer_size]       = "64M"
set_unless[:mysql][:myisam_sort_buffer_size]    = "64M"
set_unless[:mysql][:query_cache_size]           = "256M"
set_unless[:mysql][:query_cache_limit]          = "8M"

set_unless[:mysql][:innodb_additional_mem_pool_size]    = "256M"
set_unless[:mysql][:innodb_buffer_pool_size]            = "512M"
set_unless[:mysql][:innodb_thread_concurrency]          = 0
set_unless[:mysql][:innodb_flush_log_at_trx_commit]     = 1

set_unless[:mysql][:thread_cache_size]                = 8

set_unless[:mysql][:isamchk][:key_buffer]             = "128M"
set_unless[:mysql][:isamchk][:sort_buffer_size]       = "128M"
set_unless[:mysql][:isamchk][:read_buffer]            = "2M"
set_unless[:mysql][:isamchk][:write_buffer]           = "2M"

set_unless[:mysql][:myisamchk][:key_buffer]           = "128M"
set_unless[:mysql][:myisamchk][:sort_buffer_size]     = "128M"
set_unless[:mysql][:myisamchk][:read_buffer]          = "2M"
set_unless[:mysql][:myisamchk][:write_buffer]         = "2M"

set_unless[:mysql][:mysqld_safe][:log_error]          = "/var/log/mysqld.log"
