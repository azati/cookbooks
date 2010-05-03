#node[:egroupware][:login]            = node[:params][:user_name]
node[:egroupware][:password]         = node[:params][:password]
node[:egroupware][:domain_name]      = node[:params][:domain_name]

encrypt_egroupware_pass node[:egroupware][:password]

mysql_reset_root_password


mysql_grant node[:egroupware][:db_name] do
  action        :run
  db_login      node[:egroupware][:db_login]
  db_host       node[:egroupware][:db_host]
  db_password   node[:egroupware][:db_password]
end

mysql_command "UPDATE #{node[:egroupware][:db_name]}.egw_accounts SET account_pwd='#{node[:egroupware][:encrypted_password]}' WHERE account_lid='admin';" do
  action :execute
end

bash "update_config" do
  code <<-EOH
perl -p -i -e "s/\\$GLOBALS\\[\\'egw_info\\'\\]\\[\\'server\\'\\]\\[\\'header_admin_password\\'\\].*/\\$GLOBALS\\[\\'egw_info\\'\\]\\[\\'server\\'\\]\\[\\'header_admin_password\\'\\] = \\'#{node[:egroupware][:encrypted_password]}\\';/" #{node[:apache][:default_docroot]}/header.inc.php
perl -p -i -e "s/\\'config_passwd\\' =>.*/\\'config_passwd\\' => \\'#{node[:egroupware][:encrypted_password]}\\'/" #{node[:apache][:default_docroot]}/header.inc.php
perl -p -i -e "s/\\'db_host\\' =>.*/\\'db_host\\' => \\'#{node[:egroupware][:db_host]}\\',/" #{node[:apache][:default_docroot]}/header.inc.php
perl -p -i -e "s/\\'db_name\\' =>.*/\\'db_name\\' => \\'#{node[:egroupware][:db_name]}\\',/" #{node[:apache][:default_docroot]}/header.inc.php
perl -p -i -e "s/\\'db_user\\' =>.*/\\'db_user\\' => \\'#{node[:egroupware][:db_login]}\\',/" #{node[:apache][:default_docroot]}/header.inc.php
perl -p -i -e "s/\\'db_pass\\' =>.*/\\'db_pass\\' => \\'#{node[:egroupware][:db_password]}\\',/" #{node[:apache][:default_docroot]}/header.inc.php
EOH
end

log "eGroupWare User - admin"
log "eGroupWare Password - #{node[:egroupware][:password]}"
