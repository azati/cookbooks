def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::MagentoServiceEmail
end

actions     :restart