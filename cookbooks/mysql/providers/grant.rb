action :run do
  if new_resource.with_grant_option
    mysql_command "GRANT ALL ON #{new_resource.db_name}.* TO '#{new_resource.db_login}'@'#{new_resource.db_host}' IDENTIFIED BY '#{new_resource.db_password}' WITH GRANT OPTION;" do
      action :execute
    end
  else
    mysql_command "GRANT ALL ON #{new_resource.db_name}.* TO '#{new_resource.db_login}'@'#{new_resource.db_host}' IDENTIFIED BY '#{new_resource.db_password}';" do
      action :execute
    end
  end
  
end
