
execute "mysql-restore-db" do
    @cmd = ["/usr/bin/mysql",
            "-h'#{node[:adhoc_settings][:mysql][:hostname]}'",
            "-u'#{node[:adhoc_settings][:mysql][:master_username]}'",
            "-p'#{node[:adhoc_settings][:mysql][:master_password]}'",
            "< /tmp/mysql-restore-db.sql"]
    command @cmd.join(" ")
    action :nothing
end

template "mysql restore db" do
    path "/tmp/mysql-restore-db.sql"
    source "mysql-restore-db.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
        :backup_path => node[:adhoc_settings][:drupal][:database][:backup_path],
        :database => node[:adhoc_settings][:drupal][:database][:database_name]
    )
    notifies :run, resources(:execute => "mysql-create-db-and-grant-privs"), :immediately
end
