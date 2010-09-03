case node[:tomcat6bundle][:system_stack]
when "start"
  tomcat6bundle_system_stack do
    action :start
  end
when "stop"
  tomcat6bundle_system_stack do
    action :stop
  end
when "restart"
  tomcat6bundle_system_stack do
    action :restart
  end
end