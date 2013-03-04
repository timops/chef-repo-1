actions :setup
attribute :zone_name, :kind_of => String
attribute :vlan, :kind_of => String
attribute :gateway, :kind_of => String
attribute :netmask, :kind_of => String
attribute :start_ip, :kind_of => String
attribute :end_ip, :kind_of => String

def initialize(*args)
  super
  @action = :setup
end
