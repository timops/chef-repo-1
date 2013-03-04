#
# Cookbook Name:: cloudstack-installer
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# response = csinstaller_admin_api 'list zones' do
#   action [:request]
#   params  "command" => "listZones"
# end

# print response


# csinfo = Chef::DataBag.new
# csinfo.name("csinfo")
# csinfo.save


include_recipe "csinstaller::setup_zone"
