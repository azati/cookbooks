define :magento_update_domain do
  if params[:name]

    mysql_reset_root_password

    mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='http://#{params[:name]}/' WHERE path='web/unsecure/base_url';" do
      action :execute
    end

    mysql_command "UPDATE #{node[:magento][:db_name]}.core_config_data SET value='https://#{params[:name]}/' WHERE path='web/secure/base_url';" do
      action :execute
    end

  end
end