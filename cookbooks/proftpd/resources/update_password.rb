def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::ProftpdUpdatePassword
end

actions     :update

attribute   :login, :kind_of => String, :name_attribute => true
attribute   :password, :kind_of => String
attribute   :system_login, :kind_of => String
