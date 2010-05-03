package "nmap" do
  action :install
end

monitoring_component "juggernaut" do
  component node[:nagios][:juggernaut]
end
