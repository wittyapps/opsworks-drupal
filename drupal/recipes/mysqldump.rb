node[:opsworks][:applications].each do | current_app |

    execute "s3cmd-#{current_app['slug_name']}-mysqldump-shell" do
        command "s3cmd put /tmp/mysqldump-#{current_app['slug_name']}.sh s3://#{current_app['slug_name']}/settings/mysqldump.sh"
        action :nothing
    end
    
    template "Build #{current_app['name']} mysqldump shell" do
        path "/tmp/mysqldump-#{current_app['slug_name']}.sh"
        source "mysqldump.sh"
        mode "0755"
        variables(
            :db_ip => node[:opsworks][:instance][:ip],
            :username => "root",
            :password => "<YOUR_MYSQL_PASSWORD_HERE>",
            :database => current_app['slug_name'],
            :app => current_app['slug_name']
        )
        notifies :run, resources(:execute => "s3cmd-#{current_app['slug_name']}-mysqldump-shell"), :immediately
    end
    
end