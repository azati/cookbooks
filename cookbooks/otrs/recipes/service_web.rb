case node[:otrs][:service_web]
when "start"
  otrs_service_web do
    action :start
  end
when "stop"
  otrs_service_web do
    action :stop
  end
when "restart"
  otrs_service_web do
    action :restart
  end
end