#Zen Cart

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-mysql"
include_recipe "php::php-gd"
include_recipe "php::php-curl"
include_recipe "php::php-eaccelerator"

service "apache2" do
  action :start
end

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:zencart][:db_name]};" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:zencart][:db_name]}.* TO '#{node[:zencart][:db_login]}'@'#{node[:zencart][:db_host]}' IDENTIFIED BY '#{node[:zencart][:db_password]}';" do
  action :execute
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/zen-cart-v1.3.8a-full-fileset-12112007.zip" do
  source "zen-cart-v1.3.8a-full-fileset-12112007.zip"
end

bash "unpack_zencart" do
  code <<-EOH
cd /mnt/tmp
unzip -q zen-cart-v1.3.8a-full-fileset-12112007.zip
mv -f zen-cart-v1.3.8a-full-fileset-12112007/* #{node[:apache][:default_docroot]}/
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
      Chef::Log.info "Now configure your Zen Cart application with following settings."
      Chef::Log.info "Mysql host: #{node[:zencart][:db_host]}"
      Chef::Log.info "Mysql database: #{node[:zencart][:db_name]}"
      Chef::Log.info "Mysql login: #{node[:zencart][:db_login]}"
      Chef::Log.info "Mysql password: #{node[:zencart][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
