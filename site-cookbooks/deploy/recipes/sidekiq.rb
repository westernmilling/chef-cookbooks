#
# Cookbook Name:: deploy
# Recipe:: sidekiq
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#

cookbook_file 'sidekiq.sh' do
  action :create
  path '/etc/init.d/sidekiq'
  mode '0755'
end

service 'sidekiq' do
  action [:enable, :start]
  supports :restart => true,
    :reload => true,
    :start => true,
    :stop => true,
    :upgrade => true
end
