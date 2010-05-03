define :sugarce_update_domain do
  if params[:name]
    bash "update_domain_name" do
      code <<-EOH
perl -p -i -e "s/\'host_name\' => \'.*\'/\'host_name\' => \'#{params[:name]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'site_url\' => \'.*\'/\'site_url\' => \'http:\\/\\/#{params[:name]}\\/\'/" #{node[:apache][:default_docroot]}/config.php
EOH
    end
  end
end