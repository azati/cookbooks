#If you want to use with component, you should create nagios@localhost user in your mysql-server with password 'Nu71QHuSgOtTxXCIYPKJ'

monitoring_component "mysql" do
  component node[:nagios][:mysql]
end
