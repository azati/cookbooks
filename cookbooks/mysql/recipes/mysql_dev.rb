%w{ libmysql++-dev libmysqlclient15-dev }.each do |pkg|
  package pkg do
    action :install
  end
end