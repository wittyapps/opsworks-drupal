execute "mysql-create-db-and-grant-privs" do
    @cmd = ["/usr/bin/mysql",
            "-h'#{node[:adhoc_settings][:mysql][:hostname]}'",
            "-u'#{node[:adhoc_settings][:mysql][:master_username]}'",
            "-p'#{node[:adhoc_settings][:mysql][:master_password]}'",
            "< /tmp/create-db-and-grant-privs.sql"]
    command @cmd.join(" ")
    action :nothing
end

template "Grant privileges to mysql account for app db" do
    path "/tmp/create-db-and-grant-privs.sql"
    source "create-db-and-grant-privs.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
        :username => node[:adhoc_settings][:drupal][:database][:username],
        :password => node[:adhoc_settings][:drupal][:database][:password],
        :database => node[:adhoc_settings][:drupal][:database][:database_name]
    )
    notifies :run, resources(:execute => "mysql-create-db-and-grant-privs"), :immediately
end

git "Download drupal" do
    repository node[:general_settings][:drupal][:repo_url]
    revision node[:general_settings][:drupal][:repo_branch]
    destination "/tmp/drupal-checkout"
    action :checkout

    #not_if do
    #    ::File.directory?("/tmp/drupal-checkout")
    #end
end
#execute "Ensure correct permissions" do
#  command "chmod -R go-rwx #{node[:opsworks_custom_cookbooks][:destination]}"
#  only_if do
#    ::File.exists?(node[:opsworks_custom_cookbooks][:destination])
#  end
#end

