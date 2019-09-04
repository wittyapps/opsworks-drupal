

node[:opsworks][:applications].each do | current_app |

    execute "s3cmd-settings-#{current_app['name']}" do
        command "s3cmd get --force s3://#{current_app['name']}/settings/settings.php /srv/www/#{current_app['name']}/current/sites/default/settings.php"
        user "root"
        action :run
    end
        

end