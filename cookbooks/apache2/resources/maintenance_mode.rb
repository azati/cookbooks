def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::Apache2MaintenanceMode
end

actions     :enable, :disable