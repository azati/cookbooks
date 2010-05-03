directory "/mnt/backup" do
  action :create
end

postgresql_db_backup "/mnt/backup/db.sql.gz" do
  action :execute
end

azati_folder_backup node[:openbravo][:dir] do
  tofile "/mnt/backup/openbravo.tar.gz"
  action :execute
end

azati_folder_backup node[:openbravo][:attach_path] do
  tofile "/mnt/backup/openbravo_att.tar.gz"
  action :execute
end

execute "metadata_backup" do
  command "cp /opt/azati/shino/config/metadata.yml /mnt/backup/metadata.yml"
end

execute "pack_backup" do
  cwd "/mnt/backup"
  command "tar -cf backup.tar db.sql.gz openbravo.tar.gz openbravo_att.tar.gz metadata.yml"
end

file "/mnt/backup/db.sql.gz" do
  action :delete
  backup false
end

file "/mnt/backup/openbravo.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/openbravo_att.tar.gz" do
  action :delete
  backup false
end

file "/mnt/backup/metadata.yml" do
  action :delete
  backup false
end
