define :tomcat6_setup_proxy, :address => "" do
  if params[:address] == ""
    bash "setup_proxy_and_address" do
    code <<-EOH
ADDR=`curl http://169.254.169.254/latest/meta-data/public-hostname`
perl -p -i -e "s/<Connector port=\\"8080\\" /<Connector port=\\"8080\\" proxyName=\\"$ADDR\\" proxyPort=\\"80\\" /" #{node[:tomcat6][:config_dir]}/server.xml
EOH
    end
  else
    bash "setup_proxy_and_address" do
    code <<-EOH
perl -p -i -e "s/<Connector port=\\"8080\\" /<Connector port=\\"8080\\" proxyName=\\"#{params[:address]}\\" proxyPort=\\"80\\" /" #{node[:tomcat6][:config_dir]}/server.xml
EOH
    end
  end
end
