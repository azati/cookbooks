package "bc" do
  action :install
end

monitoring_component "cpu" do
  component node[:nagios][:cpu]
end
