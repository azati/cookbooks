service "nagios3" do
  action :stop
end

service "thin" do
  action :stop
end

service "nginx" do
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
