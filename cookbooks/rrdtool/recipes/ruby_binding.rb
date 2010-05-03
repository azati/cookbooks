package "librrd2-dev" do
  action :install
end

remote_file "/tmp/RRD.so" do
  source "#{@node[:kernel][:machine] == "x86_64" ? "x86_64" : "x86_32"}/RRD.so"
  action :create
end

execute "/usr/bin/install -c -m 0755 /tmp/RRD.so /usr/local/lib/site_ruby/1.8" do
  action :run
end

file "/tmp/RRD.so" do
  action :delete
  backup false
end
