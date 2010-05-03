define :liferay_update_domain do
  if params[:name]
    bash "update_config" do
      code <<-EOH
perl -p -i -e "s/proxyName=\\"\\S*\\"/proxyName=\\"#{params[:name]}\\"/" #{node[:tomcat6][:config_dir]}/server.xml
EOH
    end
  end
end
