def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::EgroupwareServiceWeb
end

actions       :stop,:start,:restart