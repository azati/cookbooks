directory node[:apache][:maintenance_root] do
  owner "root"
  group "root"
  mode 0755
  action :create
end

remote_file "#{node[:apache][:maintenance_root]}/index.html" do
  source "maintenance_index.html"
  owner "root"
  group "root"
  mode 0644
  backup false
end

template "#{node[:apache][:dir]}/sites-available/maintenance" do
  source "maintenance.conf.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end
