#OpenBravo

directory "/mnt/tmp" do
  action :create
end

unless node[:azati][:stack]
  include_recipe "azati::partner_repo"
end

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

remote_file "/mnt/tmp/#{node[:openbravo][:pkg_name]}" do
  source "http://data.azati.s3.amazonaws.com/openbravo/#{node[:openbravo][:pkg_name]}"
end

directory node[:openbravo][:src_path] do
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  action :create
end

#directory node[:openbravo][:dir] do
#  owner node[:tomcat6][:user]
#  group node[:tomcat6][:group]
#  action :create
#end

directory node[:openbravo][:attach_path] do
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  action :create
end

#cp -r #{node[:openbravo][:pkgfolder_name]}/* #{node[:openbravo][:dir]}/
#chown -R #{node[:tomcat6][:user]}.#{node[:tomcat6][:group]} #{node[:openbravo][:dir]}
#chown -R #{node[:tomcat6][:user]}.#{node[:tomcat6][:group]} #{node[:openbravo][:src_path]}

bash "unpack_openbravo" do
  code <<-EOH
cd /mnt/tmp
tar -xjf #{node[:openbravo][:pkg_name]}
cp -r #{node[:openbravo][:pkgfolder_name]}/* #{node[:openbravo][:src_path]}/
EOH
end

#execute "make_link" do
#  command "ln -s #{node[:openbravo][:dir]} #{node[:tomcat6][:catalina_base]}/webapps/openbravo"
#  action :run
#end

remote_file "#{node[:tomcat6][:config_dir]}/policy.d/20openbravo.policy" do
  source "20openbravo.policy"
end

template "#{node[:openbravo][:src_path]}/config/Openbravo.properties" do
  source "Openbravo.properties.erb"
  backup false
end

#chown -R #{node[:tomcat6][:user]}.#{node[:tomcat6][:group]} #{node[:openbravo][:dir]}

bash "install_openbravo" do
  code <<-EOH
export JAVA_HOME="#{node[:java][:java_home]}"
export JAVA_OPTS="#{node[:java][:java_opts]}"
export ANT_HOME="#{node[:openbravo][:ant_home]}"
export ANT_OPTS="#{node[:openbravo][:ant_opts]}"
export CATALINA_HOME="#{node[:tomcat6][:catalina_home]}"
export CATALINA_BASE="#{node[:tomcat6][:catalina_base]}"
cp #{node[:openbravo][:src_path]}/config/Format.xml.template #{node[:openbravo][:src_path]}/config/Format.xml
cp #{node[:openbravo][:src_path]}/config/log4j.lcf.template #{node[:openbravo][:src_path]}/config/log4j.lcf
cd #{node[:openbravo][:src_path]}
ant install.source
chown -R #{node[:tomcat6][:user]}.#{node[:tomcat6][:group]} #{node[:openbravo][:src_path]}
EOH
end

tomcat6_setup_proxy node[:amazon][:public_hostname]

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
      Chef::Log.info "Openbravo successully installed."
      Chef::Log.info "Login - Openbravo"
      Chef::Log.info "Password - openbravo"
      Chef::Log.info "--------------------------------------------"
      Chef::Log.info "Mysql root login:    root"
      Chef::Log.info "Mysql root password: #{node[:mysql][:root_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if ::Readline.readline('> ', false) == "yes"
    end
  end
  action :create
end
