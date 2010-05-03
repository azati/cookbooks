gem_package "rails" do
  version node[:ruby][:rails_ver]
  action :install
end