def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Rails3bundleServiceWeb
end

actions       :stop,:start,:restart