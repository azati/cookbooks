#node[:tomcat6bundle][:login]                     = node[:params][:user_name]
node[:tomcat6bundle][:password]                   = node[:params][:password]
node[:tomcat6bundle][:domain_name]                = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:tomcat6bundle][:db_name] do
  action :run
  db_host node[:tomcat6bundle][:db_host]
  db_login node[:tomcat6bundle][:db_login]
  db_password node[:tomcat6bundle][:db_password]
end

tomcat6_setup_proxy node[:tomcat6bundle][:domain_name]
