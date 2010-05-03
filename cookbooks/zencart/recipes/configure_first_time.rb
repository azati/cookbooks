#node[:zencart][:login]            = node[:params][:user_name]
node[:zencart][:password]         = node[:params][:password]
node[:zencart][:domain_name]      = node[:params][:domain_name]

encrypt_zencart_pass node[:zencart][:password]

mysql_reset_root_password

mysql_grant node[:zencart][:db_name] do
  db_login      node[:zencart][:db_login]
  db_host       node[:zencart][:db_host]
  db_password   node[:zencart][:db_password]
  action        :run
end

mysql_command "UPDATE #{node[:zencart][:db_name]}.admin SET admin_pass='#{node[:zencart][:encrypted_password]}' WHERE admin_name='#{node[:zencart][:login]}';" do
  action :execute
end

bash "update_config" do
  code <<-EOH
perl -p -i -e "s/define\\(\\'DB_SERVER\\', \\'.*\\'\\)/define\\(\\'DB_SERVER\\', \\'#{node[:zencart][:db_host]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_SERVER\\', \\'.*\\'\\)/define\\(\\'DB_SERVER\\', \\'#{node[:zencart][:db_host]}\\'\\)/" /#{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_DATABASE\\', \\'.*\\'\\)/define\\(\\'DB_DATABASE\\', \\'#{node[:zencart][:db_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_DATABASE\\', \\'.*\\'\\)/define\\(\\'DB_DATABASE\\', \\'#{node[:zencart][:db_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_SERVER_USERNAME\\', \\'.*\\'\\)/define\\(\\'DB_SERVER_USERNAME\\', \\'#{node[:zencart][:db_login]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_SERVER_USERNAME\\', \\'.*\\'\\)/define\\(\\'DB_SERVER_USERNAME\\', \\'#{node[:zencart][:db_login]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_SERVER_PASSWORD\\', \\'.*\\'\\)/define\\(\\'DB_SERVER_PASSWORD\\', \\'#{node[:zencart][:db_password]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'DB_SERVER_PASSWORD\\', \\'.*\\'\\)/define\\(\\'DB_SERVER_PASSWORD\\', \\'#{node[:zencart][:db_password]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_CATALOG_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
EOH
end

log "Zen Cart User - #{node[:zencart][:login]}"
log "Zen Cart Password - #{node[:zencart][:password]}"
