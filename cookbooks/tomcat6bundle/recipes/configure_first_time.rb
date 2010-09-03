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

bash "save_settings_in_file" do
  code <<-EOH
cat <<EOL >> /root/bundle_settings.txt
Mysql hostname - #{node[:tomcat6bundle][:db_host]}
Mysql dbname   - #{node[:tomcat6bundle][:db_name]}
Mysql login    - #{node[:tomcat6bundle][:db_login]}
Mysql password - #{node[:tomcat6bundle][:db_password]}
------------------------
Tomcat6 homedir   - #{node[:tomcat6][:catalina_home]}
Tomcat6 basedir   - #{node[:tomcat6][:catalina_base]}
Tomcat6 configdir - #{node[:tomcat6][:config_dir]}
EOL
EOH
end
