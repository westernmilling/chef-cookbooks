#
# Cookbook Name:: mariadb
# Recipe:: server
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# After running this don't forget to run mysql_secure_installation
include_recipe 'apt'

apt_package 'mariadb-server' do
  action :install
end

execute "Allow remote connections" do
    command "sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf"
    action :run
end

service 'mysql' do
  action :restart
end
