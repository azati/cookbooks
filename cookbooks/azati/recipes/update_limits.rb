bash "update_limits" do
  code <<-EOH
cat <<EOL >> /etc/security/limits.conf
root hard nofile 10240
root hard nofile 10240
EOL
EOH
end
