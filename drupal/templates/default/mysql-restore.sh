rm <%= @database %>.mysql.gz

s3cmd get s3://<%= @database %>/backup_migrate/latest.mysql.gz <%= @database %>.mysql.gz

gunzip <%= @database %>.mysql.gz

mysql -h <%= @db_private_ip %> -u <%= @username %> -p<%= @password %> <%= @database %> < <%= @database %>.mysql

rm <%= @database %>.mysql 


