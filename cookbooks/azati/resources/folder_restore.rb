def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::AzatiFolderRestore
end

actions     :execute

attribute   :name, :kind_of => String, :name_attribute => true
attribute   :todir, :kind_of => String