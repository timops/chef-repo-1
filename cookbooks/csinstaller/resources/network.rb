actions :setup
attribute :name
attribute :type
attribute :traffic_type
attribute :admin_api_endpoint, :default => "http://localhost:8096"
attribute :zone_id

def initialize(*args)
  super
  @action = :setup
end
