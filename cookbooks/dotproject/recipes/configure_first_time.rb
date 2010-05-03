#node[:dotproject][:login]            = node[:params][:user_name]
node[:dotproject][:password]         = node[:params][:password]
node[:dotproject][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:dotproject][:db_name] do
  action        :run
  db_login      node[:dotproject][:db_login]
  db_host       node[:dotproject][:db_host]
  db_password   node[:dotproject][:db_password]
end

template "#{node[:apache][:default_docroot]}/includes/config.php" do
  source "config.php.erb"
  backup false
end

mysql_command "UPDATE #{node[:dotproject][:db_name]}.users SET user_password=MD5('#{node[:dotproject][:password]}') WHERE user_username='#{node[:dotproject][:login]}';" do
  action :execute
end

log "dotProject User - #{node[:dotproject][:login]}"
log "dotProject Password - #{node[:dotproject][:password]}"
