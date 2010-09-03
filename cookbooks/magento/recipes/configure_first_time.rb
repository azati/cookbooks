#node[:magento][:login]            = node[:params][:user_name]
node[:magento][:password]         = node[:params][:password]
node[:magento][:domain_name]      = node[:params][:domain_name]

mysql_reset_root_password

mysql_grant node[:magento][:db_name] do
  action :run
  db_host node[:magento][:db_host]
  db_login node[:magento][:db_login]
  db_password node[:magento][:db_password]
end

template "#{node[:apache][:default_docroot]}/app/etc/local.xml" do
  source "local.xml.erb"
  mode "0777"
end

mysql_command "UPDATE #{node[:magento][:db_name]}.admin_user SET password=CONCAT(MD5('#{node[:magento][:salt]}#{node[:magento][:password]}'), ':#{node[:magento][:salt]}') WHERE username='#{node[:magento][:login]}';" do
  action :execute
end

magento_update_domain node[:magento][:domain_name]

log "Magento User - #{node[:magento][:login]}"
log "Magento Password - #{node[:magento][:password]}"