#SugarCRM

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-imap"
include_recipe "php::php-mbstring"
include_recipe "php::php-curl"
include_recipe "php::php-mysql"
include_recipe "php::php-eaccelerator"

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

mysql_reset_root_password

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/SugarCE-5.5.1.zip" do
  source "SugarCE-5.5.1.zip"
end

bash "unpack_sugar" do
  code <<-EOH
cd /mnt/tmp
unzip -q SugarCE-5.5.1.zip
mv -f SugarCE-Full-5.5.1/* #{node[:apache][:default_docroot]}
mv -f SugarCE-Full-5.5.1/.htaccess #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:group]} #{node[:apache][:default_docroot]}
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
      Chef::Log.info "Now configure your SugarCE application with following settings:"
      Chef::Log.info "Mysql host: #{node[:sugarce][:db_host]}"
      Chef::Log.info "Mysql database: #{node[:sugarce][:db_name]}"
      Chef::Log.info "Mysql login: #{node[:sugarce][:db_login]}"
      Chef::Log.info "Mysql password: any"
      Chef::Log.info "----------------------"
      Chef::Log.info "Mysql root login: root"
      Chef::Log.info "Mysql root password: #{node[:mysql][:root_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
