actions :setup, :enable
attribute :name
attribute :id
attribute :network_type
attribute :local_storage_enabled
attribute :dns1
attribute :dns2
attribute :internal_dns
attribute :security_group_enabled
attribute :guest_cidr_address

def initialize(*args)
  super
  @action = :setup
end
