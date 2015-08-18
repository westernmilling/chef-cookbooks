#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

packages = %w{
  rabbitmq-server
}

remote_file 'rabbitmq-apt-key' do
  source 'https://www.rabbitmq.com/rabbitmq-signing-key-public.asc'
  path '/tmp/rabbitmq-signing-key-public.asc'
  action :create
end

execute 'sudo apt-key add rabbitmq-signing-key-public.asc' do
  action :run
  cwd '/tmp'
end

apt_repository 'rabbitmq' do
  uri 'http://www.rabbitmq.com/debian/'
  components ['main']
  distribution 'testing'
  keyserver 'keyserver.ubuntu.com'
  key 'ACCC4CF8'
  action :add
  deb_src false
end

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end
