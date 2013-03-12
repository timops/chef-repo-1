default['cloudstack_version'] = "3.0.6-0.4320-rhel6.2"
default['download_url'] = "http://localhost"
default['zone']['name'] = "Opscode-Zone-001"
default['zone']['network_type'] = 'Advanced'
default['zone']['local_storage_enabled'] = "true"
default['zone']['dns1'] = '8.8.8.8'
default['zone']['dns2'] = '4.4.4.4'
default['zone']['internal_dns'] = '192.168.100.1'
default['zone']['security_group_enabled'] = false
default['zone']['guest_cidr_address'] = "10.1.1.0/16"

default['zone']['network']['name'] = "PhysicalNetwork1"

default['zone']['pods'] = [
  {
    "name" => "Pod_001",
    "gateway" => "192.168.100.1",
    "netmask" => "255.255.255.0",
    "start_ip" => "192.168.100.70",
    "end_ip" => "192.168.100.90",
    "clusters" => [{
       "primary_storages" => [{
              "name" => "nfs-4",
              "nfs_server" => "192.168.100.229",
              "path" => "/media/usbdrive/nfs4"

      }],     
      "hypervisor" => "VMware",
      "username" => "Administrator",
      "password" => "fr3sca",
      "vcenter_host" => "192.168.100.174",
      "vcenter_datacenter" => "Pune-Opscode-001",
      "vcenter_cluster" => "Cluster-001",

    }]
}
]

default['zone']['public_ip_ranges'] = [{
  "vlan" => "untagged",
  "start_ip" => "192.168.100.91",
  "end_ip" => "192.168.100.111",
  "gateway" => "192.168.100.1",
  "netmask" => "255.255.255.0"
}]

#default['zone']['primary_storages'] = [{
#  "name" => "nfs-4",
#  "nfs_server" => "192.168.100.229",
#  "path" => "/media/usbdrive/nfs4"
#
#}]

default['zone']['sec_storages'] = [
  {
    "nfs_server" => "192.168.100.229",
    "path" => "/media/usbdrive/nfs3"
  }

]
