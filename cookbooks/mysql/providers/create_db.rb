action :create do
  mysql_command "CREATE DATABASE #{new_resource.name} DEFAULT CHARACTER SET #{new_resource.charset};" do
    action :execute
  end
end
