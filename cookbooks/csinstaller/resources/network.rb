actions :setup
attribute :name, :kind_of => String
attribute :type, :kind_of => String
attribute :traffic_type, :kind_of => Array
attribute :zone_name, :kind_of => String

def initialize(*args)
  super
  @action = :setup
end
