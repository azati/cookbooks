action :start do

  service "postgresql-8.4" do
    action :start
  end

  openbravo_service_web do
    action :start
  end

end

action :stop do

  openbravo_service_web do
    action :stop
  end

  service "postgresql-8.4" do
    action :stop
  end

end

action :restart do

  service "nagios3" do
    action :stop
  end

  service "postgresql-8.4" do
    action :restart
  end

  service "tomcat6" do
    action :restart
  end

  service "apache2" do
    action :restart
  end

  service "nagios3" do
    action :start
  end

end