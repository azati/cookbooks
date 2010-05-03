case node[:sugarce][:system_stack]
when "start"
  sugarce_system_stack do
    action :start
  end
when "stop"
  sugarce_system_stack do
    action :stop
  end
when "restart"
  sugarce_system_stack do
    action :restart
  end
end