#node[:otrs][:login]            = node[:params][:user_name]
node[:otrs][:password]         = node[:params][:password]
node[:otrs][:domain_name]      = node[:params][:domain_name]

encrypt_otrs_pass node[:otrs][:password]

service "nagios" do
  action :stop
end

mysql_reset_root_password

mysql_command "GRANT ALL ON #{node[:otrs][:db_name]}.* TO '#{node[:otrs][:db_login]}'@'#{node[:otrs][:db_host]}' IDENTIFIED BY '#{node[:otrs][:db_password]}';" do
  action :execute
end
mysql_command "UPDATE #{node[:otrs][:db_name]}.users SET pw='#{node[:otrs][:encrypted_password]}' where login='#{node[:otrs][:login]}';" do
  action :execute
end

template "#{node[:otrs][:dir]}/Kernel/Config.pm" do
  source "Config.pm.erb"
end

otrs_service_web do
  action :restart
end

log "OTRS User - #{node[:otrs][:login]}"
log "OTRS Password - #{node[:otrs][:password]}"
