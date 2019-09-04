apt_package "s3cmd" do
  action :install
  source "http://s3tools.org/repo/deb-all/stable/s3cmd_1.0.0-4_all.deb"
end

cookbook_file "/home/ubuntu/.s3cfg" do
  source "s3cfg.tmp"
  path "/home/ubuntu/.s3cfg"
  mode 0755
  owner "ubuntu"
  action :create_if_missing
end


cookbook_file "/root/.s3cfg" do
  source "s3cfg.tmp"
  path "/root/.s3cfg"
  mode 0755
  owner "root"
  action :create_if_missing
end
