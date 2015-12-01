#
# Cookbook Name:: kafka-manager
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Create nginx proxy to redirect port 9000 to port 80
kafka_proxy 'default' do
  action :create
end
