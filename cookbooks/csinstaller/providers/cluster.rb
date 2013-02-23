include Opscode::Cloudstack::Admin

action :setup do

  if new_resource.hypervisor == "VMWare"
    response = send_request(new_resource.admin_api_endpoint,
    {

    "command" => "addCluster",
    "clustertype" => "ExternalManaged", 
    "podId" => new_resource.pod_id,
    "username" => new_resource.username, 
    "password" => new_resource.password,
    "url" => "http://#{new_resource.vcenter_host}/#{new_resource.vcenter_datacenter}/#{new_resource.vcenter_cluster}",
    "cluster" => "http://#{new_resource.vcenter_host}/#{new_resource.vcenter_datacenter}/#{new_resource.vcenter_cluster}",
 
    })

  end

    #Dirrrrrty - find a elegant solution
    for i in 0..len(node['zone']['pods'])
        if node['zone']['pods'][i]['id'] == new_resource.pod_id
            for j in 0..len(node['zone']['pods'][i]['clusters'])
                if node['zone']['pods'][i]['clusters'][j]['name'] == new_resource.vcenter_cluster
                    node.set['zone']['pods'][i]['clusters'][j]['id'] = response['cluster'].first['id']
                    node.save unless Chef::Config[:solo]
                    return
                end
            end
        end
    end
end
