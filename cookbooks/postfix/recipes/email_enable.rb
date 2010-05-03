%w{main master}.each do |cfg|
  template "/etc/postfix/#{cfg}.cf" do
    source "#{cfg}.cf.erb"
    owner  "root"
    group  "root"
    mode   0644
    backup false
  end
end

template "/etc/postfix/sasl_passwd" do
  source "sasl_passwd.erb"
  owner  "root"
  owner  "root"
  mode   0644
  backup false
end

execute "postmap-sasl_passwd" do
  command "postmap /etc/postfix/sasl_passwd"
  action :run
end

remote_file "/etc/postfix/sasl_passwd" do
  action :delete
  backup false
end

service "postfix" do
  action [:enable, :start]
end