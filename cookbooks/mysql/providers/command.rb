action :execute do
  execute "mysql_command" do
    command "mysql --user=root --password=#{node[:mysql][:root_password]} --execute=\"#{new_resource.name}\""
  end
end

action :import do
  execute "mysql_import" do
    command "mysql --user=root --password=#{node[:mysql][:root_password]} #{new_resource.db_name} < #{new_resource.name}"
  end
end
