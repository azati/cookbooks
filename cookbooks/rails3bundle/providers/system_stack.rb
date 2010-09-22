action :start do

  service "mysql" do
    action :start
  end

  rails3bundle_service_web do
    action :start
  end

end

action :stop do

  rails3bundle_service_web do
    action :stop
  end

  service "mysql" do
    action :stop
  end

end

action :restart do

  service "nagios3" do
    action :stop
  end

  service "mysql" do
    action :restart
  end

  service "thin" do
    action :restart
  end

  service "nginx" do
    action :restart
  end

  service "nagios3" do
    action :start
  end

end