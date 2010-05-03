case node[:zencart][:system_stack]
when "start"
  zencart_system_stack do
    action :start
  end
when "stop"
  zencart_system_stack do
    action :stop
  end
when "restart"
  zencart_system_stack do
    action :restart
  end
end