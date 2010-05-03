#node[:orangehrm][:login]            = node[:params][:user_name]
node[:orangehrm][:password]         = node[:params][:password]
node[:orangehrm][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:orangehrm][:db_name] do
  db_login      node[:orangehrm][:db_login]
  db_host       node[:orangehrm][:db_host]
  db_password   node[:orangehrm][:db_password]
  action        :run
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

log "orangehrm User - #{node[:orangehrm][:login]}"
log "orangehrm Password - #{node[:orangehrm][:password]}"
