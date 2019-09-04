node[:opsworks][:applications].each do | current_app |

    execute "restore-mysql-#{current_app['name']}" do
        command "sh /home/ubuntu/mysql-restore-#{current_app['name']}.sh"
        action :nothing
    end
    
    template "restore #{current_app['name']} script" do
        path "/home/ubuntu/mysql-restore-#{current_app['name']}.sh"
        source "mysql-restore.sh"
        mode "0755"
        variables(
            :db_private_ip => node[:opsworks][:instance][:private_ip],
            :username => "root",
            :password => "<YOUR_MYSQL_PASSWORD_HERE>",
            :database => current_app['name']
        )
        notifies :run, resources(:execute => "restore-mysql-#{current_app['name']}"), :immediately
    end
    
end