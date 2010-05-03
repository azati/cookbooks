directory "/mnt/backup" do
  action :create
end

mysql_reset_root_password

mysql_db_backup "/mnt/backup/db.sql.gz" do
  action :execute
end

azati_folder_backup "#{node[:tomcat6][:catalina_base]}/webapps/ROOT" do
  tofile "/mnt/backup/liferay.tar.gz"
  action :execute
end

azati_folder_backup node[:liferay][:data_dir] do
  tofile "/mnt/backup/liferay_data.tar.gz"
  action :execute
end

execute "metadata_backup" do
  command "cp /opt/azati/shino/config/metadata.yml /mnt/backup/metadata.yml"
end

execute "context_backup" do
  command "cp /etc/tomcat6/context.xml /mnt/backup/context.xml"
end

execute "pack_backup" do
  cwd "/mnt/backup"
  command "tar -cf backup.tar db.sql.gz liferay.tar.gz liferay_data.tar.gz metadata.yml context.xml"
end

file "/mnt/backup/db.sql.gz" do
  action :delete
  backup false
end

file "/mnt/backup/liferay.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/liferay_data.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/metadata.yml" do
  action :delete
  backup false
end

file "/mnt/backup/context.xml" do
  action :delete
  backup false
end