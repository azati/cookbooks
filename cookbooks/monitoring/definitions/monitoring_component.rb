define :monitoring_component do

  if params[:component][:script]
    remote_file"#{node[:nagios][:dir]}/libexec/#{params[:component][:script]}" do
      source "#{params[:name]}/#{params[:component][:script]}"
      mode	  0755
      owner	 "nagios"
      group  "nagcmd"
      backup false
    end
  end

  if params[:component][:cfg]
    remote_file"#{node[:nagios][:dir]}/etc/objects/#{params[:component][:cfg]}" do
      source "#{params[:name]}/#{params[:component][:cfg]}"
      mode	  0755
      owner	 "nagios"
      group  "nagcmd"
      backup false
    end
  else
    template "#{node[:nagios][:dir]}/etc/objects/#{params[:name]}.cfg" do
      source "component_config.erb"
      action :create
      variables :params=>params[:component], :name=>params[:name]
      mode	  0755
      owner	 "nagios"
      group  "nagcmd"
      backup false
    end
  end

  if params[:component][:handler]
    remote_file"#{node[:nagios][:dir]}/libexec/eventhandlers/#{params[:component][:handler]}" do
      source "#{params[:name]}/#{params[:component][:handler]}"
      mode	  0755
      owner	 "nagios"
      group  "nagcmd"
      backup false
    end
  end

  if params[:component][:n2rrd][:template]
    remote_file"#{node[:nagios][:n2rrd_dir]}/templates/rra/#{params[:component][:n2rrd][:template]}" do
      source "#{params[:name]}/#{params[:component][:n2rrd][:template]}"
      mode	  0755
      owner	 "nagios"
      group  "nagcmd"
      backup false
    end
  end

  if params[:component][:n2rrd][:script]
    remote_file"#{node[:nagios][:n2rrd_dir]}/templates/code/#{params[:component][:n2rrd][:script]}" do
      source "#{params[:name]}/#{params[:component][:n2rrd][:script]}"
      mode	  0755
      owner	 "nagios"
      group  "nagcmd"
      backup false
    end
  end

  
end
