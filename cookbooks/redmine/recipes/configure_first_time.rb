node[:redmine][:login]            = node[:params][:user_name]
node[:redmine][:password]         = node[:params][:password]

mysql_reset_root_password

mysql_grant node[:redmine][:db_name] do
  db_login      node[:redmine][:db_login]
  db_host       node[:redmine][:db_host]
  db_password   node[:redmine][:db_password]
  action        :run
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

ruby_block "output" do
  block do
     Chef::Log.info "Redmine User - #{node[:redmine][:login]}"
     Chef::Log.info "Redmine Password - #{node[:redmine][:password]}"
  end
end
