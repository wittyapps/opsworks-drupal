execute "mysql-ssl-setup-wittyapps" do
    command "sudo mysql_ssl_rsa_setup --uid=mysql"
    action :execute
end

service "mysql" do
  action :restart
end

execute "mysql-create-remote-user" do
    @cmd = ["/usr/bin/mysql",
            "-u root",
            "-p <YOUR_PASSWORD_HERE>",
            "CREATE USER 'drupal'@'*' IDENTIFIED BY '<YOUR_PASSWORD_HERE>' REQUIRE SSL;"]
    command @cmd.join(" ")
    action :execute
end


execute "mysql-grant-remote-user" do
    @cmd = ["/usr/bin/mysql",
            "-u root",
            "-p <YOUR_PASSWORD_HERE>",
            "GRANT ALL ON *.* TO 'drupal'@'*';"]
    command @cmd.join(" ")
    action :execute
end

execute "mysql-flush" do
    @cmd = ["/usr/bin/mysql",
            "-u root",
            "-p <YOUR_PASSWORD_HERE>",
            "FLUSH PRIVILEGES;"]
    command @cmd.join(" ")
    action :execute
end

ruby_block "my_config_secure_transport" do
  block do
    file = Chef::Util::FileEdit.new("/etc/mysql/my.cnf")
    file.insert_line_if_no_match("require_secure_transport = OFF", "require_secure_transport = ON")
    file.write_file
  end
end

ruby_block "my_config_bind_address" do
  block do
    file = Chef::Util::FileEdit.new("/etc/mysql/my.cnf")
    file.insert_line_if_no_match("bind-address = 127.0.0.1", "bind-address = 0.0.0.0")
    file.write_file
  end
end

service "mysql" do
  action :restart
end