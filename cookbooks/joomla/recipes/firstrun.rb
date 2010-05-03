#node[:joomla][:login]            = node[:params][:user_name]
node[:joomla][:password]         = node[:params][:password]
node[:joomla][:domain_name]      = node[:params][:domain_name]

encrypt_joomla_pass node[:joomla][:password]

service "nagios" do
  action :stop
end

mysql_reset_root_password

mysql_command "GRANT ALL ON #{node[:joomla][:db_name]}.* TO '#{node[:joomla][:db_login]}'@'#{node[:joomla][:db_host]}' IDENTIFIED BY '#{node[:joomla][:db_password]}';" do
  action :execute
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

joomla_service_web do
  action :restart
end

log "Joomla User - #{node[:joomla][:login]}"
log "Joomla Password - #{node[:joomla][:password]}"
