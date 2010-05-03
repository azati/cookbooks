case node[:alfresco][:system_stack]
when "start"
  alfresco_system_stack do
    action :start
  end
when "stop"
  alfresco_system_stack do
    action :stop
  end
when "restart"
  alfresco_system_stack do
    action :restart
  end
end