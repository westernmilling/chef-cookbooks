#
# Cookbook Name:: imagemagick
# Recipe:: default
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
include_recipe 'apt'
include_recipe 'tar'

packages = %w{ghostscript}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file "source" do
  source 'http://www.imagemagick.org/download/ImageMagick-6.9.1-10.tar.gz'
  path '/tmp/ImageMagick-6.9.1-10.tar.gz'
  action :create
end

tar_extract '/tmp/ImageMagick-6.9.1-10.tar.gz' do
  action :extract_local
  target_dir '/usr/src'
  creates '/usr/src/ImageMagick-6.9.1-10'
end

execute './configure' do
  action :run
  cwd '/usr/src/ImageMagick-6.9.1-10'
  creates '/usr/src/ImageMagick-6.9.1-10/config.status'
end

execute 'make' do
  action :run
  cwd '/usr/src/ImageMagick-6.9.1-10'
  creates '/usr/src/ImageMagick-6.9.1-10/magick/ImageMagick-6.Q16.pc'
end

execute 'make install' do
  action :run
  cwd '/usr/src/ImageMagick-6.9.1-10'
  creates '/usr/local/bin/convert'
end

execute 'ldconfig /usr/local/lib' do
  action :run
end
