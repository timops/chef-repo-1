include Opscode::Cloudstack::Admin

action :request do
  new_resource.params["command"] = new_resource.command
  if new_resource.async
    response = send_async_request( new_resource.params)
  else
    response = send_request( new_resource.params)
  end
end

