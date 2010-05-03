def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::MysqlGrant
end

actions     :run

attribute   :db_name, :kind_of => String, :name_attribute => true
attribute   :db_login, :kind_of => String
attribute   :db_host, :kind_of => String
attribute   :db_password, :kind_of => String
attribute   :with_grant_option, :kind_of => [ FalseClass, TrueClass ]