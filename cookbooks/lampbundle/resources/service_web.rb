def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::LampbundleServiceWeb
end

actions       :stop,:start,:restart