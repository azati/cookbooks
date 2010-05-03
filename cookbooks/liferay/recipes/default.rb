#Liferay

include_recipe "azati::backports_repo"
include_recipe "azati::apt_update"

include_recipe "java"
include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "tomcat6"
include_recipe "azati::update_limits"

service "tomcat6" do
  action :stop
end

service "apache2" do
  action :start
end

service "mysql" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
  action :execute
end

mysql_create_db node[:liferay][:db_name] do
  action :create
  charset "utf8"
end

mysql_grant node[:liferay][:db_name] do
  action :run
  db_login node[:liferay][:db_login]
  db_host node[:liferay][:db_host]
  db_password node[:liferay][:db_password]
end

remote_file "#{node[:apache][:dir]}/conf.d/liferay-proxy" do
  source "liferay-proxy"
end

remote_file "#{node[:tomcat6][:config_dir]}/policy.d/20liferay.policy" do
  source "20liferay.policy"
end

directory node[:liferay][:data_dir] do
  action :create
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/liferay-portal-5.2.3.war" do
  source "liferay-portal-5.2.3.war"
end
remote_file "/mnt/tmp/liferay-portal-tunnel-web-5.2.3.war" do
  source "liferay-portal-tunnel-web-5.2.3.war"
end
remote_file "/mnt/tmp/dependencies.zip" do
  source "dependencies.zip"
end

bash "install_liferay" do
  code <<-EOH
cd /mnt/tmp
rm -rf #{node[:tomcat6][:catalina_base]}/webapps/ROOT/*
unzip liferay-portal-5.2.3.war -d #{node[:tomcat6][:catalina_base]}/webapps/ROOT
mkdir #{node[:tomcat6][:catalina_base]}/webapps/tunnel-web
unzip liferay-portal-tunnel-web-5.2.3.war -d #{node[:tomcat6][:catalina_base]}/webapps/tunnel-web
chown -R #{node[:tomcat6][:user]}:#{node[:tomcat6][:group]} #{node[:tomcat6][:catalina_base]}/webapps
mkdir #{node[:tomcat6][:catalina_home]}/lib/ext
unzip dependencies.zip -d #{node[:tomcat6][:catalina_home]}/lib/ext
EOH
end

template "#{node[:tomcat6][:catalina_base]}/webapps/ROOT/WEB-INF/classes/portal-ext.properties" do
  source "portal-ext.properties.erb"
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  mode "0644"
  backup false
end

template "#{node[:tomcat6][:config_dir]}/context.xml" do
  source "context.xml.erb"
  backup false
end

remote_file "#{node[:tomcat6][:config_dir]}/Catalina/localhost/ROOT.xml" do
  source "ROOT.xml"
end

execute "perl -p -i -e \"s/common\\.loader=.*/common\\.loader=\\\\$\\\\{catalina\\.home\\\\}\\/lib,\\\\$\\\\{catalina\\.home\\\\}\\/lib\\/\\*\\.jar,\\\\$\\\\{catalina\\.home\\\\}\\/lib\\/ext\\/\\*\\.jar/\" #{node[:tomcat6][:config_dir]}/catalina.properties" do
  action :run
end

bash "setup_proxy_and_address" do
  code <<-EOH
ADDR=`curl http://169.254.169.254/latest/meta-data/public-hostname`
perl -p -i -e "s/<Connector port=\\"8080\\" /<Connector port=\\"8080\\" proxyName=\\"$ADDR\\" proxyPort=\\"80\\" /" #{node[:tomcat6][:config_dir]}/server.xml
EOH
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

service "tomcat6" do
  action :start
end

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "Liferay successully installed."
      Chef::Log.info "Login - test@liferay.com"
      Chef::Log.info "Password - test"
      Chef::Log.info "Check if everything is ok."
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
