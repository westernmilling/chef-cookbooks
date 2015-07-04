#
# Cookbook Name:: deploy
# Recipe:: app
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

packages = %w{
  git
  nodejs
}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

gem_package 'bundler' do
  action :install
end
