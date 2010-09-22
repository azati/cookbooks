rails3bundle_service_web do
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

azati_folder_restore "/mnt/restore/rails3bundle.tar.gz" do
  todir node[:rails3bundle][:dir]
  action :execute
end

service "mysql" do
  action :restart
end

rails3bundle_service_web do
  action :start
end
