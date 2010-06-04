#node[:sugarce_funambol][:sugar_login]            = node[:params][:user_name]
node[:sugarce_funambol][:sugar_password]         = node[:params][:password]
node[:sugarce_funambol][:domain_name]            = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:sugarce_funambol][:sugar_db_name] do
  action :run
  db_host node[:sugarce_funambol][:sugar_db_host]
  db_login node[:sugarce_funambol][:sugar_db_login]
  db_password node[:sugarce_funambol][:sugar_db_password]
end

mysql_grant node[:sugarce_funambol][:funambol_db_name] do
  action :run
  db_login node[:sugarce_funambol][:funambol_db_login]
  db_host node[:sugarce_funambol][:funambol_db_host]
  db_password node[:sugarce_funambol][:funambol_db_password]
end

bash "update_config" do
  code <<-EOH
perl -p -i -e "s/\'db_password\' => \'.*\'/\'db_password\' => \'#{node[:sugarce_funambol][:sugar_db_password]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'db_user_name\' => \'.*\'/\'db_user_name\' => \'#{node[:sugarce_funambol][:sugar_db_login]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'db_name\' => \'.*\'/\'db_name\' => \'#{node[:sugarce_funambol][:sugar_db_name]}\'/" #{node[:apache][:default_docroot]}/config.php
EOH
end

template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/ds-server/install.properties" do
  source "install.properties.erb"
  backup false
end

template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/config/com/funambol/server/db/db.xml" do
  source "db.xml.erb"
  backup false
end

mysql_command "UPDATE #{node[:sugarce_funambol][:sugar_db_name]}.users SET user_hash=MD5('#{node[:sugarce_funambol][:sugar_password]}') WHERE user_name='#{node[:sugarce_funambol][:sugar_login]}'" do
  action :execute
end

sugarce_funambol_update_domain node[:sugarce_funambol][:domain_name]
