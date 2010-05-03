case node[:openbravo][:system_stack]
when "start"
  openbravo_system_stack do
    action :start
  end
when "stop"
  openbravo_system_stack do
    action :stop
  end
when "restart"
  openbravo_system_stack do
    action :restart
  end
end