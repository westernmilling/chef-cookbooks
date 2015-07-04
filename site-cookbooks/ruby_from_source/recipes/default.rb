#
# Cookbook Name:: ruby_from_source
# Recipe:: default
#
# Copyright 2014, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'tar'

packages = %w{
  autoconf
  bison
  build-essential
  curl
  zlib1g-dev
  libffi-dev
  libgdbm3
  libgdbm-dev
  libncurses5-dev
  libssl-dev
  libreadline-dev
  libyaml-dev
  libsqlite3-dev
  sqlite3
  libxml2-dev
  libxslt1-dev
  libcurl4-openssl-dev
  python-software-properties}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file "ruby-source" do
  source 'http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz'
  path '/tmp/ruby-2.2.2.tar.gz'
  action :create
end

# tar_extract 'http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.2.1.tar.gz' do
tar_extract '/tmp/ruby-2.2.2.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/ruby-2.2.2'
end

execute './configure CONFIGURE_OPTS=-fPIC' do
  action :run
  cwd '/usr/src/ruby-2.2.2'
  creates '/usr/src/ruby-2.2.2/config.status'
end

execute 'make' do
  action :run
  cwd '/usr/src/ruby-2.2.2'
  creates '/usr/src/ruby-2.2.2/ruby'
end

execute 'make install' do
  action :run
  cwd '/usr/src/ruby-2.2.2'
  creates '/usr/local/bin/ruby'
end
