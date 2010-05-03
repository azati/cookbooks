directory "/mnt/backup" do
  action :create
end

mysql_reset_root_password

mysql_db_backup "/mnt/backup/db.sql.gz" do
  action :execute
end

apache2_site_backup "/mnt/backup/site.tar.gz" do
  action :execute
end

azati_folder_backup node[:egroupware][:files_path] do
  tofile "/mnt/backup/egroupware_files.tar.gz"
  action :execute
end

azati_folder_backup node[:egroupware][:backup_path] do
  tofile "/mnt/backup/egroupware_backup.tar.gz"
  action :execute
end

execute "metadata_backup" do
  command "cp /opt/azati/shino/config/metadata.yml /mnt/backup/metadata.yml"
end

execute "pack_backup" do
  cwd "/mnt/backup"
  command "tar -cf backup.tar db.sql.gz site.tar.gz egroupware_files.tar.gz egroupware_backup.tar.gz metadata.yml"
end

file "/mnt/backup/db.sql.gz" do
  action :delete
  backup false
end

file "/mnt/backup/site.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/egroupware_files.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/egroupware_backup.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/metadata.yml" do
  action :delete
  backup false
end
