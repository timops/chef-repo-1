actions :setup
attribute :name, :kind_of => String
attribute :admin_api_endpoint, :default => "http://localhost:8096"
attribute :zone_id, :kind_of => String
attribute :gateway, :kind_of => String
attribute :netmask, :kind_of => String
attribute :start_ip, :kind_of => String
attribute :end_ip, :kind_of => String

def initialize(*args)
  super
  @action = :setup
end
