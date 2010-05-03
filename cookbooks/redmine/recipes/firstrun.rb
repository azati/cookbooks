node[:redmine][:login]            = node[:params][:user_name]
node[:redmine][:password]         = node[:params][:password]

service "nagios" do
  action :stop
end

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "GRANT ALL PRIVILEGES ON #{node[:redmine][:db_name]}.* TO '#{node[:redmine][:db_login]}'@'#{node[:redmine][:db_host]}' IDENTIFIED BY '#{node[:redmine][:db_password]}';" do
  action :execute
end

mysql_command "UPDATE #{node[:redmine][:db_name]}.users SET hashed_password=sha1('#{node[:redmine][:password]}') WHERE login='#{node[:redmine][:login]}';" do
  action :execute
end

template "#{node[:redmine][:dir]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

template "#{node[:apache][:sites_available]}/subversion" do
  source "subversion.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

redmine_service_web do
  action :restart
end

ruby_block "output" do
  block do
     Chef::Log.info "Redmine User - #{node[:redmine][:login]}"
     Chef::Log.info "Redmine Password - #{node[:redmine][:password]}"
  end
end
