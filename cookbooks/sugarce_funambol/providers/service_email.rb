action :restart do

  service "nagios3" do
    action :stop
  end

  service "postfix" do
    action :restart
  end

  service "nagios3" do
    action :start
  end

end