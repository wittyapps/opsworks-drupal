node[:opsworks][:applications].each do | current_app |

    directory "/srv/www/#{current_app['name']}/current/sites/default/files" do
      owner "www-data"
      group "www-data"
      mode "777"
      recursive true
    end

end