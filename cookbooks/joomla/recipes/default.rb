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
include_recipe "proftpd"

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

mysql_reset_root_password

mysql_create_db node[:joomla][:db_name] do
  action :create
  charset "utf8"
end

mysql_grant node[:joomla][:db_name] do
  action :run
  db_login node[:joomla][:db_login]
  db_host node[:joomla][:db_host]
  db_password node[:joomla][:db_password]
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/#{node[:joomla][:package_name]}.#{node[:joomla][:package_name_ext]}" do
  source "http://data.azati.s3.amazonaws.com/joomla/#{node[:joomla][:package_name]}.#{node[:joomla][:package_name_ext]}"
end

bash "unpack_joomla" do
  code <<-EOH
cd /mnt/tmp
unzip -q #{node[:joomla][:package_name]}.#{node[:joomla][:package_name_ext]} -d #{node[:apache][:default_docroot]}
mv -f #{node[:apache][:default_docroot]}/htaccess.txt #{node[:apache][:default_docroot]}/.htaccess
chown -R #{node[:apache][:user]}:#{node[:apache][:user]} #{node[:apache][:default_docroot]}
EOH
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

#modified rewrite section to support apache server-status
remote_file "#{node[:apache][:default_docroot]}/.htaccess" do
  source "htaccess"
  mode "0644"
end

execute "chown -R #{node[:apache][:user]}.#{node[:apache][:group]} #{node[:apache][:default_docroot]}" do
  action :run
end

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end

  include_recipe "monitoring"

  service "cron" do
    action :enable
  end
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
      Chef::Log.info "Mysql host:     #{node[:joomla][:db_host]}"
      Chef::Log.info "Mysql database: #{node[:joomla][:db_name]}"
      Chef::Log.info "Mysql login:    #{node[:joomla][:db_login]}"
      Chef::Log.info "Mysql password: #{node[:joomla][:db_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
