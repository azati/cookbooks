node[:zencart][:domain_name] = node[:params][:domain_name]

if node[:chef_advanced_params][:ssl][:enable]
  bash "changedomain" do
    code <<-EOH
  perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTP_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_CATALOG_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  EOH
  end
else
  bash "changedomain" do
    code <<-EOH
  perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTP_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTPS_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTP_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTP_CATALOG_SERVER\\', \\'http:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  perl -p -i -e "s/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'.*\\'\\)/define\\(\\'HTTPS_CATALOG_SERVER\\', \\'https:\\/\\/#{node[:zencart][:domain_name]}\\'\\)/" #{node[:apache][:default_docroot]}/admin/includes/configure.php
  EOH
  end
end