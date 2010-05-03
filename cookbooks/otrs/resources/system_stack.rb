def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::OtrsSystemStack
end

actions       :stop,:start,:restart