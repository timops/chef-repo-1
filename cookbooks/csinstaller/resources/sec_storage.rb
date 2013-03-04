actions :setup
attribute :zone_name, :kind_of => String
attribute :nfs_server, :kind_of => String
attribute :path, :kind_of => String

def initialize(*args)
  super
  @action = :setup
end
