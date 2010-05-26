#Alfresco

#prepare environment
directory "/mnt/tmp" do
  action :create
end

unless node[:azati][:stack]
  include_recipe "azati::partner_repo"
end

include_recipe "azati::apt_update"

#install required packages
include_recipe "java"
include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "tomcat6"
include_recipe "azati::update_limits"

service "tomcat6" do
  action :stop
end

package "imagemagick" do
  action :install
end

package "swftools" do
  action :install
end

%w{ openoffice.org-core openoffice.org-java-common }.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{node[:apache][:dir]}/conf.d/alfresco-proxy" do
  source "alfresco-proxy"
end

remote_file "#{node[:tomcat6][:config_dir]}/policy.d/20alfresco.policy" do
  source "20alfresco.policy"
end
remote_file "#{node[:tomcat6][:config_dir]}/policy.d/21alfresco-share.policy" do
  source "21alfresco-share.policy"
end

remote_file "#{node[:apache][:default_docroot]}/index.html" do
  source "index.html"
  backup false
end

remote_file "/mnt/tmp/#{node[:alfresco][:pkg_name]}" do
  source "http://data.azati.s3.amazonaws.com/alfresco/#{node[:alfresco][:pkg_name]}"
end

remote_file "#{node[:tomcat6][:catalina_home]}/lib/#{node[:alfresco][:jc_name]}" do
  source "http://data.azati.s3.amazonaws.com/alfresco/#{node[:alfresco][:jc_name]}"
  mode "0644"
end

bash "install_alfresco" do
  code <<-EOH
cd /mnt/tmp
tar -xzf #{node[:alfresco][:pkg_name]}
mv alfresco.war #{node[:tomcat6][:catalina_base]}/webapps
mv share.war #{node[:tomcat6][:catalina_base]}/webapps
chown #{node[:tomcat6][:user]}:#{node[:tomcat6][:group]} #{node[:tomcat6][:catalina_base]}/webapps/alfresco.war
chown #{node[:tomcat6][:user]}:#{node[:tomcat6][:group]} #{node[:tomcat6][:catalina_base]}/webapps/share.war
EOH
end

file "#{node[:tomcat6][:catalina_base]}/alfresco.log" do
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  mode "0644"
  action :create
end

tomcat6_setup_proxy node[:amazon][:public_hostname]

mysql_reset_root_password

if node[:azati][:stack]
  mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
    action :execute
  end
end

mysql_create_db node[:alfresco][:db_name] do
  action :create
  charset "utf8"
end

mysql_grant node[:alfresco][:db_name] do
  action :run
  db_login node[:alfresco][:db_login]
  db_host node[:alfresco][:db_host]
  db_password node[:alfresco][:db_password]
  with_grant_option true
end

mysql_grant node[:alfresco][:db_name] do
  action :run
  db_login node[:alfresco][:db_login]
  db_host "localhost.localdomain"
  db_password node[:alfresco][:db_password]
  with_grant_option true
end

directory "#{node[:tomcat6][:catalina_base]}/shared/classes" do
  action :create
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  recursive true
end

directory node[:alfresco][:data_dir] do
  action :create
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
end

template "#{node[:tomcat6][:catalina_base]}/shared/classes/alfresco-global.properties" do
  source "alfresco-global.properties.erb"
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  backup false
end

#execute "perl -p -i -e \"s/shared\\.loader=.*/shared\\.loader=\\\\$\\\\{catalina\\.base\\\\}\\/shared\\/classes,\\\\$\\\\{catalina\\.base\\\\}\\/shared\\/lib\\/\\*\\.jar/\" #{node[:tomcat6][:config_dir]}/catalina.properties" do
#  action :run
#end

remote_file "/etc/rc.local" do
  source "rc.local"
  backup false
end

execute "/usr/lib/openoffice/program/soffice \"-accept=socket,host=localhost,port=8100;urp;StarOffice.ServiceManager\" -nologo -headless -nofirststartwizard &" do
  action :run
end

if node[:azati][:stack]
  include_recipe "monitoring"
end

service "apache2" do
  action :restart
end

service "tomcat6" do
  action :start
end

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "Alfresco successully installed."
      Chef::Log.info "Login - admin"
      Chef::Log.info "Password - admin"
      Chef::Log.info "Mysql host: #{node[:alfresco][:db_host]}"
      Chef::Log.info "Mysql database: #{node[:alfresco][:db_name]}"
      Chef::Log.info "Mysql login: #{node[:alfresco][:db_login]}"
      Chef::Log.info "Mysql password: #{node[:alfresco][:db_password]}"
      Chef::Log.info "Mysql root password: #{node[:mysql][:root_password]}"
      Chef::Log.info "Alfresco start takes about 2-5 minutes. Wait and check if everything is ok."
      Chef::Log.info "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
