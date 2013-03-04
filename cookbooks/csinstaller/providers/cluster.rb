include Opscode::Cloudstack::Admin

action :setup do

 # if new_resource.hypervisor == "VMWare"
    response = send_request(
    {
    "zoneid" => new_resource.zone_id,
    "command" => "addCluster",
    "clustertype" => "ExternalManaged", 
    "podId" => new_resource.pod_id,
    "username" => new_resource.username, 
    "password" => new_resource.password,
    "url" => "http://#{new_resource.vcenter_host}/#{new_resource.vcenter_datacenter}/#{new_resource.vcenter_cluster}",
    "clustername" => "http://#{new_resource.vcenter_host}/#{new_resource.vcenter_datacenter}/#{new_resource.vcenter_cluster}",
    "hypervisor" => new_resource.hypervisor 
    })

end
