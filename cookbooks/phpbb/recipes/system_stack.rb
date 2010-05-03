case node[:phpbb][:system_stack]
when "start"
  phpbb_system_stack do
    action :start
  end
when "stop"
  phpbb_system_stack do
    action :stop
  end
when "restart"
  phpbb_system_stack do
    action :restart
  end
end