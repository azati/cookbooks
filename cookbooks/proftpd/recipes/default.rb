package "proftpd-basic" do
  action :install
end

remote_file "/opt/azati/lib/ftpasswd_hash_gen.sh" do
  source "ftpasswd_hash_gen.sh"
  mode "0755"
  owner "root"
  group "root"
end
