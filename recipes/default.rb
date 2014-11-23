#
# Cookbook Name:: opsmatic_support
# Recipe:: default
#
# Copyright 2014, Gannett
#
# All rights reserved - Do Not Redistribute
#


##Create script to update /etc/opsmatic-agent.conf dynamically

##Read in array of Groups
##Add Environment from box to array and deploy
template "/root/hosts-config.sh" do
  source "hosts-config.sh.erb"
  mode 0700
end

execute 'run hosts-config' do
  command "/root/./hosts-config.sh"
end

ohai "reload" do
  action :reload
end

cron "add_hostname_to_hosts" do
  time :reboot
  action :create
  command "/root/./hosts-config.sh"
end

template "/root/opsmatic_config.sh" do
  source "opsmatic_config.sh.erb"
  mode 0700
end

execute 'run opsmatic config' do
  command "/root/./opsmatic_config.sh"
end

cron "opsmatic_config_reboot_command" do
  time :reboot
  action :create
  command "/root/./opsmatic_config.sh"
end

