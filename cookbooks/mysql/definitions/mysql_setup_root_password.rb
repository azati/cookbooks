define :mysql_setup_root_password do
  bash "setup_root_password" do
    code <<-EOH
mysqladmin -u root password #{node[:mysql][:root_password]}
EOH
  end
end