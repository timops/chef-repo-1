#
# Cookbook Name:: cloudstack-installer
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# Turn off SELinux
script "disable_selinux" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
     setenforce 0
     sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
  EOH
  only_if {File.exists?("/etc/selinux/config")}
end

# Download the cloudstack package from HTTP/FTP

#Untar the tar gz

# ./install.sh -m
#  wget http://192.168.100.192/CloudStack-3.0.6-0.4203-rhel6.2.tar.gz

script "install_mgmt_server" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget -c -nc http://172.31.6.97/CloudStack-3.0.6-0.4203-rhel6.2.tar.gz

  tar -zxf CloudStack-3.0.6-0.4203-rhel6.2.tar.gz
  cd CloudStack-3.0.6-0.4203-rhel6.2
  ./install.sh -m
  EOH
end
#  ./install.sh -d
%w{rpcbind nfs-utils nfs-utils-lib
  }.each do |package_name|
    yum_package package_name do
    end
  end

yum_package "nfs" do
  arch "x86_64"
end

[
  "rpcbind", "nfs"
].each do |service_name|
  service service_name do
    action [:start, :enable]
  end
end

execute "cloud-setup-databases" do
  command "cloud-setup-databases cloud:fr3sca@localhost --deploy-as=root:fr3sca"
end

execute 'cloud-setup-management' do
  command "cloud-setup-management"
end
# start, initialize nfs, rpcbind


# install the db server
#./install.sh -d


# Configure DB server
#innodb_rollback_on_timeout=1
# innodb_lock_wait_timeout=600
# max_connections=350
# log-bin=mysql-bin
# binlog-format = 'ROW'

#restart mysql

#set mysql password

#cloud setup database

#cloud setup management

#sleep, enable port 8096
service 'cloud-management' do
  action [:stop]
end
script "enable_mgmt_port" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  mysql -ucloud -pfr3sca -Dcloud  -e "update configuration set value=8096 where name='integration.api.port'"
  EOH
end

service 'cloud-management' do
  action [:start]
end



