actions :setup
attribute :zone_id, :kind_of => String
attribute :hypervisor, :kind_of => String
attribute :pod_id, :kind_of => String
attribute :vcenter_host, :kind_of => String
attribute :vcenter_datacenter, :kind_of => String
attribute :vcenter_cluster, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :admin_api_endpoint, :default => "http://localhost:8096"

def initialize(*args)
    super
    @action = :setup
    @vcenter_cluster = @name
end
