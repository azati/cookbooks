#node[:otrs][:login]            = node[:params][:user_name]
node[:otrs][:password]         = node[:params][:password]
node[:otrs][:domain_name]      = node[:params][:domain_name]

encrypt_otrs_pass node[:otrs][:password]

mysql_reset_root_password

mysql_grant node[:otrs][:db_name] do
  db_login      node[:otrs][:db_login]
  db_host       node[:otrs][:db_host]
  db_password   node[:otrs][:db_password]
  action        :run
end

mysql_command "UPDATE #{node[:otrs][:db_name]}.users SET pw='#{node[:otrs][:encrypted_password]}' where login='#{node[:otrs][:login]}';" do
  action :execute
end

template "#{node[:otrs][:dir]}/Kernel/Config.pm" do
  source "Config.pm.erb"
end

log "OTRS User - #{node[:otrs][:login]}"
log "OTRS Password - #{node[:otrs][:password]}"
