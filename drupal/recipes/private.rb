
directory "/srv/private" do
  owner "www-data"
  group "www-data"
  mode "777"
  recursive true
end

directory "/srv/tmp" do
  owner "www-data"
  group "www-data"
  mode "777"
  recursive true
end