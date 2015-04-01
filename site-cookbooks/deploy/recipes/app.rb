#
# Cookbook Name:: deploy
# Recipe:: app
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
# include_recipe 'apt'

apt_package 'nodejs' do
  action :install
end

gem_package 'bundler' do
  action :install
end