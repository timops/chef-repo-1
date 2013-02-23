actions :request
attribute :command, :kind_of => String
attribute :async, :default => false
attribute :params
attribute :admin_api_endpoint, :default => "http://localhost:8096"

def initialize(*args)
  super
  @action = :request
end
