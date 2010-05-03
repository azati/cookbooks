case node[:dotproject][:service_email]
when "restart"
  dotproject_service_email do
    action :restart
  end
end