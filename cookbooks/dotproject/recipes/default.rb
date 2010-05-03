#dotProject

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-imap"
include_recipe "php::php-mbstring"
include_recipe "php::php-mysql"
include_recipe "php::php-xml"
include_recipe "php::php-gd"
include_recipe "php::php-eaccelerator"

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
  action :execute
end

mysql_command "create database #{node[:dotproject][:db_name]} default character set utf8;" do
  action :execute
end
mysql_command "grant all on #{node[:dotproject][:db_name]}.* to '#{node[:dotproject][:db_login]}'@'#{node[:dotproject][:db_host]}' identified by '#{node[:dotproject][:db_password]}';" do
  action :execute
end

service "apache2" do
  action :start
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/dotproject_2_1_3.zip" do
  source "dotproject_2_1_3.zip"
end

bash "unpack_dotproject" do
  code <<-EOH
cd /mnt/tmp
unzip -q dotproject_2_1_3.zip
mv -f BigBlueHat-dotproject-527fa57/dotproject/* #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:user]} #{node[:apache][:default_docroot]}
EOH
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

include_recipe "monitoring"

service "cron" do
  action :enable
end

service "apache2" do
  action :restart
end

ruby_block "show_mysql_root_password" do
  block do
    loop do
      Chef::Log.info "Now configure your dotProject application with following settings."
      Chef::Log.info "Mysql password: #{node[:dotproject][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
