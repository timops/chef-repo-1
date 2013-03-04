include Opscode::Cloudstack::Admin

action :setup do

    zone_id = get_zone_id(node["zone"]["name"])

    response = send_request(
    {
        "command" => "createPod",
        "zoneid" => zone_id,
        "name" => new_resource.name,
        "gateway" => new_resource.gateway,
        "netmask" => new_resource.netmask,
        "startIp" => new_resource.start_ip,
        "endIp" => new_resource.end_ip
    })

  Chef::Log.info("clusters: #{new_resource.clusters}")
  new_resource.clusters.each do |cluster|
    csinstaller_cluster cluster['vcenter_cluster'] do
      zone_id zone_id
      hypervisor cluster['hypervisor']
      pod_id response["pod"]["id"]
      username cluster['username']
      password cluster['password']
      vcenter_host cluster['vcenter_host']
      vcenter_datacenter cluster['vcenter_datacenter']
      vcenter_cluster cluster['vcenter_cluster']
    end

    if cluster['primary_storages']
      cluster['primary_storages'].each do |pri_storage|
        csinstaller_admin_api "Add Primary Storage" do
          command "createStoragePool"
          params "name" => pri_storage['name'], "zoneid" => zone_id, "podid" => pod_id, "clusterid" => response["cluster"].first["id"],
                  "url" => "nfs://#{pri_storage["nfs_server"]}/#{pri_storage["path"]}"
        end
      end


    end


  end
end
