#
# Cookbook Name:: imagemagick
# Recipe:: default
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# http://imagemagick.org/script/install-source.php
#
include_recipe 'apt'
include_recipe 'tar'

packages = %w{ghostscript libjpeg-dev libpng-dev libtiff-dev}

packages.each do |pkg|
  apt_package pkg do
    action :install
  end
end

remote_file "source" do
  source 'http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-10.tar.xz'
  path '/tmp/ImageMagick-6.9.1-10.tar.xz'
  action :create
end

tar_extract '/tmp/ImageMagick-6.9.1-10.tar.xz' do
  action :extract_local
  target_dir '/usr/src'
  compress_char ''
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
