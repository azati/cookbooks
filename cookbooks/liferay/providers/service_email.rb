action :restart do

  service "nagios" do
    action :stop
    ignore_failure true
  end

  service "postfix" do
    action :restart
  end

  service "nagios" do
    action :start
    ignore_failure true
  end

end