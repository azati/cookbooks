def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::LampbundleServiceEmail
end

actions     :restart