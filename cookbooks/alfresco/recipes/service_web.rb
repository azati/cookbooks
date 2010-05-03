case node[:alfresco][:service_web]
when "start"
  alfresco_service_web do
    action :start
  end
when "stop"
  alfresco_service_web do
    action :stop
  end
when "restart"
  alfresco_service_web do
    action :restart
  end
end