action :execute do
  execute "clear_folder" do
    command "rm -rf #{new_resource.todir}/*"
  end

  execute "folder_restore" do
    command "tar -xzf #{new_resource.name} -C #{new_resource.todir}"
  end
end