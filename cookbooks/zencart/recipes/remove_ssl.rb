node[:zencart][:domain_name] = node[:chef_advanced_params][:domain_name]

bash "remove_ssl" do
  code <<-EOH
perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_CATALOG_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'ENABLE_SSL\\', \\'.*\\'\\)/define\\(\\'ENABLE_SSL\\', \\'false\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'ENABLE_SSL_CATALOG\\', \\'.*\\'\\)/define\\(\\'ENABLE_SSL_CATALOG\\', \\'false\\'\\)/" /#{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'ENABLE_SSL_ADMIN\\', \\'.*\\'\\)/define\\(\\'ENABLE_SSL_ADMIN\\', \\'false\\'\\)/" /#{node[:apache][:default_docroot]}/admin/includes/configure.php
EOH
end

include_recipe "apache2::ssl_disable"