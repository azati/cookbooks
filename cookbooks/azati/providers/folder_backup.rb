action :execute do
  execute "backup_folder" do
    cwd new_resource.name
    command "tar -czf #{new_resource.tofile} ."
  end
end