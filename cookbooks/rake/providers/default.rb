action :run do
  execute "rake #{new_resource.name}" do
    action :run
    cwd     new_resource.cwd
  end
end