def initialize(name, collection=nil, node=nil)
  super(name, collection, node)
  @provider = Chef::Provider::UpdateRcD
end

actions     :defaults, :start, :stop, :remove

attribute   :name, :kind_of => String, :name_attribute => true

attribute   :nn, :kind_of => Fixnum
attribute   :runlvl, :kind_of => Array