#Including recipe, which configures apache to show his status

monitoring_component "apache" do
  component node[:nagios][:apache]
end

#monitoring https support
package "libssl-dev" do
  action :install
end
execute "cpan Crypt::SSLeay" do
  action :run
end
