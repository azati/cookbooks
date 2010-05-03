case node[:redmine][:service_web]
when "start"
  redmine_service_web do
    action :start
  end
when "stop"
  redmine_service_web do
    action :stop
  end
when "restart"
  redmine_service_web do
    action :restart
  end
end