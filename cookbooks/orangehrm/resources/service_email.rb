def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::OrangehrmServiceEmail
end

actions     :restart