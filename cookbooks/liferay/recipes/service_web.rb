case node[:liferay][:service_web]
when "start"
  liferay_service_web do
    action :start
  end
when "stop"
  liferay_service_web do
    action :stop
  end
when "restart"
  liferay_service_web do
    action :restart
  end
end