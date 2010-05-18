%w{ libmysql++-dev libmysqlclient-dev }.each do |pkg|
  package pkg do
    action :install
  end
end