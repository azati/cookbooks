case node[:mediawiki][:service_web]
when "start"
  mediawiki_service_web do
    action :start
  end
when "stop"
  mediawiki_service_web do
    action :stop
  end
when "restart"
  mediawiki_service_web do
    action :restart
  end
end