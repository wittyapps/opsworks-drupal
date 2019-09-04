apt_package "drush" do
  action :install
end

apt_package "unzip" do
  action :install
end

apt_package "mailutils" do
  options "-q -y"
  action :install
end

apt_package "php5-curl" do
  action :install
end

directory "/home/ubuntu" do
    mode "755"
    action :create
end

directory "/home/ubuntu/drush" do
    mode "755"
    action :create
end

# Set up git to use SSH authentication 
cookbook_file "/home/ubuntu/.ssh/wrapssh4git.sh" do 
  source "wrapssh4git.sh" 
  owner "ubuntu" 
  mode 0700 
end

# Public key 
template "/home/ubuntu/.ssh/codecommit_key.pub" do 
  source "codecommit_key.pub" 
  owner "ubuntu" 
  mode 0600 
end 
 
# Private key 
template "/home/ubuntu/.ssh/codecommit_key" do 
  source "codecommit_key" 
  owner "ubuntu" 
  mode 0600 
end



directory "/home/ubuntu/private" do
  mode "777"
  recursive true
end

directory "/home/ubuntu/restore" do
  mode "755"
  recursive true
end

cookbook_file "/home/ubuntu/drushbb.sh" do
  source "drushbb.sh"
  path "/home/ubuntu/drushbb.sh"
  mode 0755
  action :create_if_missing
end

