directory node[:nginx][:maintenance_root] do
  owner "root"
  group "root"
  mode 0755
  action :create
end

remote_file "#{node[:nginx][:maintenance_root]}/index.html" do
  source "maintenance_index.html"
  owner "root"
  group "root"
  mode 0644
  backup false
end