def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Tomcat6bundleServiceEmail
end

actions     :restart