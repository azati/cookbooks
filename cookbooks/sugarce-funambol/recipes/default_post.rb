service "nagios" do
  action :stop
end

service "funambol" do
  action :stop
end

service "apache2" do
  action :stop
end

service "mysql" do
  action :stop
end

execute "apt-get clean" do
  action :run
end

execute "sync" do
  action :run
end

#produces strange error ERROR
#execute[history -c] (/opt/azati/chef/cookbooks/sugarce/recipes/30users_post.rb line 17) had an error: No such file or directory - history -c
#
#execute "history -c" do
#  action :run
#end
