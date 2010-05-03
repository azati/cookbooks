service "nagios" do
  action :stop
end

service "apache2" do
  action :stop
end

service "mysql" do
  action :stop
end

execute "mv -f #{node[:apache][:default_docroot]}/config/LocalSettings.php #{node[:apache][:default_docroot]}" do
  action :run
end

execute "apt-get clean" do
  action :run
end

execute "sync" do
  action :run
end
