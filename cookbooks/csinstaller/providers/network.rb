include Opscode::Cloudstack::Admin

action :setup do

  zone_id = get_zone_id(node["zone"]["name"])
  response = send_async_request(
  {
    "command" => "createPhysicalNetwork",
    "zoneid" => zone_id,
    "name" => new_resource.name
    })

  phy_network = response['physicalnetwork']
  new_resource.traffic_type.each do |traffic_type|
    csinstaller_admin_api "add traffic type" do
      command "addTrafficType"
      async true
      params "trafficType" => traffic_type, "physicalnetworkid" => phy_network['id']
    end
  end

  csinstaller_admin_api "Enable physical network" do
    command "updatePhysicalNetwork"
    async true
    params "state" => "Enabled", "id" => phy_network['id']
  end

  ["VirtualRouter", "VpcVirtualRouter" ].each do |nsp_type|
    response = send_request(
      {
        "command" => "listNetworkServiceProviders",
        "name" => nsp_type,
        "physicalNetworkId" => phy_network['id']
    })

    nsp = response['networkserviceprovider'][0]
    response = send_request(
    {
      "command" => "listVirtualRouterElements",
      "nspid" => nsp['id']
      })

    vre = response['virtualrouterelement'][0]

    csinstaller_admin_api "configure virtual router element" do
      command "configureVirtualRouterElement"
      params "enabled" => true, "id" => vre['id']
      async true
    end

    csinstaller_admin_api "update network service provider" do
      command "updateNetworkServiceProvider"
      params "state" => "Enabled", "id" => nsp['id']
      async true
    end

  end

  csinstaller_admin_api "update network with VLAN range" do
    command "updatePhysicalNetwork"
    params "vlan" => "699-999", "id" => phy_network['id']
  end
end


