%w{ mysql-server mysql-client }.each do |pkg|
  package pkg do
    action :install
  end
end

template "my.cnf" do
  path "#{node[:mysql][:dir]}/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

file node[:mysql][:log_slow_queries] do
  owner "root"
  group "root"
  mode "0666"
  action :create
end

file node[:mysql][:mysqld_safe][:log_error] do
  owner "root"
  group "root"
  mode "0666"
  action :create
end

service "mysql" do
  action :enable
end

directory "/opt/azati/lib" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "/opt/azati/lib/dbms-rootpassword-reset.sh" do
  source "dbms-rootpassword-reset.sh"
  mode "0755"
  owner "root"
  group "root"
end

remote_file "/opt/azati/lib/dbms-password-reset.sh" do
  source "dbms-password-reset.sh"
  mode "0755"
  owner "root"
  group "root"
end

remote_file "/opt/azati/lib/generate-random-password.sh" do
  source "generate-random-password.sh"
  mode "0755"
  owner "root"
  group "root"
end
