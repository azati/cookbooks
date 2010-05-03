action :execute do
  execute "site_backup" do
    cwd node[:apache][:default_docroot]
    command "tar -czf #{new_resource.name} ."
  end
end