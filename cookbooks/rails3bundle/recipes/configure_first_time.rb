#node[:rails3bundle][:login]            = node[:params][:user_name]
node[:rails3bundle][:password]         = node[:params][:password]
node[:rails3bundle][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:rails3bundle][:db_name_development] do
  action :run
  db_login node[:rails3bundle][:db_login]
  db_host node[:rails3bundle][:db_host]
  db_password node[:rails3bundle][:db_password]
end
mysql_grant node[:rails3bundle][:db_name_production] do
  action :run
  db_login node[:rails3bundle][:db_login]
  db_host node[:rails3bundle][:db_host]
  db_password node[:rails3bundle][:db_password]
end
mysql_grant node[:rails3bundle][:db_name_test] do
  action :run
  db_login node[:rails3bundle][:db_login]
  db_host node[:rails3bundle][:db_host]
  db_password node[:rails3bundle][:db_password]
end

template "#{node[:rails3bundle][:dir]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

bash "save_settings_in_file" do
  code <<-EOH
cat <<EOL >> /root/bundle_settings.txt
Mysql hostname            - #{node[:rails3bundle][:db_host]}
Mysql dbname development  - #{node[:rails3bundle][:db_name_development]}
Mysql dbname production   - #{node[:rails3bundle][:db_name_production]}
Mysql dbname test         - #{node[:rails3bundle][:db_name_test]}
Mysql login               - #{node[:rails3bundle][:db_login]}
Mysql password            - #{node[:rails3bundle][:db_password]}
------------------------
Rails app dir - #{node[:rails3bundle][:dir]}
Thin config file - /etc/thin
EOL
EOH
end
