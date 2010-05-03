def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Apache2SiteRestore
end

actions     :execute

attribute   :name, :kind_of => String, :name_attribute => true