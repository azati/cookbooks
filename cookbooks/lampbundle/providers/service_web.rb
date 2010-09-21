action :start do

  apache2_maintenance_mode do
    action :disable
  end

  service "apache2" do
    action :restart
  end

  service "nagios3" do
    action :start
  end

end

action :stop do

  apache2_maintenance_mode do
    action :enable
  end

  service "nagios3" do
    action :stop
  end

  service "apache2" do
    action :restart
  end
  
end

action :restart do

  service "nagios3" do
    action :stop
  end

  service "apache2" do
    action :restart
  end

  service "nagios3" do
    action :start
  end
  
end