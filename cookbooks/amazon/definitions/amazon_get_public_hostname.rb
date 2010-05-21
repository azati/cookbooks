define :amazon_get_public_hostname do
  ruby_block "amazon_get_public_hostname" do
    block do
      node[:amazon][:public_hostname] = `curl http://169.254.169.254/latest/meta-data/public-hostname`.strip
    end
    action :create
  end
end
