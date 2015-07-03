#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'tar'

packages = %w{
  build-essential
  tcl8.5}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file 'redis-source' do
  source 'http://download.redis.io/releases/redis-3.0.0.tar.gz'
  path '/tmp/redis-3.0.0.tar.gz'
  action :create
end

tar_extract '/tmp/redis-3.0.0.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/redis-3.0.0'
end

execute 'make' do
  action :run
  cwd '/usr/src/redis-3.0.0'
  creates '/usr/src/redis-3.0.0/redis'
end

execute 'make install' do
  action :run
  cwd '/usr/src/redis-3.0.0'
  creates '/usr/local/bin/redis'
end

execute './install_server.sh' do
  action :run
  cwd '/usr/src/redis-3.0.0/utils'
  creates '/etc/init.d/redis_6379'
end

service 'redis_6379' do
  action [:enable, :start]
end
