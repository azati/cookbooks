case node[:phpbb][:service_web]
when "start"
  phpbb_service_web do
    action :start
  end
when "stop"
  phpbb_service_web do
    action :stop
  end
when "restart"
  phpbb_service_web do
    action :restart
  end
end