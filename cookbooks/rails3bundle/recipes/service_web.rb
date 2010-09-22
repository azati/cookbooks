case node[:rails3bundle][:service_web]
when "start"
  rails3bundle_service_web do
    action :start
  end
when "stop"
  rails3bundle_service_web do
    action :stop
  end
when "restart"
  rails3bundle_service_web do
    action :restart
  end
end