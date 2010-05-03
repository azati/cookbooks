case node[:dotproject][:service_web]
when "start"
  dotproject_service_web do
    action :start
  end
when "stop"
  dotproject_service_web do
    action :stop
  end
when "restart"
  dotproject_service_web do
    action :restart
  end
end