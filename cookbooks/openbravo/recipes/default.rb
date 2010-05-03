#OpenBravo

directory "/mnt/tmp" do
  action :create
end

include_recipe "azati::backports_repo"
include_recipe "azati::apt_update"

include_recipe "java"
include_recipe "postgresql"
include_recipe "postgresql::contrib"
include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe "tomcat6"
include_recipe "azati::update_limits"

service "tomcat6" do
  action :stop
end

remote_file "#{node[:apache][:dir]}/conf.d/openbravo-proxy" do
  source "openbravo-proxy"
end
remote_file "#{node[:apache][:default_docroot]}/index.html" do
  source "index.html"
  backup false
end

#install ant
%w{ ant ant-optional }.each do |pkg|
  package pkg do
    action :install
  end
end

bash "ant_env_vars" do
  code <<-EOH
echo 'ANT_HOME="#{node[:openbravo][:ant_home]}"' | sudo tee -a /etc/environment
echo 'ANT_OPTS="#{node[:openbravo][:ant_opts]}"' | sudo tee -a /etc/environment
EOH
end

bash "tools_lib" do
  code <<-EOH
cp #{node[:java][:java_home]}/lib/tools.jar #{node[:tomcat6][:catalina_base]}/lib/
cp #{node[:java][:java_home]}/lib/tools.jar #{node[:tomcat6][:catalina_home]}/lib/
EOH
end

bash "fix_umask" do
  code <<-EOH
perl -p -i -e "s/umask 022/umask 002/" /etc/init.d/tomcat6
EOH
end

postgresql_reset_root_password

postgresql_command "CREATE ROLE #{node[:openbravo][:db_user]} LOGIN PASSWORD '#{node[:openbravo][:db_password]}' SUPERUSER CREATEDB CREATEROLE VALID UNTIL 'infinity'; UPDATE pg_authid SET rolcatupdate=true WHERE rolname='#{node[:openbravo][:db_user]}';" do
  action :execute
end

postgresql_command "CREATE DATABASE #{node[:openbravo][:db_name]} WITH ENCODING='UTF8' OWNER=#{node[:openbravo][:db_user]};" do
  action :execute
end

remote_file "/mnt/tmp/OpenbravoERP-2.50MP11.tar.bz2" do
  source "OpenbravoERP-2.50MP11.tar.bz2"
end

#directory node[:openbravo][:src_path] do
#  owner node[:tomcat6][:user]
#  group node[:tomcat6][:group]
#  action :create
#end

directory node[:openbravo][:dir] do
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  action :create
end

bash "unpack_openbravo" do
  code <<-EOH
cd /mnt/tmp
tar -xjf OpenbravoERP-2.50MP11.tar.bz2
mv -f OpenbravoERP-2.50MP11/* #{node[:openbravo][:dir]}/
chmod -R 0755 #{node[:openbravo][:dir]}
chown -R #{node[:tomcat6][:user]}.#{node[:tomcat6][:group]} #{node[:openbravo][:dir]}
EOH
end

directory node[:openbravo][:attach_path] do
  mode "0755"
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  action :create
end

execute "make_link" do
  command "ln -s #{node[:openbravo][:dir]} #{node[:tomcat6][:catalina_base]}/webapps/openbravo"
  action :run
end

remote_file "#{node[:tomcat6][:config_dir]}/policy.d/20openbravo.policy" do
  source "20openbravo.policy"
end

template "#{node[:openbravo][:dir]}/config/Openbravo.properties" do
  source "Openbravo.properties.erb"
  backup false
end

bash "install_openbravo" do
  code <<-EOH
export JAVA_HOME="#{node[:java][:java_home]}"
export JAVA_OPTS="#{node[:java][:java_opts]}"
export ANT_HOME="#{node[:openbravo][:ant_home]}"
export ANT_OPTS="#{node[:openbravo][:ant_opts]}"
export CATALINA_HOME="#{node[:tomcat6][:catalina_home]}"
export CATALINA_BASE="#{node[:tomcat6][:catalina_base]}"
cp #{node[:openbravo][:dir]}/config/Format.xml.template #{node[:openbravo][:dir]}/config/Format.xml
cp #{node[:openbravo][:dir]}/config/log4j.lcf.template #{node[:openbravo][:dir]}/config/log4j.lcf
cd #{node[:openbravo][:dir]}
ant install.source
chown -R #{node[:tomcat6][:user]}.#{node[:tomcat6][:group]} #{node[:openbravo][:dir]}
EOH
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

service "tomcat6" do
  action :start
end

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "Openbravo successully installed."
      Chef::Log.info "Now configure your openbravo application."
      Chef::Log.info "Openbravo User - Openbravo"
      Chef::Log.info "Openbravo Password - openbravo"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
