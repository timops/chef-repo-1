include Opscode::Cloudstack::Admin

action :setup do
  zone_id = get_zone_id(new_resource.zone_name)
  response = send_request({
  "command" => "addSecondaryStorage",
  "zoneid" => zone_id,
  "url" => "nfs://#{new_resource.nfs_server}/#{new_resource.path}"
  })

end

