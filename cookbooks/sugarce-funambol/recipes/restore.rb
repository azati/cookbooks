sugarce_funambol_service_web do
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

apache2_site_restore "/mnt/restore/site.tar.gz" do
  action :execute
end

azati_folder_restore "/mnt/restore/funambol.tar.gz" do
  todir "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol"
  action :execute
end

service "mysql" do
  action :restart
end

sugarce_funambol_service_web do
  action :start
end
