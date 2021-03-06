#just know this parameters come from shino
#node[:joomla][:login]            = node[:params][:user_name]
node[:joomla][:password]         = node[:params][:password]
node[:joomla][:domain_name]      = node[:params][:domain_name]
node[:proftpd][:login]           = node[:params][:ftp_login]
node[:proftpd][:password]        = node[:params][:ftp_password]

proftpd_update_password node[:proftpd][:login] do
  action :update
  password node[:proftpd][:password]
  system_login node[:apache][:user]
end

encrypt_joomla_pass node[:joomla][:password]

mysql_reset_root_password

mysql_grant node[:joomla][:db_name] do
  db_login      node[:joomla][:db_login]
  db_host       node[:joomla][:db_host]
  db_password   node[:joomla][:db_password]
  action        :run
end

mysql_command "UPDATE #{node[:joomla][:db_name]}.jos_users SET password='#{node[:joomla][:encrypted_password]}' WHERE name='Administrator';" do
  action :execute
end

#amazing :/
bash "update_config" do
  code <<-EOH
perl -p -i -e "s/var \\\\\\$host =.*/var \\\\\\$host = \'#{node[:joomla][:db_host]}\';/" #{node[:apache][:default_docroot]}/configuration.php
perl -p -i -e "s/var \\\\\\$user =.*/var \\\\\\$user = \'#{node[:joomla][:db_login]}\';/" #{node[:apache][:default_docroot]}/configuration.php
perl -p -i -e "s/var \\\\\\$password =.*/var \\\\\\$password = \'#{node[:joomla][:db_password]}\';/" #{node[:apache][:default_docroot]}/configuration.php
perl -p -i -e "s/var \\\\\\$db =.*/var \\\\\\$db = \'#{node[:joomla][:db_name]}\';/" #{node[:apache][:default_docroot]}/configuration.php
EOH
end

log "Joomla User - #{node[:joomla][:login]}"
log "Joomla Password - #{node[:joomla][:password]}"
