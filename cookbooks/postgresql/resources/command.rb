def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::PostgresqlCommand
end

actions     :execute

attribute   :name, :kind_of => String, :name_attribute => true
attribute   :dbname, :kind_of => String
