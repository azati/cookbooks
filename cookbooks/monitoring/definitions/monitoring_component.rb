define :monitoring_component do

  if params[:component][:script]
    remote_file"#{node[:nagios][:script_dir]}/#{params[:component][:script]}" do
      source "#{params[:name]}/#{params[:component][:script]}"
      mode	  0755
      backup false
    end
  end

  if params[:component][:cfg]
    remote_file"#{node[:nagios][:dir]}/conf.d/#{params[:component][:cfg]}" do
      source "#{params[:name]}/#{params[:component][:cfg]}"
      backup false
    end
  else
    template "#{node[:nagios][:dir]}/conf.d/#{params[:name]}.cfg" do
      source "component_config.erb"
      action :create
      variables :params=>params[:component], :name=>params[:name]
      backup false
    end
  end

  if params[:component][:handler]
    remote_file"#{node[:nagios][:script_dir]}/eventhandlers/#{params[:component][:handler]}" do
      source "#{params[:name]}/#{params[:component][:handler]}"
      backup false
    end
  end

  if params[:component][:n2rrd][:template]
    remote_file"#{node[:nagios][:n2rrd_dir]}/templates/rra/#{params[:component][:n2rrd][:template]}" do
      source "#{params[:name]}/#{params[:component][:n2rrd][:template]}"
      backup false
    end
  end

  if params[:component][:n2rrd][:script]
    remote_file"#{node[:nagios][:n2rrd_dir]}/templates/code/#{params[:component][:n2rrd][:script]}" do
      source "#{params[:name]}/#{params[:component][:n2rrd][:script]}"
      backup false
    end
  end

end
