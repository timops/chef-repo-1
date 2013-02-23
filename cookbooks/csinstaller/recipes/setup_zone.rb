#
#if node['zone']['network_type'] == 'Advanced'
#  csinstaller_admin_api "create zone" do
#    command "createZone"
#    params "name" => node['zone']['name'], "networktype" => node['zone']['network_type'],
#    "localstorageenabled" => node['zone']['local_storage_enabled'], "dns1" => node['zone']['dns1'],
#    "dns2" => node['zone']['dns2'], "internaldns1" => node['zone']["internal_dns"],
#    "securitygroupenabled" => node['zone']['security_group_enabled'],
#    "guestcidraddress" => node['zone']['guest_cidr_address']
#  end
#end
#

csinstaller_zone node['zone']['name'] do
  network_type node['zone']['network_type']
  local_storage_enabled node['zone']['localstorageenabled']
  dns1 node['zone']['dns1']
  dns2 node['zone']['dns2']
  internal_dns node['zone']['internal_dns']
  security_group_enabled node['zone']['security_group_enabled']
  guest_cidr_address node['zone']['guest_cidr_address']
end

raise "Cannot find zone id" unless node['zone']['id']

csinstaller_network node['zone']['network']['name'] do
  zone_id node['zone']['id']
  type node['zone']['network_type']
  traffic_type ["Guest", "Management", "Public"]
end

node['zone']['pods'].each do |pod|
    csinstaller_pod pod do
        zone_id node['zone']['id']
        gateway pod['gateway']
        netmask pod['netmask']
        start_ip pod['start_ip']
        end_ip pod['end_ip'] 
    end

    pod['clusters'].each do |cluster|
      csinstaller_cluster cluster do
        zone_id node['zone']['id']
        hypervisor cluster['hypervisor']
        pod_id pod['id']
        username cluster['username']
        password cluster['password']
        vcenter_host cluster['vcenter_host']
        vcenter_datacenter cluster['vcenter_datacenter']
        vcenter_cluster cluster['vcenter_cluster']
      end
    end
end


#node['zone']['pods'].each do |pod|
#  csinstaller_admin_api "create pod" do
## reatePod&zoneId=3a66d327-ce27-4840-8547-6e5d6fad0dad&name=Pod_001&gateway=192.168.100.1&netmask=255.255.255.0&startIp=192.168.100.91&endIp=192.168.100.111
#
#    command "createPod"
#    params "zoneid" => node['zone']['id'], "name" => pod['name'], "gateway" => pod["gateway"],
#           "netmask" => pod["netmask"], "startIp" => pod["start_ip"], "endIp" => pod["end_id"]
#  end
##command=addCluster&zoneId=3a66d327-ce27-4840-8547-6e5d6fad0dad&hypervisor=VMware&clustertype=ExternalManaged&
##podId=116857a5-9bef-476d-96d8-fa64dbeb706c&username=administrator&password=fr3sca&url=http%3A%2F%2F192.168.100.174%2FPune-Opscode-001%2FCluster-001
#
#  pod["clusters"].each do |cluster|
#    if cluster["hypervisor"] == "VMware"
#      csinstaller_admin_api "add cluster" do
#        command "addCluster"
#        params "clustertype" => "ExternalManaged", "podId" => pod["id"],
#            "username" => cluster["username"], "password" => cluster["password"],
#            "url" => "http://#{cluster['vcenter_host']}/#{cluster['vcenter_datacenter']}/#{cluster['vcenter_cluster']}",
#            "clustername" => "http://#{cluster['vcenter_host']}/#{cluster['vcenter_datacenter']}/#{cluster['vcenter_cluster']}"
#      end
#    end
#  end
#end

#createVlanIpRange&zoneId=3a66d327-ce27-4840-8547-6e5d6fad0dad&vlan=untagged&gateway=192.168.100.1&netmask=255.255.255.0&startip=192.168.100.70&endip=192.168.100.90&forVirtualNetwork=true
node["zone"]["public_ip_ranges"].each do |public_ip_range|

  csinstaller_admin_api "create VLAN Ip Range for Public IP Address" do
    command "createVlanIpRange"
    params  "zoneid" => node["zone"]["id"], "vlan" => public_ip_range["vlan"],
            "gateway" => public_ip_range["gateway"], "netmask" => public_ip_range["netmask"],
            "startip" => public_ip_range["startip"], "endip" => public_ip_range["endip"],
            "forVirtualNetwork" => true
  end
end

# command=addSecondaryStorage&zoneId=3a66d327-ce27-4840-8547-6e5d6fad0dad&url=nfs%3A%2F%2F192.168.100.229%2Fmedia%2Fusbdrive%2Fnfs3
node["zone"]["sec_storages"].each do |sec_storage|
  csinstaller_admin_api "add secondary storage" do
    command "addSecondaryStorage"
    params "zone" => node["zone"]["id"], "url" => "nfs://#{sec_storage['nfs_server']}/#{sec_storage['path']}"
  end
end


