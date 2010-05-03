case node[:mediawiki][:system_stack]
when "start"
  mediawiki_system_stack do
    action :start
  end
when "stop"
  mediawiki_system_stack do
    action :stop
  end
when "restart"
  mediawiki_system_stack do
    action :restart
  end
end