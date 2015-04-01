#
# Cookbook Name:: ruby_from_source
# Recipe:: default
#
# Copyright 2014, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt"
include_recipe "tar"

packages = %w{curl
  zlib1g-dev
  build-essential
  libssl-dev
  libreadline-dev
  libyaml-dev
  libsqlite3-dev
  sqlite3
  libxml2-dev
  libxslt1-dev
  libcurl4-openssl-dev
  python-software-properties
  openjdk-7-jdk
  ant
  maven}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file 'jruby-source' do
  source 'https://s3.amazonaws.com/jruby.org/downloads/1.7.19/jruby-src-1.7.19.tar.gz'
  path '/tmp/jruby-src-1.7.19.tar.gz'
  action :create
end

# tar_extract 'http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz' do
tar_extract '/tmp/jruby-src-1.7.19.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/jruby-1.7.19'
end

execute 'mvn install' do
  action :run
  cwd '/usr/src/jruby-1.7.19'
  creates '/usr/src/jruby-1.7.19/bin/jruby'
end

# Move /usr/src/jruby-1.7.19/bin, core, lib to somewhere else in path
