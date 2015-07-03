#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'tar'

remote_file "nodejs-source" do
  source 'http://nodejs.org/dist/v0.12.4/node-v0.12.4.tar.gz'
  path '/tmp/node-v0.12.4.tar.gz'
  action :create
end

tar_extract '/tmp/node-v0.12.4.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/node-v0.12.4'
end

execute './configure' do
  action :run
  cwd '/usr/src/node-v0.12.4'
  creates '/usr/src/node-v0.12.4/config.status'
end

execute 'make' do
  action :run
  cwd '/usr/src/node-v0.12.4'
  creates '/usr/src/node-v0.12.4/nodejs'
end

execute 'make install' do
  action :run
  cwd '/usr/src/node-v0.12.4'
  creates '/usr/bin/node'
end
