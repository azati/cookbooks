#node[:liferay][:login]                     = node[:params][:user_name]
node[:liferay][:password]                   = node[:params][:password]
node[:liferay][:domain_name]                = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:liferay][:db_name] do
  action :run
  db_login node[:liferay][:db_login]
  db_host node[:liferay][:db_host]
  db_password node[:liferay][:db_password]
end

template "#{node[:tomcat6][:config_dir]}/context.xml" do
  source "context.xml.erb"
  backup false
end

mysql_command "UPDATE #{node[:liferay][:db_name]}.User_ SET password_='#{node[:liferay][:password]}', passwordEncrypted=0 WHERE emailAddress='#{node[:liferay][:login]}';" do
  action :execute
end

bash "setup_proxy_and_address" do
  code <<-EOH
perl -p -i -e "s/proxyName=\\"\\S*\\"/proxyName=\\"#{node[:liferay][:domain_name]}\\"/" #{node[:tomcat6][:config_dir]}/server.xml
EOH
end

log "Liferay User - #{node[:liferay][:login]}"
log "Liferay Password - #{node[:liferay][:password]}"