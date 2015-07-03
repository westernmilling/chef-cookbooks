#
# Cookbook Name:: deploy
# Recipe:: user
#
# Copyright 2015, Joseph Bridgwater-Rowe
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'user'

user 'deploy' do
  action :create
  home '/home/deploy'
  manage_home true
  shell '/bin/bash'
end

user 'deploy' do
  action :lock
end

directory '/home/deploy/.ssh' do
  group 'deploy'
  owner 'deploy'
  mode '0700'
  action :create
end

file '/home/deploy/.ssh/authorized_keys' do
  group 'deploy'
  owner 'deploy'
  mode '0600'
  action :create_if_missing
end

ruby_block 'to add local user ssh key' do
  block do
    key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNVzHNpomHRRlDQDM8kjuswT1vrgeX/AtD2lpEqSkvK7bpos4lbulFbK/sQZMc5S7eg8phFT0GRwfYkmggmMEAwImEKOEFkQIvPIZ+BjZWdwXuRSt+6TmeQZAkvkb4rTyfCCtAE2mJXd/fL9n3iTLqcdTV3Y4yYeU1vOARMEy4vF4JuZ776H5eMSMSAmLuH+0hilJEWYo78NItvajTS0Hvnt2gzWIZySnn+brClY2rDm5AxOqhZoi9TloUK0+DpQmiLc42LNgBmw3wRL6raXfo+Na5e7hNgDCO7hWWoWtWBs1g4mNDkHVtTalyRTF+1g/+U3UgUtM6aKc9uWmssE1z josephbridgwaterrowe@Josephs-MacBook-Pro.local"

    file = Chef::Util::FileEdit.new("/home/deploy/.ssh/authorized_keys")
    file.insert_line_if_no_match("/#{key}/", key)
    file.write_file
  end
end
