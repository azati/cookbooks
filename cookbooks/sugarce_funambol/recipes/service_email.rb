case node[:sugarce_funambol][:service_email]
when "restart"
  sugarce_funambol_service_email do
    action :restart
  end
end