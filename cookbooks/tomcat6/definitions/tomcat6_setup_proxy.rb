define :tomcat6_setup_proxy do
  template "#{node[:tomcat6][:config_dir]}/server.xml" do
    source "server.xml.erb"
    variables({
      :public_address => params[:name]
    })
    owner "root"
    group [:tomcat6][:group]
    mode "0644"
    backup false
  end
end
