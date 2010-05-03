#phpBB

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-mysql"
include_recipe "php::php-imap"
include_recipe "php::php-mbstring"
include_recipe "php::php-gd"
include_recipe "php::php-eaccelerator"

package "imagemagick" do
  action :install
end

service "apache2" do
  action :start
end

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:phpbb][:db_name]} DEFAULT CHARACTER SET utf8;" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:phpbb][:db_name]}.* TO '#{node[:phpbb][:db_login]}'@'#{node[:phpbb][:db_host]}' IDENTIFIED BY '#{node[:phpbb][:db_password]}';" do
  action :execute
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/phpBB-3.0.7-PL1.tar.bz2" do
  source "phpBB-3.0.7-PL1.tar.bz2"
end

bash "unpack_phpbb" do
  code <<-EOH
cd /mnt/tmp
tar -xjf phpBB-3.0.7-PL1.tar.bz2
mv -f phpBB3/* #{node[:apache][:default_docroot]}
mv -f phpBB3/.htaccess #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:user]} #{node[:apache][:default_docroot]}
EOH
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

#To mysql monitoring work properly, we have to create nagios mysql user.
mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
  action :execute
end

include_recipe "monitoring"

service "cron" do
  action :enable
end

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

ruby_block "show_mysql_root_password" do
  block do
    loop do
      Chef::Log.info "Now configure your phpBB application with following settings."
      Chef::Log.info "Mysql host: #{node[:phpbb][:db_host]}"
      Chef::Log.info "Mysql database: #{node[:phpbb][:db_name]}"
      Chef::Log.info "Mysql login: #{node[:phpbb][:db_login]}"
      Chef::Log.info "Mysql password: #{node[:phpbb][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
