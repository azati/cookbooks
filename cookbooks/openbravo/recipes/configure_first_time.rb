#node[:openbravo][:login]                     = node[:params][:user_name]
node[:openbravo][:password]                   = node[:params][:password]
node[:openbravo][:domain_name]                = node[:params][:domain_name]

encrypt_openbravo_pass node[:openbravo][:password]

postgresql_reset_root_password

postgresql_command "ALTER ROLE #{node[:openbravo][:db_user]} WITH PASSWORD '#{node[:openbravo][:db_password]}';" do
  action :execute
end

template "#{node[:tomcat6][:catalina_base]}/webapps/openbravo/WEB-INF/Openbravo.properties" do
  source "Openbravo.properties.erb"
  backup false
end

template "#{node[:openbravo][:src_path]}/config/Openbravo.properties" do
  source "Openbravo.properties.erb"
  backup false
end

postgresql_command "UPDATE ad_user SET password = '#{node[:openbravo][:encrypted_password]}' WHERE name = 'Openbravo';" do
  action :execute
  dbname node[:openbravo][:db_name]
end

tomcat6_setup_proxy node[:openbravo][:domain_name]

log "Openbravo User - Openbravo"
log "Openbravo Password - #{node[:openbravo][:password]}"
