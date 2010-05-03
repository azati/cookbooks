#Joomla

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

execute "perl -p -i -e 's/display_errors = On/display_errors = Off/' #{node[:php][:dir]}/php.ini" do
  action :run
end

service "apache2" do
  action :start
end

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:joomla][:db_name]} DEFAULT CHARACTER SET utf8;" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:joomla][:db_name]}.* TO '#{node[:joomla][:db_login]}'@'#{node[:joomla][:db_host]}' IDENTIFIED BY '#{node[:joomla][:db_password]}';" do
  action :execute
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/Joomla_1.5.15-Stable-Full_Package.zip" do
  source "Joomla_1.5.15-Stable-Full_Package.zip"
end

bash "unpack_joomla" do
  code <<-EOH
cd /mnt/tmp
unzip -q Joomla_1.5.15-Stable-Full_Package.zip -d #{node[:apache][:default_docroot]}
mv -f #{node[:apache][:default_docroot]}/htaccess.txt #{node[:apache][:default_docroot]}/.htaccess
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
      Chef::Log.info "Now configure your Joomla application with following settings."
      Chef::Log.info "Mysql host: #{node[:joomla][:db_host]}"
      Chef::Log.info "Mysql database: #{node[:joomla][:db_name]}"
      Chef::Log.info "Mysql login: #{node[:joomla][:db_login]}"
      Chef::Log.info "Mysql password: #{node[:joomla][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
