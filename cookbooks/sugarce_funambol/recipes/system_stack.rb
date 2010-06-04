case node[:sugarce_funambol][:system_stack]
when "start"
  sugarce_funambol_system_stack do
    action :start
  end
when "stop"
  sugarce_funambol_system_stack do
    action :stop
  end
when "restart"
  sugarce_funambol_system_stack do
    action :restart
  end
end