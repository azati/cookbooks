case node[:otrs][:system_stack]
when "start"
  otrs_system_stack do
    action :start
  end
when "stop"
  otrs_system_stack do
    action :stop
  end
when "restart"
  otrs_system_stack do
    action :restart
  end
end