action :enable do
  apache_site "000-default" do
    enable false
  end
  apache_site "maintenance" do
    enable true
  end
end

action :disable do
  apache_site "maintenance" do
    enable false
  end
  apache_site "default" do
    enable true
  end
end