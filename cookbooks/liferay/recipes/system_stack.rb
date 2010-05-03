case node[:liferay][:system_stack]
when "start"
  liferay_system_stack do
    action :start
  end
when "stop"
  liferay_system_stack do
    action :stop
  end
when "restart"
  liferay_system_stack do
    action :restart
  end
end