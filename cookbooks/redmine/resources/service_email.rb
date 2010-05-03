def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::RedmineServiceEmail
end

actions     :restart