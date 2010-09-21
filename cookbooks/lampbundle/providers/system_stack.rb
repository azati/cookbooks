action :start do

  service "mysql" do
    action :start
  end

  lampbundle_service_web do
    action :start
  end

end

action :stop do

  lampbundle_service_web do
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

  service "nagios3" do
    action :start
  end

end