def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::DotprojectServiceEmail
end

actions     :restart