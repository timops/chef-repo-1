actions :setup
attribute :name, :kind_of => String
attribute :zone_name, :kind_of => String
attribute :gateway, :kind_of => String
attribute :netmask, :kind_of => String
attribute :start_ip, :kind_of => String
attribute :end_ip, :kind_of => String
attribute :clusters, :kind_of => Array

def initialize(*args)
  super
  @action = :setup
end