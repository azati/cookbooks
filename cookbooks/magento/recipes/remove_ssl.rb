include_recipe "apache2::ssl_disable"

mysql_reset_root_password

mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='0' WHERE path='web/secure/use_in_frontend';" do
  action :execute
end
mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='0' WHERE path='web/secure/use_in_adminhtml';" do
  action :execute
end

magento_clear_cache