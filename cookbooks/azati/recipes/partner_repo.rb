execute "add_partner_repo" do
  command "echo \"deb http://archive.canonical.com/ubuntu lucid partner\" > /etc/apt/sources.list.d/ubuntu-partner.list"
  action :run
end
