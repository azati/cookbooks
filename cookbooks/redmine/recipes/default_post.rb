execute "add_repo" do
  command "ruby #{node[:redmine][:dir]}/extra/svn/reposman.rb --redmine http://localhost --svn-dir #{node[:redmine][:svn_dir]} --owner #{node[:apache][:user]} --url http://127.0.0.1:8080/svn-private/"
  action :run
end

service "thin" do
  action :stop
end

service "nginx" do
  action :stop
end

service "mysql" do
  action :stop
end

service "apache2" do
  action :stop
end

execute "apt-get clean" do
  action :run
end

execute "sync" do
  action :run
end
