#there is no config template due to very different configurations

%w{ libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev libpam0g libpam0g-dev }.each do |pkg|
  package pkg do
    action :install
  end
end

bash "create_nginx_user_and_group" do
  code <<-EOH
groupadd nginx && useradd -g nginx nginx
EOH
end

remote_file "/mnt/nginx-0.7.67.tar.gz" do
  source "http://data.azati.s3.amazonaws.com/nginx/nginx-0.7.67.tar.gz"
end
remote_file "/mnt/gnosek-nginx-upstream-fair-2131c73.tar.gz" do
  source "http://data.azati.s3.amazonaws.com/nginx/gnosek-nginx-upstream-fair-2131c73.tar.gz"
end
remote_file "/mnt/ngx_http_auth_pam_module-1.1.tar.gz" do
  source "http://data.azati.s3.amazonaws.com/nginx/ngx_http_auth_pam_module-1.1.tar.gz"
end

bash "compile_nginx" do
  code <<-EOH
cd /mnt
tar -xzf nginx-0.7.67.tar.gz
tar -xzf gnosek-nginx-upstream-fair-2131c73.tar.gz
tar -xzf ngx_http_auth_pam_module-1.1.tar.gz
cd nginx-0.7.67
./configure --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-http_ssl_module --without-http_fastcgi_module --user=nginx --group=nginx --add-module=/mnt/gnosek-nginx-upstream-fair-2131c73 --add-module=/mnt/ngx_http_auth_pam_module-1.1
make && make install
EOH
end

directory "/mnt/nginx-0.7.67" do
  recursive true
  action :delete
end
file "/mnt/nginx-0.7.67.tar.gz" do
  action :delete
end
file "/mnt/gnosek-nginx-upstream-fair-2131c73.tar.gz" do
  action :delete
end
file "/mnt/ngx_http_auth_pam_module-1.1.tar.gz" do
  action :delete
end

remote_file "/etc/init.d/nginx" do
  source "nginx"
  owner "root"
  group "root"
  mode "0755"
end

service "nginx" do
  action :enable
end
