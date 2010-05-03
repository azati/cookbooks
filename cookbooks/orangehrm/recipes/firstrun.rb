#node[:orangehrm][:login]            = node[:params][:user_name]
node[:orangehrm][:password]         = node[:params][:password]
node[:orangehrm][:domain_name]      = node[:params][:domain_name]

service "nagios" do
  action :stop
end

mysql_reset_root_password

mysql_command "GRANT ALL ON #{node[:orangehrm][:db_name]}.* TO '#{node[:orangehrm][:db_login]}'@'#{node[:orangehrm][:db_host]}' IDENTIFIED BY '#{node[:orangehrm][:db_password]}';" do
  action :execute
end
mysql_command "UPDATE #{node[:orangehrm][:db_name]}.hs_hr_users SET user_password=MD5('#{node[:orangehrm][:password]}') WHERE user_name='#{node[:orangehrm][:login]}';" do
  action :execute
end

template "#{node[:apache][:default_docroot]}/lib/confs/Conf.php" do
  source "Conf.php.erb"
  mode "0644"
  owner node[:apache][:user]
  group node[:apache][:user]
  backup false
end

orangehrm_service_web do
  action :restart
end

log "orangehrm User - #{node[:orangehrm][:login]}"
log "orangehrm Password - #{node[:orangehrm][:password]}"
