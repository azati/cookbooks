case node[:sugarce_funambol][:service_web]
when "start"
  sugarce_funambol_service_web do
    action :start
  end
when "stop"
  sugarce_funambol_service_web do
    action :stop
  end
when "restart"
  sugarce_funambol_service_web do
    action :restart
  end
end