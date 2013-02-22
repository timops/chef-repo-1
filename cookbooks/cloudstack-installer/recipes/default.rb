#
# Cookbook Name:: cloudstack-installer
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
admin_api 'list zones' do
  action [:request]
  params  "action" => "listZones"
end
