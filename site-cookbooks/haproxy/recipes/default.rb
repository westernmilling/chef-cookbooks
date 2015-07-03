#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2015, joe@westernmilling.com
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'tar'

packages = %w{
  build-essential
  make
  libpcre3-dev
  g++
  libssl-dev
  zlib1g-dev
}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file 'haproxy-source' do
  source 'http://www.haproxy.org/download/1.5/src/haproxy-1.5.11.tar.gz'
  path '/tmp/haproxy-1.5.11.tar.gz'
  action :create
end

tar_extract '/tmp/haproxy-1.5.11.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/haproxy-1.5.11'
end

execute 'make TARGET=linux2628 CPU=native USE_PCRE=1 USE_LIBCRYPT=1 USE_OPENSSL=1 USE_LINUX_SPLICE=1 USE_LINUX_TPROXY=1 USE_ZLIB=1' do
  action :run
  cwd '/usr/src/haproxy-1.5.11'
  creates '/usr/src/haproxy-1.5.11/haproxy'
end

execute 'make install' do
  action :run
  cwd '/usr/src/haproxy-1.5.11'
  creates '/usr/local/sbin/haproxy'
end

link '/usr/sbin/haproxy' do
  action :create
  to '/usr/local/sbin/haproxy'
end

directory '/etc/haproxy' do
  action :create
end

directory '/etc/haproxy/ssl' do
  action :create
end

cookbook_file 'haproxy.sh' do
  action :create
  path '/etc/init.d/haproxy'
  mode '0755'
end

cookbook_file 'rsyslog.d.conf' do
  action :create
  path '/etc/rsyslog.d/49-haproxy.conf'
end

service 'haproxy' do
  action [:enable, :start]
  supports :restart => true,
           :reload => true,
           :start => true,
           :stop => true
end
