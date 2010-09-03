# Tomact6 bundle

unless node[:azati][:stack]
  include_recipe "azati::partner_repo"
end

include_recipe "azati::apt_update"

include_recipe "java"
include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "tomcat6"
include_recipe "azati::update_limits"

service "tomcat6" do
  action :stop
end

remote_file "#{node[:apache][:dir]}/conf.d/tomcat6-proxy" do
  source "tomcat6-proxy"
end
remote_file "#{node[:apache][:default_docroot]}/index.html" do
  source "index.html"
  backup false
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:tomcat6bundle][:db_name]} DEFAULT CHARACTER SET utf8;" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:tomcat6bundle][:db_name]}.* TO '#{node[:tomcat6bundle][:db_login]}'@'#{node[:tomcat6bundle][:db_host]}' IDENTIFIED BY '#{node[:tomcat6bundle][:db_password]}';" do
  action :execute
end

tomcat6_setup_proxy node[:amazon][:public_hostname]

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end

  include_recipe "monitoring"
end

service "apache2" do
  action :restart
end

service "tomcat6" do
  action :start
end

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "Tomcat6 bundle successully installed."
      Chef::Log.info "Mysql hostname - #{node[:tomcat6bundle][:db_host]}"
      Chef::Log.info "Mysql dbname   - #{node[:tomcat6bundle][:db_name]}"
      Chef::Log.info "Mysql login    - #{node[:tomcat6bundle][:db_login]}"
      Chef::Log.info "Mysql password - #{node[:tomcat6bundle][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
