def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::MediawikiSystemStack
end

actions       :stop,:start,:restart