case node[:orangehrm][:system_stack]
when "start"
  orangehrm_system_stack do
    action :start
  end
when "stop"
  orangehrm_system_stack do
    action :stop
  end
when "restart"
  orangehrm_system_stack do
    action :restart
  end
end