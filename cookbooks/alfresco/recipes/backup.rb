directory "/mnt/backup" do
  action :create
end

mysql_reset_root_password

mysql_db_backup "/mnt/backup/db.sql.gz" do
  action :execute
end

azati_folder_backup "#{node[:tomcat6][:catalina_base]}/webapps/alfresco" do
  tofile "/mnt/backup/alfresco.tar.gz"
  action :execute
end

azati_folder_backup "#{node[:tomcat6][:catalina_base]}/webapps/share" do
  tofile "/mnt/backup/share.tar.gz"
  action :execute
end

azati_folder_backup node[:alfresco][:data_dir] do
  tofile "/mnt/backup/alfresco_data.tar.gz"
  action :execute
end

execute "metadata_backup" do
  command "cp /opt/azati/shino/config/metadata.yml /mnt/backup/metadata.yml"
end

execute "alfresco_properties_backup" do
  command "cp #{node[:tomcat6][:catalina_base]}/shared/classes/alfresco-global.properties /mnt/backup/alfresco-global.properties"
end

execute "pack_backup" do
  cwd "/mnt/backup"
  command "tar -cf backup.tar db.sql.gz alfresco.tar.gz share.tar.gz alfresco_data.tar.gz metadata.yml alfresco-global.properties"
end

file "/mnt/backup/db.sql.gz" do
  action :delete
  backup false
end

file "/mnt/backup/alfresco.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/share.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/alfresco_data.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/metadata.yml" do
  action :delete
  backup false
end

file "/mnt/backup/alfresco-global.properties" do
  action :delete
  backup false
end
