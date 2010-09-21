case node[:lampbundle][:system_stack]
when "start"
  lampbundle_system_stack do
    action :start
  end
when "stop"
  lampbundle_system_stack do
    action :stop
  end
when "restart"
  lampbundle_system_stack do
    action :restart
  end
end