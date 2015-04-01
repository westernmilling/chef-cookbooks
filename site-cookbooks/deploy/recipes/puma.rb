#
# Cookbook Name:: deploy
# Recipe:: puma
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#

directory '/var/www' do
  action :create
  group 'deploy'
  user 'deploy'
end

cookbook_file 'puma.sh' do
  action :create
  path '/etc/init.d/puma'
  mode '0755'
end

# TODO: Copy the puma defaults file
