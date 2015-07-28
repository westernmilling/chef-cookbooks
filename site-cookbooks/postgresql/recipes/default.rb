#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
# include_recipe 'tar'

# packages = %w{
#   bison
#   build-essential
#   flex
#   zlib1g-dev
#   libssl-dev
#   libreadline-dev
#   libxml2-dev
#   libxslt-dev}

# This works, but I'm not sure exactly why... which packages below are needed
# for postgresql-9-4 to install?
packages = %w{
  libpq5
  pgdg-keyring
  postgresql-client-common
  postgresql-9.4}

apt_repository 'postgresql' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  components ['main']
  distribution 'trusty-pgdg'
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

# remote_file 'postgresql-source' do
#   source 'ftp://ftp.postgresql.org/pub/source/v9.4.4/postgresql-9.4.4.tar.gz'
#   path '/tmp/postgresql-9.4.4.tar.gz'
#   action :create
# end
#
# tar_extract '/tmp/postgresql-9.4.4.tar.gz' do
#   action :extract_local
#   target_dir '/usr/src'
#   creates '/usr/src/postgresql-9.4.4'
# end
#
# execute './configure --with-libxml --with-libxslt --with-openssl' do
#   action :run
#   cwd '/usr/src/postgresql-9.4.4'
#   creates '/usr/src/postgresql-9.4.4/config.status'
# end
#
# execute 'make' do
#   action :run
#   cwd '/usr/src/postgresql-9.4.4'
#   creates '/usr/src/postgresql-9.4.4/postgresql'
# end
#
# execute 'make install' do
#   action :run
#   cwd '/usr/src/postgresql-9.4.4'
#   creates '/usr/local/bin/ruby'
# end
