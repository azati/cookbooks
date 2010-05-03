action :start do

  service "mysql" do
    action :start
  end

  liferay_service_web do
    action :start
  end

end

action :stop do

  liferay_service_web do
    action :stop
  end

  service "mysql" do
    action :stop
  end

end

action :restart do

  service "nagios" do
    action :stop
    ignore_failure true
  end

  service "mysql" do
    action :restart
  end

  service "tomcat6" do
    action :restart
  end

  service "apache2" do
    action :restart
  end

  service "nagios" do
    action :start
    ignore_failure true
  end

end