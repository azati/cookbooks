def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::JoomlaSystemStack
end

actions       :stop,:start,:restart