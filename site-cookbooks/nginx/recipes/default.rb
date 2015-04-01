#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'tar'

packages = %w{
  build-essential
  libcurl4-openssl-dev
  libpcre3-dev
}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file 'nginx' do
  source 'http://nginx.org/download/nginx-1.7.10.tar.gz'
  path '/tmp/nginx-1.7.10.tar.gz'
  action :create
end

tar_extract '/tmp/nginx-1.7.10.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/nginx-1.7.10'
end

execute './configure --conf-path=/etc/nginx/nginx.conf --prefix=/opt/nginx-1.7.10 --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module' do
  action :run
  cwd '/usr/src/nginx-1.7.10'
  creates '/usr/src/nginx-1.7.10/config.status'
end

execute 'make' do
  action :run
  cwd '/usr/src/nginx-1.7.10'
  creates '/usr/src/nginx-1.7.10/make.status'
end

execute 'make install' do
  action :run
  cwd '/usr/src/nginx-1.7.10'
  creates '/opt/nginx-1.7.10'
end

link '/usr/sbin/nginx' do
  action :create
  to '/opt/nginx-1.7.10/sbin/nginx'
end

directory '/etc/nginx' do
  action :create
end

directory '/etc/nginx/ssl' do
  action :create
end

directory '/var/log/nginx' do
  action :create
end

cookbook_file 'nginx.sh' do
  action :create
  path '/etc/init.d/nginx'
  mode '0755'
end

service 'nginx' do
  action [:enable, :start]
  supports :restart => true,
           :reload => true,
           :start => true,
           :stop => true
end
