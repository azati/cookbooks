node[:apache][:certificates][:private_key]  = node[:params][:private_key]
node[:apache][:certificates][:cert]         = node[:params][:certificate]
node[:apache][:certificates][:ca_cert]      = node[:params][:ca_certificate]

node[:zencart][:domain_name] = node[:chef_advanced_params][:domain_name]

#yes, need also rewrite http constants
bash "setup_ssl" do
  code <<-EOH
perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTP_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_CATALOG_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'ENABLE_SSL\\', \\'.*\\'\\)/define\\(\\'ENABLE_SSL\\', \\'true\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
perl -p -i -e "s/define\\(\\'ENABLE_SSL_CATALOG\\', \\'.*\\'\\)/define\\(\\'ENABLE_SSL_CATALOG\\', \\'true\\'\\)/" /#{node[:apache][:default_docroot]}/admin/includes/configure.php
perl -p -i -e "s/define\\(\\'ENABLE_SSL_ADMIN\\', \\'.*\\'\\)/define\\(\\'ENABLE_SSL_ADMIN\\', \\'true\\'\\)/" /#{node[:apache][:default_docroot]}/admin/includes/configure.php
EOH
end

include_recipe "apache2::ssl_enable"
