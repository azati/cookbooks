define :sugarce_funambol_update_domain do
  if params[:name]

    bash "update_domain_name" do
      code <<-EOH
perl -p -i -e "s/\'host_name\' => \'.*\'/\'host_name\' => \'#{params[:name]}\'/" #{node[:apache][:default_docroot]}/config.php
perl -p -i -e "s/\'site_url\' => \'.*\'/\'site_url\' => \'http:\\/\\/#{params[:name]}\\/\'/" #{node[:apache][:default_docroot]}/config.php
EOH
    end

    template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/config/com/funambol/server/security/SugarcrmOfficer.xml" do
      source "SugarcrmOfficer.xml.erb"
      variables :sugarce_funambol_domain_name => params[:name]
      backup false
    end

    template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/config/sugar-crm-8.0/sugar-crm-8.0/sugar-ca-8.0/calendars.xml" do
      source "calendars.xml.erb"
      variables :sugarce_funambol_domain_name => params[:name]
      mode "0644"
      owner "root"
      group "root"
      backup false
    end

    template "#{node[:sugarce_funambol][:funambol_data_dir]}/Funambol/config/sugar-crm-8.0/sugar-crm-8.0/sugar-co-8.0/contacts.xml" do
      source "contacts.xml.erb"
      variables :sugarce_funambol_domain_name => params[:name]
      mode "0644"
      owner "root"
      group "root"
      backup false
    end

  end
end