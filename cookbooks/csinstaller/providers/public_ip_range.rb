include Opscode::Cloudstack::Admin

action :setup do

  zone_id = get_zone_id(new_resource.zone_name)

  resource = send_request(params = {

    "command" => "createVlanIpRange",
    "zoneid" => zone_id,
    "vlan" => new_resource.vlan,
    "gateway" => new_resource.gateway,
    "netmask" => new_resource.netmask,
    "startip" => new_resource.start_ip,
    "endip" => new_resource.end_ip,
    "forVirtualNetwork" => true
}) 

end
