#
# Cookbook Name:: mariadb
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

apt_repository 'mariadb' do
  uri 'http://ftp.utexas.edu/mariadb/repo/10.1/ubuntu'
  components ['main']
  distribution 'trusty'
  keyserver 'keyserver.ubuntu.com'
  key '0xcbcb082a1bb943db'
  action :add
  deb_src true
end
