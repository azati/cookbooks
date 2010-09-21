service "nagios3" do
  action :stop
end

service "apache2" do
  action :stop
end

service "mysql" do
  action :stop
end

execute "apt-get clean" do
  action :run
end

execute "sync" do
  action :run
end
