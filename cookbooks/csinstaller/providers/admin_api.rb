include Opscode::Cloudstack::Admin

action :request do
  new_resource.params["command"] = new_resource.command
  if new_resource.async
    response = send_async_request(new_resource.admin_api_endpoint, new_resource.params)
  else
    response = send_request(new_resource.admin_api_endpoint, new_resource.params)
  end
  #setup the zone info
#  case new_resource.command
#  when 'createZone'
#    Chef::Log.info("Zone: #{response['zone']}")
#    node.set['zone']['id'] = response['zone']['id']
#    Chef::Log.info("Zone_id set? #{node['zone']['id']} from #{response['zone']['id']}")
#  when 'createPod'
#    pod = node["zone"]["pods"].find {|pod| pod["name"] == new_resource.params["name"]}
#    pod["id"] = response["pod"]["id"]
#    # node.set['zone']['phy_network']['id'] = response['physicalnetwork']['id']
#  end
end

