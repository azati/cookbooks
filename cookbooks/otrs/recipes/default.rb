#OTRS

include_recipe "azati::apt_update"

include_recipe "mysql::server"
include_recipe "mysql::mysql_dev"
include_recipe "apache2"
include_recipe "apache2::mod_perl"

service "apache2" do
  action :start
end

service "mysql" do
  action :start
end

mysql_reset_root_password

=begin
mysql_command "CREATE DATABASE #{node[:otrs][:db_name]} DEFAULT CHARACTER SET utf8;" do
  action :execute
end
mysql_command "GRANT ALL ON #{node[:otrs][:db_name]}.* TO '#{node[:otrs][:db_login]}'@'#{node[:otrs][:db_host]}' IDENTIFIED BY '#{node[:otrs][:db_password]}';" do
  action :execute
end
=end

directory "/mnt/tmp" do
  action :create
end

remote_file "/mnt/tmp/otrs-2.4.7.tar.gz" do
  source "otrs-2.4.7.tar.gz"
end

directory node[:otrs][:dir] do
  action :create
end

bash "unpack_otrs" do
  code <<-EOH
cd /mnt/tmp
tar -xzf otrs-2.4.7.tar.gz
mv -f otrs-2.4.7/* #{node[:otrs][:dir]}
mv -f otrs-2.4.7/.fetchmailrc.dist #{node[:otrs][:dir]}
mv -f otrs-2.4.7/.mailfilter.dist #{node[:otrs][:dir]}
mv -f otrs-2.4.7/.procmailrc.dist #{node[:otrs][:dir]}
EOH
end

directory "/mnt/tmp" do
  action :delete
  recursive true
end

user node[:otrs][:user] do
  home node[:otrs][:dir]
  action :create
end

execute "usermod -G nogroup #{node[:otrs][:user]}" do
  action :run
end

package "libssl-dev" do
    action :install
end

package "libgd2-noxpm-dev" do
    action :install
end

execute "cpan CGI DBI DBD::mysql Encode::HanExtra Net::DNS IO::Socket::SSL Net::IMAP::Simple::SSL Net::SMTP::SSL Net::LDAP GD GD::Text GD::Graph D::Graph::lines GD::Text::Align PDF::API2 Compress::Zlib" do
  action :run
end

template "#{node[:apache][:dir]}/conf.d/otrs" do
  source "otrs.erb"
  backup false
end

bash "copy_configs" do
  code <<-EOH
cp #{node[:otrs][:dir]}/Kernel/Config.pm.dist #{node[:otrs][:dir]}/Kernel/Config.pm
cp #{node[:otrs][:dir]}/Kernel/Config/GenericAgent.pm.dist #{node[:otrs][:dir]}/Kernel/Config/GenericAgent.pm
EOH
end

#some errors with charset
=begin
template "#{node[:otrs][:dir]}/Kernel/Config.pm" do
  source "Config.pm.erb"
end
template "#{node[:otrs][:dir]}/Kernel/Config/GenericAgent.pm" do
  source "GenericAgent.pm.erb"
end

mysql_command "#{node[:otrs][:dir]}/scripts/database/otrs-schema.mysql.sql" do
  action :import
  db_name node[:otrs][:db_name]
end
mysql_command "#{node[:otrs][:dir]}/scripts/database/otrs-initial_insert.mysql.sql" do
  action :import
  db_name node[:otrs][:db_name]
end
mysql_command "#{node[:otrs][:dir]}/scripts/database/otrs-schema-post.mysql.sql" do
  action :import
  db_name node[:otrs][:db_name]
end
=end

execute "#{node[:otrs][:dir]}/bin/SetPermissions.sh #{node[:otrs][:dir]} #{node[:otrs][:user]} #{node[:apache][:user]} nogroup #{node[:apache][:user]}" do
  action :run
end

bash "install_cron_tasks" do
  code <<-EOH
cd #{node[:otrs][:dir]}/var/cron
for foo in *.dist; do cp $foo `basename $foo .dist`; done
cd #{node[:otrs][:dir]}/bin
./Cron.sh start #{node[:otrs][:user]}
EOH
end

#To mysql monitoring work properly, we have to create nagios mysql user.
mysql_command "CREATE USER 'nagios'@'localhost' IDENTIFIED BY 'Nu71QHuSgOtTxXCIYPKJ'" do
  action :execute
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

ruby_block "show_mysql_root_password" do
  block do
    loop do
      Chef::Log.info "Now configure your OTRS application with following settings."
      Chef::Log.info "Mysql password: #{node[:mysql][:root_password]}"
      printf "Ready to post install? [yes or ctrl+c to terminate]"
      break if readline.strip == "yes"
    end
  end
  action :create
end
