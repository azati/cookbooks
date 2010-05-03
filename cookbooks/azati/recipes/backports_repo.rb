execute "add_backports_repo" do
  command "echo \"deb http://us.archive.ubuntu.com/ubuntu/ hardy-backports main restricted universe multiverse\" >> /etc/apt/sources.list"
  action :run
end