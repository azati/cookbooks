def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::ZencartServiceWeb
end

actions       :stop,:start,:restart