#Redmine

include_recipe "azati::apt_update"

directory "/mnt/tmp" do
  action :create
end

%w{ imagemagick libmagick++9-dev }.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "ruby"
include_recipe "ruby::rubygems"
include_recipe "ruby::rails"

gem_package "rack" do
  version "1.0.1"
  action :install
end

gem_package "rake" do
  version "0.8.7"
  action :install
end

gem_package "rmagick" do
  version "2.12.2"
  action :install
end
gem_package "mysql" do
  options "-- --with-mysql-include=/usr/include/mysql --with-mysql-lib=/usr/lib/mysql"
  action :install
end

#chef fails to install thin with gem_packege with an error: "ERROR:  could not find gem thin locally or in a repository"
#so installing manually
remote_file "/mnt/tmp/thin-1.2.5.gem" do
  source "thin-1.2.5.gem"
end
gem_package "/mnt/tmp/thin-1.2.5.gem" do
  version "1.2.5"
  action :install
end
file "/mnt/tmp/thin-1.2.5.gem" do
  action :delete
end

include_recipe "nginx"
include_recipe "nginx::maintenance_site"

remote_file "#{node[:nginx][:dir]}/conf/nginx.conf" do
  source "nginx.conf.nossl"
  backup false
end
remote_file "#{node[:nginx][:dir]}/conf/nginx.conf.nossl-maintenance" do
  source "nginx.conf.nossl-maintenance"
end
remote_file "#{node[:nginx][:dir]}/conf/nginx.conf.ssl" do
  source "nginx.conf.ssl"
end
remote_file "#{node[:nginx][:dir]}/conf/nginx.conf.ssl-maintenance" do
  source "nginx.conf.ssl-maintenance"
end

service "nginx" do
  action :start
end

mysql_reset_root_password

mysql_command "CREATE DATABASE #{node[:redmine][:db_name]} CHARACTER SET utf8; CREATE USER '#{node[:redmine][:db_login]}'@'#{node[:redmine][:db_host]}' IDENTIFIED BY '#{node[:redmine][:db_password]}'; GRANT ALL PRIVILEGES ON #{node[:redmine][:db_name]}.* TO '#{node[:redmine][:db_login]}'@'#{node[:redmine][:db_host]}';" do
  action :execute
end

directory node[:redmine][:dir] do
  action :create
end

remote_file "/mnt/tmp/redmine-0.9.3.tar.gz" do
  source "redmine-0.9.3.tar.gz"
end

bash "unpack_redmine" do
  code <<-EOH
cd /mnt/tmp
tar -xzf redmine-0.9.3.tar.gz
mv -f redmine-0.9.3/* #{node[:redmine][:dir]}
EOH
end

directory "/mnt/tmp" do
  recursive true
  action :delete
end

template "#{node[:redmine][:dir]}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

rake "generate_session_store RAILS_ENV=production" do
  action :run
  cwd    node[:redmine][:dir]
end
rake "db:migrate RAILS_ENV=production" do
  action :run
  cwd    node[:redmine][:dir]
end
rake "redmine:load_default_data RAILS_ENV=production REDMINE_LANG=en" do
  action :run
  cwd    node[:redmine][:dir]
end

execute "install_thin"  do
  command "thin install"
  action :run
end

execute "thin_config" do
  command "thin config -C /etc/thin/Redmine.yml -c #{node[:redmine][:dir]} --servers 6 -e production -p 3000"
  action :run
end

remote_file "#{node[:redmine][:dir]}/config/email.yml" do
  source "email.yml"
  backup false
end

service "thin" do
  action [ :enable, :start ]
end

package "subversion" do
  action :install
end

include_recipe "apache2"
include_recipe "apache2::mod_dav"
include_recipe "apache2::mod_dav_svn"
include_recipe "apache2::mod_dav"
include_recipe "apache2::mod_perl"

execute "cpan_module" do
  command "cpan install Digest::SHA1"
  action :run
end

include_recipe "apache2::disable_default_site"

template "#{node[:apache][:sites_available]}/subversion" do
  source "subversion.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

apache_site "subversion"

directory node[:redmine][:svn_dir] do
  owner node[:apache][:user]
  group node[:apache][:user]
  action :create
end

directory "/usr/local/lib/site_perl/Apache/Authn" do
  recursive true
  action :create
end

bash "copy_redmine.pm" do
  code <<-EOH
cp #{node[:redmine][:dir]}/extra/svn/Redmine.pm /usr/local/lib/site_perl/Apache/Authn/
EOH
end

cron "redmine_reposman" do
  minute "*/10"
  command "ruby #{node[:redmine][:dir]}/extra/svn/reposman.rb --redmine http://localhost --svn-dir #{node[:redmine][:svn_dir]} --owner #{node[:apache][:user]} --url http://127.0.0.1:8080/svn-private/ >> /var/log/reposman.log"
end

service "apache2" do
  action :start
end

mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
  action :execute
end

include_recipe "monitoring"

ruby_block "show_success_message" do
  block do
    loop do
      Chef::Log.info "Redmine successully installed."
      Chef::Log.info "Now configure your redmine application."
      Chef::Log.info "Login - admin"
      Chef::Log.info "Password - admin"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
