action :execute do
  execute "restore_mysql_databases" do
    command "mysql -h #{node[:mysql][:host]} -uroot -p#{node[:mysql][:root_password]} < #{new_resource.name}"
  end
end