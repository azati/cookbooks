def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::ZencartServiceEmail
end

actions     :restart