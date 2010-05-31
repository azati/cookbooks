#node[:alfresco][:login]                     = node[:params][:user_name]
node[:alfresco][:password]                   = node[:params][:password]
node[:alfresco][:domain_name]                = node[:params][:domain_name]

include_recipe "azati::add_hostname_to_hosts_file"

encrypt_alfresco_pass node[:alfresco][:password]

mysql_reset_root_password

mysql_grant node[:alfresco][:db_name] do
  action :run
  db_login node[:alfresco][:db_login]
  db_host node[:alfresco][:db_host]
  db_password node[:alfresco][:db_password]
  with_grant_option true
end

mysql_grant node[:alfresco][:db_name] do
  action :run
  db_login node[:alfresco][:db_login]
  db_host "localhost.localdomain"
  db_password node[:alfresco][:db_password]
  with_grant_option true
end

template "#{node[:tomcat6][:catalina_base]}/shared/classes/alfresco-global.properties" do
  source "alfresco-global.properties.erb"
  owner node[:tomcat6][:user]
  group node[:tomcat6][:group]
  backup false
end

=begin
TODO: review
hardcoded
better to check via
SELECT anp1.node_id, anp1.qname_id, anp1.string_value
FROM alf_node_properties anp1
INNER JOIN alf_qname aq1 ON aq1.id = anp1.qname_id
INNER JOIN alf_node_properties anp2 ON anp2.node_id = anp1.node_id
INNER JOIN alf_qname aq2 ON aq2.id = anp2.qname_id
WHERE aq1.local_name = 'password' AND aq2.local_name = 'username' AND anp2.string_value = 'admin';
=end
mysql_command "UPDATE #{node[:alfresco][:db_name]}.alf_node_properties SET string_value='#{node[:alfresco][:encrypted_password]}' WHERE node_id=4 AND qname_id=10;" do
  action :execute
end

tomcat6_setup_proxy node[:alfresco][:domain_name]

log "Alfresco User - #{node[:alfresco][:login]}"
log "Alfresco Password - #{node[:alfresco][:password]}"
