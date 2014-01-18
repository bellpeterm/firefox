#
# Cookbook Name:: firefox
# Recipe:: install
#
# Copyright 2014, Peter Bell
#

chef_gem "zip"

case node[:platform]
when "mac_os_x","mac_os_x_server"
  include_recipe "dmg"
  
  dmg_package "Firefox" do
    source node['firefox']['url']
    processes [ "firefox" ]
    version node["firefox"]["version"]
    action :install
  end
  
#  mac_os_x_dockicon "/Applications/Firefox.app" do
#    position "after MissionControl"
#  end
  
when "windows"
  chocolatey "firefox"

else 
  package "firefox"
end

if node['firefox']['global_extensions'] then
  directory "#{node["firefox"]["dir"]}/defaults/preferences" do
    mode 0755
    action :create
  end

  cookbook_file "#{node["firefox"]["dir"]}/defaults/preferences/scopes.js" do
    source "scopes.js"
    mode 0644
    action :create
  end
end
