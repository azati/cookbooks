action :restart do

  service "nagios" do
    action :stop
  end

  service "postfix" do
    action :restart
  end

  service "nagios" do
    action :start
  end

end