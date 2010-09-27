#eGroupWare

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-imap"
include_recipe "php::php-mbstring"
include_recipe "php::php-mysql"
include_recipe "php::php-ldap"
include_recipe "php::php-pear"
include_recipe "php::php-gd"
include_recipe "php::php-eaccelerator"

execute "perl -p -i -e 's/;mbstring.func_overload = 0/mbstring.func_overload = 7/' #{node[:php][:dir]}/php.ini" do
  action :run
end
execute "perl -p -i -e 's/display_errors = On/display_errors = Off/' #{node[:php][:dir]}/php.ini" do
  action :run
end
execute "perl -p -i -e 's/magic_quotes_gpc = On/magic_quotes_gpc = Off/' #{node[:php][:dir]}/php.ini" do
  action :run
end

mysql_reset_root_password

service "apache2" do
  action :restart
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/#{node[:egroupware][:file]}" do
  source "http://data.azati.s3.amazonaws.com/egroupware/#{node[:egroupware][:file]}"
end

bash "unpack_egroupware" do
  code <<-EOH
cd /mnt/tmp
tar -xzf #{node[:egroupware][:file]}
mv -f egroupware/* #{node[:apache][:default_docroot]}
mv -f egroupware/.htaccess #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:user]} #{node[:apache][:default_docroot]}
EOH
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

directory node[:egroupware][:files_path] do
  action :create
  owner node[:apache][:user]
  group node[:apache][:user]
end
directory node[:egroupware][:backup_path] do
  action :create
  owner node[:apache][:user]
  group node[:apache][:user]
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
      Chef::Log.info "Now configure your egroupware application with following settings."
      Chef::Log.info "Mysql password: #{node[:mysql][:root_password]}"
      Chef::Log.info "Files path:     #{node[:egroupware][:files_path]}"
      Chef::Log.info "Backup path:    #{node[:egroupware][:backup_path]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
