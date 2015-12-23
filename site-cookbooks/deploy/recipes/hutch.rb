#
# Cookbook Name:: hutch
# Recipe:: hutch
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#

cookbook_file 'hutch.conf' do
  action :create
  path '/etc/init/hutch.conf'
end

service 'hutch' do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
  supports :restart => true,
           :start => true,
           :stop => true
end
