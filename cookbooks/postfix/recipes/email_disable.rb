#%w{main.cf master.cf sasl_passwd.db}.each do |cfg|
#  remote_file "/etc/postfix/#{cfg}" do
#    action :delete
#    backup false
#  end
#end

%w{main master}.each do |cfg|
  template "/etc/postfix/#{cfg}.cf" do
    source "#{cfg}.cf.erb"
    owner  "root"
    group  "root"
    mode   0644
    backup false
  end
end

service "postfix" do
  action :restart
end