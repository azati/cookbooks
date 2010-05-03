def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::MysqlCommand
end

actions     :execute, :import

attribute   :name, :kind_of => String, :name_attribute => true
attribute   :db_name, :kind_of => String