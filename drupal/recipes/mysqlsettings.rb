
node[:opsworks][:applications].each do | current_app |

    first_domain = node["deploy"][current_app['slug_name']]["domains"][0]
    
    if node["deploy"][current_app['slug_name']]['ssl_support']
        domain = "https://#{first_domain}"
    else
        domain = "http://#{first_domain}"
    end


    execute "s3cmd-settings-#{current_app['name']}-public" do
        command "s3cmd put /tmp/settings_#{current_app['name']}_public.php s3://#{current_app['name']}/settings/settings_public.php"
        action :nothing
    end
    
    template "Build settings #{current_app['name']} public" do
        path "/tmp/settings_#{current_app['name']}_public.php"
        source settings_source
        mode "0755"
        variables(
            :db_private_ip => node[:opsworks][:instance][:ip],
            :username => "root",
            :password => "<YOUR_MYSQL_PASSWORD_HERE>",
            :database => current_app['name'],
            :domain => domain
        )
        notifies :run, resources(:execute => "s3cmd-settings-#{current_app['name']}-public"), :immediately
    end
    
    
    execute "s3cmd-settings-#{current_app['name']}" do
        command "s3cmd put /tmp/settings_#{current_app['name']}.php s3://#{current_app['name']}/settings/settings.php"
        action :nothing
    end
    
    template "Build settings #{current_app['name']}" do
        path "/tmp/settings_#{current_app['name']}.php"
        source settings_source
        mode "0755"
        variables(
            :db_private_ip => node[:opsworks][:instance][:private_ip],
            :username => "root",
            :password => "<YOUR_MYSQL_PASSWORD_HERE>",
            :database => current_app['name'],
            :domain => domain
        )
        notifies :run, resources(:execute => "s3cmd-settings-#{current_app['name']}"), :immediately
    end

end