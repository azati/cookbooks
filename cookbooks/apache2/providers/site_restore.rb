action :execute do
  execute "clear_site_folder" do
    command "rm -rf #{node[:apache][:default_docroot]}/*"
  end

  execute "site_restore" do
    command "tar -xzf #{new_resource.name} -C #{node[:apache][:default_docroot]}"
  end
end