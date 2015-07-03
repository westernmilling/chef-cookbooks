#
# Cookbook Name:: mariadb
# Recipe:: client
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

apt_package 'mariadb-client' do
  action :install
end

apt_package 'libmariadbclient-dev' do
  action :install
end
