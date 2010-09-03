def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Tomcat6bundleSystemStack
end

actions       :stop,:start,:restart