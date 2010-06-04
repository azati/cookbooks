action :start do

  service "mysql" do
    action :start
  end

  sugarce_funambol_service_web do
    action :start
  end

end

action :stop do

  sugarce_funambol_service_web do
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

  service "apache2" do
    action :restart
  end

  service "funambol" do
    action :stop
  end

  service "funambol" do
    action :start
  end

  service "nagios3" do
    action :start
  end

end