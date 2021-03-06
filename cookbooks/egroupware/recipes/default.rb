#eGroupWare

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "php"
include_recipe "php::php-imap"
include_recipe "php::php-mbstring"
include_recipe "php::php-mcrypt"
include_recipe "php::php-mysql"
include_recipe "php::php-ldap"
include_recipe "php::php-sqlite"
include_recipe "php::php-pear"
include_recipe "php::php-gd"
include_recipe "php::php-eaccelerator"

mysql_reset_root_password

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/#{node[:egroupware][:file]}" do
  source "http://data.azati.s3.amazonaws.com/egroupware/#{node[:egroupware][:file]}"
end
remote_file "/mnt/tmp/#{node[:egroupware][:jpgraph_file]}" do
  source "http://data.azati.s3.amazonaws.com/egroupware/#{node[:egroupware][:jpgraph_file]}"
end
remote_file "/mnt/tmp/#{node[:egroupware][:pear_file]}" do
  source "http://data.azati.s3.amazonaws.com/egroupware/#{node[:egroupware][:pear_file]}"
end

bash "unpack_egroupware" do
  code <<-EOH
cd /mnt/tmp
tar -xzf #{node[:egroupware][:file]}
tar -xzf #{node[:egroupware][:pear_file]}
mv -f egroupware/* #{node[:apache][:default_docroot]}
mv -f egroupware/.htaccess #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:user]} #{node[:apache][:default_docroot]}
EOH
end

bash "unpack_jpgraph" do
  code <<-EOH
cd /mnt/tmp
mkdir /var/jpgraph
tar -xzf #{node[:egroupware][:jpgraph_file]} -C /var/jpgraph
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
      Chef::Log.info "Mysql root password:  #{node[:mysql][:root_password]}"
      Chef::Log.info "Files path:           #{node[:egroupware][:files_path]}"
      Chef::Log.info "Backup path:          #{node[:egroupware][:backup_path]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
