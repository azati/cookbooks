template "/etc/hosts" do
  cookbook "azati"
  source "hosts.erb"
  mode "0644"
  owner "root"
  group "root"
  variables :hostname => node[:hostname]
  backup false
end
