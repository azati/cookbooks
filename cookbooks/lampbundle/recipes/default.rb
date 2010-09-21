#LAMP bundle

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-gd"
include_recipe "php::php-imap"
include_recipe "php::php-mbstring"
include_recipe "php::php-mcrypt"
include_recipe "php::php-curl"
include_recipe "php::php-mysql"
include_recipe "php::php-xml"
include_recipe "php::php-pear"
include_recipe "php::php-eaccelerator"

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

mysql_reset_root_password

mysql_create_db node[:lampbundle][:db_name] do
  action :create
  charset "utf8"
end

mysql_grant node[:lampbundle][:db_name] do
  action :run
  db_login node[:lampbundle][:db_login]
  db_host node[:lampbundle][:db_host]
  db_password node[:lampbundle][:db_password]
end

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end

  include_recipe "monitoring"
end

remote_file "#{node[:apache][:default_docroot]}/index.php" do
  source "index.php"
  backup false
end

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "LAMP bundle successully installed."
      Chef::Log.info "Mysql hostname - #{node[:lampbundle][:db_host]}"
      Chef::Log.info "Mysql dbname   - #{node[:lampbundle][:db_name]}"
      Chef::Log.info "Mysql login    - #{node[:lampbundle][:db_login]}"
      Chef::Log.info "Mysql password - #{node[:lampbundle][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
