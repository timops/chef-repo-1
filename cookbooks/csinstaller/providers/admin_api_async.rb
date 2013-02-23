include Opscode::Cloudstack::Admin

action :request do
  send_async_request(new_resource.admin_api_endpoint, new_resource.params)
end
