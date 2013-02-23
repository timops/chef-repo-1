include Opscode::Cloudstack::Admin

action :setup do
    response = send_request(new_resource.admin_api_endpoint, 
    {
        "command" => "createZone",
        "zoneid" => new_resource.zone_id, 
        "name" => new_resource.name,
        "gateway" => new_resource.gateway,
        "netmask" => new_resource.netmask,
        "startIp" => new_resource.start_ip,
        "endIp" => new_resource.end_ip
    })

    #Dirrrrrty - find a elegant solution
  for i in 0..len(node['zone']['pods'])
      if node['zone']['pods'][i]['name'] == new_resource.name
          node.set['zone']['pods'][i]['id'] = response['pod']['id']
          node.save unless Chef::Config[:solo]
          return
      end
  end
end
