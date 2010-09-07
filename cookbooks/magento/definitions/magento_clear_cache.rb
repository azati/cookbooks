define :magento_clear_cache do
  execute "rm -rf #{node[:apache][:default_docroot]}/var/cache/*" do
    action :run
  end
end