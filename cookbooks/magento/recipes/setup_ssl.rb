node[:apache][:certificates][:private_key]  = node[:params][:private_key]
node[:apache][:certificates][:cert]         = node[:params][:certificate]
node[:apache][:certificates][:ca_cert]      = node[:params][:ca_certificate]

node[:magento][:domain_name] = node[:chef_advanced_params][:domain_name]

include_recipe "apache2::ssl_enable"

mysql_reset_root_password

mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='https://#{node[:magento][:domain_name]}/' WHERE path='web/secure/base_url';" do
  action :execute
end
mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='1' WHERE path='web/secure/use_in_frontend';" do
  action :execute
end
mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='1' WHERE path='web/secure/use_in_adminhtml';" do
  action :execute
end

magento_clear_cache