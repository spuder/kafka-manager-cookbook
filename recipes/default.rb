#
# Cookbook Name:: kafka-manager
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

kafka_manager 'default' do
  package_version "#{node['kafka-manager']['version']}"
  action :install
end

template '/usr/share/kafka-manager/conf/application.conf' do
  source 'application.conf.erb'
  variables ({
    :zkhosts => "#{node['kafka-manager']['zkhosts']}"
  })
  notifies :restart, 'service[kafka-manager]'
end

service 'kafka-manager' do
  action [ :enable, :start ]
end
