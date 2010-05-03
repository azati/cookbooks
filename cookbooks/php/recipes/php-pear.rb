package "php-pear" do
  action :install
end

node[:php][:pear_packages].each do |pkg|
  execute "pear install #{pkg}" do
    action :run
  end
end
