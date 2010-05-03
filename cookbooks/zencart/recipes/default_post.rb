service "nagios" do
  action :stop
end

service "apache2" do
  action :stop
end

service "mysql" do
  action :stop
end

directory "#{node[:apache][:default_docroot]}/zc_install" do
  action :delete
  recursive true
end

file "#{node[:apache][:default_docroot]}/includes/configure.php" do
  action :touch
  mode 0444
end

file "#{node[:apache][:default_docroot]}/admin/includes/configure.php" do
  action :touch
  mode 0444
end

execute "apt-get clean" do
  action :run
end

execute "sync" do
  action :run
end
