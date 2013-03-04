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

%w{rpcbind nfs-utils nfs-utils-lib
  }.each do |package_name|
    yum_package package_name do
    end
  end

[
  "rpcbind", "nfs"
].each do |service_name|
  service service_name do
    action [:start, :enable]
  end
end

execute "cloud-setup-databases" do
  command "cloud-setup-databases cloud:#{node['mysql']['server_root_password']}@localhost --deploy-as=root:#{node['mysql']['server_root_password']}"
end

execute 'cloud-setup-management' do
  command "cloud-setup-management"
end

directory '/mnt/secondary' do
  owner "root"
  group "root"
end

mount '/mnt/secondary' do
  fstype 'nfs'
  device "#{node['zone']['sec_storages'].first['nfs_server']}:#{node['zone']['sec_storages'].first['path']}"
  action :mount
end

script "install system VM template" do
  interpreter "bash"
  user "root"
  code "<<-EOH
      /usr/lib64/cloud/agent/scripts/storage/secondary/cloud-install-sys-tmplt -m\
      /mnt/secondary -u http://download.cloud.com/templates/acton/acton-systemvm-02062012.ova\
      -h vmware
  EOH"
end
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

if node['zone']['local_storage_enabled']
  script "allow system vms to use local storage" do
    interpreter "bash"
    user "root"
    cwd "/tmp"
    code <<-EOH
    mysql -ucloud -pfr3sca -Dcloud  -e "update configuration set value=true where name='system.vm.use.local.storage'"
    EOH
  end
end

service 'cloud-management' do
  action [:start]
end



