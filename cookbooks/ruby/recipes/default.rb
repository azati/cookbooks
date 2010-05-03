%w{ ruby irb rdoc ri ruby1.8-dev libruby }.each do |pkg|
  package pkg do
    action :install
  end
end