#trick to accept licence
package "sun-java6-jdk" do
  response_file "java.seed"
  action :install
end

#trick to bypass random exit code returned by update-java-alternatives
execute "update-java-alternatives -s java-6-sun" do
  action :run
  ignore_failure true
  returns 2
end

bash "java_env_vars" do
  code <<-EOH
echo 'JAVA_HOME="#{node[:java][:java_home]}"' | sudo tee -a /etc/environment
echo 'JAVA_OPTS="#{node[:java][:java_opts]}"' | sudo tee -a /etc/environment
EOH
end