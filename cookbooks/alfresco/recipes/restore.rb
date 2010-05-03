alfresco_service_web do
  action :stop
end

mysql_reset_root_password

execute "unpack_restore_archive" do
  cwd "/mnt/restore"
  command "tar -xf restore.tar"
end

execute "unpack_mysql_dump" do
  cwd "/mnt/restore"
  command "gzip -d db.sql.gz"
end

mysql_db_restore "/mnt/restore/db.sql" do
  action :execute
end

azati_folder_restore "/mnt/restore/alfresco.tar.gz" do
  todir "#{node[:tomcat6][:catalina_base]}/webapps/alfresco"
  action :execute
end

azati_folder_restore "/mnt/restore/share.tar.gz" do
  todir "#{node[:tomcat6][:catalina_base]}/webapps/share"
  action :execute
end

azati_folder_restore "/mnt/restore/alfresco_data.tar.gz" do
  todir node[:alfresco][:data_dir]
  action :execute
end

execute "alfresco_properties_restore" do
  command "cp -f /mnt/restore/alfresco-global.properties #{node[:tomcat6][:catalina_base]}/shared/classes/alfresco-global.properties"
end

service "mysql" do
  action :restart
end

alfresco_service_web do
  action :start
end