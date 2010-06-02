#SugarCRM + Funambol

node[:sugarce_funambol][:domain_name] = node[:amazon][:public_hostname]

directory "/mnt/tmp" do
  action :create
end

include_recipe "azati::apt_update"
include_recipe "azati::update_limits"

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

#sugar
remote_file "/mnt/tmp/SugarCE-#{node[:sugarce_funambol][:sugar_version]}.zip" do
  source "http://data.azati.s3.amazonaws.com/sugarce/SugarCE-#{node[:sugarce_funambol][:sugar_version]}.zip"
end

bash "unpack_sugar" do
  code <<-EOH
cd /mnt/tmp
unzip -q SugarCE-#{node[:sugarce_funambol][:sugar_version]}.zip
mv -f SugarCE-Full-#{node[:sugarce_funambol][:sugar_version]}/* #{node[:apache][:default_docroot]}
mv -f SugarCE-Full-#{node[:sugarce_funambol][:sugar_version]}/.htaccess #{node[:apache][:default_docroot]}
chown -R #{node[:apache][:user]}:#{node[:apache][:group]} #{node[:apache][:default_docroot]}
EOH
end

service "apache2" do
  action :restart
end

service "mysql" do
  action :restart
end

#funambol
remote_file "/mnt/tmp/#{node[:sugarce_funambol][:funambol_pkg_name]}" do
  source "http://data.azati.s3.amazonaws.com/funambol/#{node[:sugarce_funambol][:funambol_pkg_name]}"
end

bash "unpack_funambol" do
  code <<-EOH
cd /mnt/tmp
tar -xzf #{node[:sugarce_funambol][:funambol_pkg_name]} -C #{node[:sugarce_funambol][:funambol_data_dir]}
chown -R root.root #{node[:sugarce_funambol][:funambol_data_dir]}/Funambol
rm #{node[:sugarce_funambol][:funambol_pkg_name]}
EOH
end

remote_file "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/tools/jre-1.6.0/jre/lib/ext/#{node[:sugarce_funambol][:funambol_jc_name]}" do
  source "http://data.azati.s3.amazonaws.com/funambol/#{node[:sugarce_funambol][:funambol_jc_name]}"
end

#connector
remote_file "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/ds-server/modules/#{node[:sugarce_funambol][:connector_name]}" do
  source "http://data.azati.s3.amazonaws.com/funambol/#{node[:sugarce_funambol][:connector_name]}"
end

mysql_create_db node[:sugarce_funambol][:funambol_db_name] do
  action :create
  charset "utf8"
end

mysql_grant node[:sugarce_funambol][:funambol_db_name] do
  action :run
  db_login node[:sugarce_funambol][:funambol_db_login]
  db_host node[:sugarce_funambol][:funambol_db_host]
  db_password node[:sugarce_funambol][:funambol_db_password]
end

template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/ds-server/install.properties" do
  source "install.properties.erb"
  backup false
end

execute "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/bin/install -Dforce-db-creation=true" do
  action :run
end

template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/config/com/funambol/server/security/SugarcrmOfficer.xml" do
  source "SugarcrmOfficer.xml.erb"
  backup false
end

template "/etc/init.d/funambol" do
  source "funambol.erb"
  mode "0755"
  owner "root"
  group "root"
end

update_rc_d "funambol" do
  action :defaults
  nn     98
end

service "funambol" do
  action :start
end

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end

  include_recipe "monitoring"
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

ruby_block "show_message" do
  block do
    loop do
      Chef::Log.info "Now configure your SugarCE application and Funambol with following settings:"
      Chef::Log.info "SugarCE"
      Chef::Log.info "Mysql host:     #{node[:sugarce_funambol][:sugar_db_host]}"
      Chef::Log.info "Mysql database: #{node[:sugarce_funambol][:sugar_db_name]}"
      Chef::Log.info "Mysql login:    #{node[:sugarce_funambol][:sugar_db_login]}"
      Chef::Log.info "Mysql password: any"
      Chef::Log.info "--------------------------------------------"
      Chef::Log.info "Funambol"
      Chef::Log.info "Mysql host:     #{node[:sugarce_funambol][:funambol_db_host]}"
      Chef::Log.info "Mysql database: #{node[:sugarce_funambol][:funambol_db_name]}"
      Chef::Log.info "Mysql login:    #{node[:sugarce_funambol][:funambol_db_login]}"
      Chef::Log.info "Mysql password: #{node[:sugarce_funambol][:funambol_db_password]}"
      Chef::Log.info "-----"
      Chef::Log.info "Admin login:    admin"
      Chef::Log.info "Admin password: sa"
      Chef::Log.info "--------------------------------------------"
      Chef::Log.info "Mysql root login:    root"
      Chef::Log.info "Mysql root password: #{node[:mysql][:root_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
