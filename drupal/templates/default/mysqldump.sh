TIMESTAMP=$(date -d "today" +"%Y%m%d%H%M")

rm /home/drush/*.mysql.gz

drush --root=/home/drush/<%= @app %> vset maintenance_mode 1 --yes

mysqldump -h <%= @db_ip %> -u <%= @username %> -p<%= @password %> <%= @database %> | gzip -9 > <%= @database %>-$TIMESTAMP.mysql.gz

drush --root=/home/drush/<%= @app %> vset maintenance_mode 0 --yes

s3cmd del s3://<%= @app %>/backup_migrate/latest.mysql.gz

s3cmd put /home/drush/<%= @database %>-$TIMESTAMP.mysql.gz s3://<%= @app %>/backup_migrate/latest.mysql.gz

s3cmd put /home/drush/<%= @database %>-$TIMESTAMP.mysql.gz s3://<%= @app %>/backup_migrate/<%= @database %>-$TIMESTAMP.mysql.gz