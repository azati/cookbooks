action :start do

  apache2_maintenance_mode do
    action :disable
  end

  execute "mv -f #{node[:apache][:dir]}/otrs.maintenance #{node[:apache][:dir]}/conf.d/otrs" do
    action :run
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

  execute "mv -f #{node[:apache][:dir]}/conf.d/otrs #{node[:apache][:dir]}/otrs.maintenance" do
    action :run
  end

  service "nagios" do
    action :stop
  end

  service "apache2" do
    action :restart
  end
  
end

action :restart do

  service "nagios" do
    action :stop
  end

  service "apache2" do
    action :restart
  end

  service "nagios" do
    action :start
  end
  
end