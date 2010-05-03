#OrangeHRM

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

service "apache2" do
  action :start
end

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:orangehrm][:db_name]} DEFAULT CHARACTER SET utf8;" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:orangehrm][:db_name]}.* TO '#{node[:orangehrm][:db_login]}'@'#{node[:orangehrm][:db_host]}' IDENTIFIED BY '#{node[:orangehrm][:db_password]}';" do
  action :execute
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/orangehrm-2.5.0.4.tar.gz" do
  source "orangehrm-2.5.0.4.tar.gz"
end

bash "unpack_orangehrm" do
  code <<-EOH
cd /mnt/tmp
tar -xzf orangehrm-2.5.0.4.tar.gz
mv -f orangehrm-2.5.0.4/* #{node[:apache][:default_docroot]}
mv -f orangehrm-2.5.0.4/.htaccess #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:user]} #{node[:apache][:default_docroot]}
EOH
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

mysql_command "#{node[:apache][:default_docroot]}/dbscript/dbscript.sql" do
  action :import
  db_name node[:orangehrm][:db_name]
end

template "#{node[:apache][:default_docroot]}/lib/confs/Conf.php" do
  source "Conf.php.erb"
  mode "0644"
  owner node[:apache][:user]
  group node[:apache][:user]
  backup false
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

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "OrangeHRM has been installed. Check if everything is ok."
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
