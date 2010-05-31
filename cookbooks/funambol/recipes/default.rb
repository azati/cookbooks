#Funambol

#prepare environment
directory "/mnt/tmp" do
  action :create
end

include_recipe "azati::apt_update"

#install required packages
#include_recipe "mysql::server"
#include_recipe "mysql::mysql_dev"
include_recipe "azati::update_limits"

remote_file "/mnt/tmp/#{node[:funambol][:pkg_name]}" do
  source "http://data.azati.s3.amazonaws.com/funambol/#{node[:funambol][:pkg_name]}"
end

bash "install_funambol" do
  code <<-EOH
cd /mnt/tmp
tar -xzf #{node[:funambol][:pkg_name]} -C #{node[:funambol][:data_dir]}
chown -R root.root #{node[:funambol][:data_dir]}/Funambol
rm #{node[:funambol][:pkg_name]}
EOH
end

=begin

remote_file "#{node[:funambol][:data_dir]}/Funambol/tools/jre-1.6.0/jre/lib/ext/#{node[:funambol][:jc_name]}" do
  source "http://data.azati.s3.amazonaws.com/funambol/#{node[:funambol][:jc_name]}"
end

mysql_reset_root_password

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end
end

mysql_create_db node[:funambol][:db_name] do
  action :create
  charset "utf8"
end

mysql_grant node[:funambol][:db_name] do
  action :run
  db_login node[:funambol][:db_login]
  db_host node[:funambol][:db_host]
  db_password node[:funambol][:db_password]
end

# run install script

=end

template "/etc/init.d/funambol" do
  source "funambol.erb"
  mode "0755"
  owner "root"
  group "root"
end

execute "update-rc.d funambol defaults" do
  action :run
end

execute "/etc/init.d/funambol start" do
  action :run
end
