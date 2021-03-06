#
# Cookbook Name:: deploy
# Recipe:: sidekiq
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#

cookbook_file 'sidekiq_workers.conf' do
  action :create
  path '/etc/init/sidekiq_workers.conf'
  # mode '0755'
end

cookbook_file 'sidekiq.conf' do
  action :create
  path '/etc/init/sidekiq.conf'
  # mode '0755'
end

service 'sidekiq_workers' do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
  supports :restart => true,
           :start => true,
           :stop => true
end
