service "nagios" do
  action :stop
end

service "apache2" do
  action :stop
end

service "mysql" do
  action :stop
end

directory "#{node[:apache][:default_docroot]}/installer" do
  action :delete
  recursive true
end

execute "apt-get clean" do
  action :run
end

execute "sync" do
  action :run
end
