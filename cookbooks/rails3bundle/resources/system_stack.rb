def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Rails3bundleSystemStack
end

actions       :stop,:start,:restart