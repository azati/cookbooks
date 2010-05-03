def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::PhpbbSystemStack
end

actions       :stop,:start,:restart