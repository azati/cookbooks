def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::MysqlCreateDb
end

actions     :create

attribute   :name, :kind_of => String, :name_attribute => true
attribute   :charset, :kind_of => String