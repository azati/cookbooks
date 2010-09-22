#Rails stack

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"

unless node[:azati][:stack]
  include_recipe "ruby"
  include_recipe "ruby::rubygems"
end

include_recipe "ruby::rails"

gem_package "mysql2" do
  action :install
end

gem_package "thin" do
  action :install
end

include_recipe "nginx"
include_recipe "nginx::maintenance_site"

remote_file "#{node[:nginx][:dir]}/conf/nginx.conf" do
  source "nginx.conf.nossl"
  backup false
end
remote_file "#{node[:nginx][:dir]}/conf/nginx.conf.nossl-maintenance" do
  source "nginx.conf.nossl-maintenance"
end
remote_file "#{node[:nginx][:dir]}/conf/nginx.conf.ssl" do
  source "nginx.conf.ssl"
end
remote_file "#{node[:nginx][:dir]}/conf/nginx.conf.ssl-maintenance" do
  source "nginx.conf.ssl-maintenance"
end

service "nginx" do
  action :start
end

mysql_reset_root_password

mysql_create_db node[:rails3bundle][:db_name_development] do
  action :create
  charset "utf8"
end
mysql_create_db node[:rails3bundle][:db_name_production] do
  action :create
  charset "utf8"
end
mysql_create_db node[:rails3bundle][:db_name_test] do
  action :create
  charset "utf8"
end

mysql_grant node[:rails3bundle][:db_name_development] do
  action :run
  db_login node[:rails3bundle][:db_login]
  db_host node[:rails3bundle][:db_host]
  db_password node[:rails3bundle][:db_password]
end
mysql_grant node[:rails3bundle][:db_name_production] do
  action :run
  db_login node[:rails3bundle][:db_login]
  db_host node[:rails3bundle][:db_host]
  db_password node[:rails3bundle][:db_password]
end
mysql_grant node[:rails3bundle][:db_name_test] do
  action :run
  db_login node[:rails3bundle][:db_login]
  db_host node[:rails3bundle][:db_host]
  db_password node[:rails3bundle][:db_password]
end

bash "default_app" do
  code <<-EOH
cd #{node[:rails3bundle][:base_dir]}
rails new #{node[:rails3bundle][:appname]} -d mysql
EOH
end

template "#{node[:rails3bundle][:dir]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

rake "db:migrate" do
  action :run
  cwd node[:rails3bundle][:dir]
end

execute "install_thin"  do
  command "thin install"
  action :run
end

execute "thin_config" do
  command "thin config -C /etc/thin/Rails.yml -c #{node[:rails3bundle][:dir]} --servers 6 -e production -p 3000"
  action :run
end

service "thin" do
  action [ :enable, :start ]
end

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end

  include_recipe "monitoring"
end

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "Rails bundle successully installed."
      Chef::Log.info "Mysql hostname - #{node[:rails3bundle][:db_host]}"
      Chef::Log.info "Mysql dbname   - #{node[:rails3bundle][:db_name]}"
      Chef::Log.info "Mysql login    - #{node[:rails3bundle][:db_login]}"
      Chef::Log.info "Mysql password - #{node[:rails3bundle][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
