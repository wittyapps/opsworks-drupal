node[:opsworks][:applications].each do | current_app |
    
    git "/home/ubuntu/drush/#{current_app['name']}" do
        repository "ssh://<YOUR_KEY_HERE>@git-codecommit.us-east-1.amazonaws.com/v1/repos/#{current_app['name']}"
        reference "master"
        action :sync
        ssh_wrapper "/home/ubuntu/.ssh/wrapssh4git.sh"
    end

end