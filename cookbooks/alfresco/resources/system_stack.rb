def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::AlfrescoSystemStack
end

actions       :stop,:start,:restart