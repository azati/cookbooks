case node[:dotproject][:system_stack]
when "start"
  dotproject_system_stack do
    action :start
  end
when "stop"
  dotproject_system_stack do
    action :stop
  end
when "restart"
  dotproject_system_stack do
    action :restart
  end
end