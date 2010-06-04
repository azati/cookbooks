def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::SugarceFunambolServiceWeb
end

actions       :stop,:start,:restart