def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Rake
end

actions     :run

attribute   :name, :kind_of => String, :name_attribute => true
attribute   :cwd, :kind_of => String
