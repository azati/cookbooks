def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::EgroupwareSystemStack
end

actions       :stop,:start,:restart