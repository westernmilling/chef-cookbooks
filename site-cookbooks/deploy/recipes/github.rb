#
# Cookbook Name:: deploy
# Recipe:: githubgithub
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#

directory "/home/deploy/.ssh" do
  action :create
  mode '0700'
  owner 'deploy'
  group 'deploy'
end

cookbook_file 'ssh_config' do
  action :create_if_missing
  path "/home/deploy/.ssh/config"
  mode '0600'
  owner 'deploy'
  group 'deploy'
end

execute 'ssh -T git@github.com -o StrictHostKeyChecking=no' do
  action :run
  returns 1
  user 'deploy'
end
