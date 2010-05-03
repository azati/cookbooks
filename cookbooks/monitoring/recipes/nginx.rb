monitoring_component "nginx" do
  component node[:nagios][:nginx]
end
