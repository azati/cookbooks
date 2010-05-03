define :phpbb_update_domain do
  mysql_reset_root_password

  mysql_command "UPDATE #{node[:phpbb][:db_name]}.phpbb_config SET config_value='#{node[:phpbb][:domain_name]}' WHERE config_name='server_name'" do
    action :execute
  end
  mysql_command "UPDATE #{node[:phpbb][:db_name]}.phpbb_config SET config_value='#{node[:phpbb][:domain_name]}' WHERE config_name='cookie_domain'" do
    action :execute
  end
end