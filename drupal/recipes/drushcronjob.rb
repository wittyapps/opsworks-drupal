

cron "drupal_bb_all" do
  hour "10"
  minute "45"
  weekday "*"
  command "sh /home/ubuntu/drushbb.sh"
  mailto ""
  user "ubuntu"
end

node[:opsworks][:applications].each do | current_app |

    
    cron "drupal_core_cron_#{current_app['name']}" do
      hour "*"
      minute "*/30"
      weekday "*"
      command "drush --root=/home/ubuntu/drush/#{current_app['name']} core-cron --yes"
      user "ubuntu"
    end

    cron "drupal_clear_cache_#{current_app['name']}" do
      hour "11"
      minute "10"
      weekday "*"
      command "drush --root=/home/ubuntu/drush/#{current_app['name']} cc all --yes"
      mailto "<YOUR_ADMIN_EMAIL_HERE"
      user "ubuntu"
    end

        

end
