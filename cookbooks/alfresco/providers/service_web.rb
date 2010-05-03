action :start do

  #start not work because of chef bug
  #chef checks for running processess via ps and regexp, finds openoffice process started with tomcat6 user rights
  #and think that tomcat6 service works and doesn't start it, so using restart
  service "tomcat6" do
    action :restart
  end

  apache2_maintenance_mode do
    action :disable
  end

  service "apache2" do
    action :restart
  end

  service "nagios" do
    action :start
  end

end

action :stop do

  apache2_maintenance_mode do
    action :enable
  end

  service "nagios" do
    action :stop
  end

  service "apache2" do
    action :restart
  end

  service "tomcat6" do
    action :stop
  end

end

action :restart do

  service "nagios" do
    action :stop
  end

  service "tomcat6" do
    action :restart
  end

  service "apache2" do
    action :restart
  end

  service "nagios" do
    action :start
  end

end