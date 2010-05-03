liferay_service_web do
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

azati_folder_restore "/mnt/restore/liferay.tar.gz" do
  todir "#{node[:tomcat6][:catalina_base]}/webapps/ROOT"
  action :execute
end

azati_folder_restore "/mnt/restore/liferay_data.tar.gz" do
  todir node[:liferay][:data_dir]
  action :execute
end

execute "context_restore" do
  command "cp -f /mnt/restore/context.xml /etc/tomcat6/context.xml"
end

service "mysql" do
  action :restart
end

liferay_service_web do
  action :start
end
