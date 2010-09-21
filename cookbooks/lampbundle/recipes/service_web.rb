case node[:lampbundle][:service_web]
when "start"
  lampbundle_service_web do
    action :start
  end
when "stop"
  lampbundle_service_web do
    action :stop
  end
when "restart"
  lampbundle_service_web do
    action :restart
  end
end