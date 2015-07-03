#
# Cookbook Name:: deploy
# Recipe:: unicorn
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
directory '/etc/unicorn' do
  action :create
end

directory '/var/www' do
  action :create
  group 'deploy'
  user 'deploy'
end

cookbook_file 'unicorn.sh' do
  action :create
  path '/etc/init.d/unicorn'
  mode '0755'
end

service 'unicorn' do
  action [:enable, :start]
  supports :restart => true,
    :reload => true,
    :start => true,
    :stop => true,
    :upgrade => true
end