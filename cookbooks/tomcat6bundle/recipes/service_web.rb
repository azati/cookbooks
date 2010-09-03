case node[:tomcat6bundle][:service_web]
when "start"
  tomcat6bundle_service_web do
    action :start
  end
when "stop"
  tomcat6bundle_service_web do
    action :stop
  end
when "restart"
  tomcat6bundle_service_web do
    action :restart
  end
end