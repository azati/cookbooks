def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::JoomlaServiceEmail
end

actions     :restart