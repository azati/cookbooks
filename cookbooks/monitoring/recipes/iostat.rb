#Installing package, needed to iostat
package "sysstat" do
  action :install
end

monitoring_component "iostat" do
  component node[:nagios][:iostat]
end

