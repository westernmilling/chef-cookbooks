#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

packages = %w{
  libpq-dev}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end
