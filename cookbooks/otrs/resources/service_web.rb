def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::OtrsServiceWeb
end

actions       :stop,:start,:restart