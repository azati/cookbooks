case node[:redmine][:system_stack]
when "start"
  redmine_system_stack do
    action :start
  end
when "stop"
  redmine_system_stack do
    action :stop
  end
when "restart"
  redmine_system_stack do
    action :restart
  end
end